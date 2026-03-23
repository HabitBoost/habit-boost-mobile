import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_boost/core/database/app_database.dart';
import 'package:habit_boost/core/network/network_info.dart';
import 'package:habit_boost/core/utils/app_logger.dart';
import 'package:habit_boost/features/habits/data/datasources/habits_local_datasource.dart';
import 'package:habit_boost/features/habits/data/datasources/habits_remote_datasource.dart';
import 'package:habit_boost/features/journal/data/datasources/journal_local_datasource.dart';
import 'package:habit_boost/features/journal/data/datasources/journal_remote_datasource.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SyncService {
  SyncService(
    this._db,
    this._networkInfo,
    this._habitsLocal,
    this._habitsRemote,
    this._journalLocal,
    this._journalRemote,
    this._firebaseAuth,
  );

  final AppDatabase _db;
  final NetworkInfo _networkInfo;
  final HabitsLocalDataSource _habitsLocal;
  final HabitsRemoteDataSource _habitsRemote;
  final FirebaseAuth _firebaseAuth;
  final JournalLocalDataSource _journalLocal;
  final JournalRemoteDataSource _journalRemote;

  bool _flushing = false;

  Future<void> enqueueAndSync({
    required String entityType,
    required String entityId,
    required String userId,
    required String action,
  }) async {
    await _db.into(_db.syncQueueTable).insert(
          SyncQueueTableCompanion.insert(
            entityType: entityType,
            entityId: entityId,
            userId: userId,
            action: action,
            createdAt: DateTime.now(),
          ),
        );
    // Fire-and-forget flush attempt
    unawaited(flushQueue());
  }

  Future<void> flushQueue() async {
    if (_flushing) return;
    _flushing = true;

    try {
      if (!await _networkInfo.isConnected) return;

      final rows = await (_db.select(_db.syncQueueTable)
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

      final currentUid = _firebaseAuth.currentUser?.uid;

      for (final row in rows) {
        // Skip stale entries with wrong userId
        if (currentUid != null && row.userId != currentUid) {
          log.w('Removing stale sync entry: '
              '${row.entityType}/${row.entityId} '
              '(userId=${row.userId}, expected=$currentUid)');
          await (_db.delete(_db.syncQueueTable)
                ..where((t) => t.id.equals(row.id)))
              .go();
          continue;
        }

        try {
          await _processQueueEntry(row);
          await (_db.delete(_db.syncQueueTable)
                ..where((t) => t.id.equals(row.id)))
              .go();
        } on Exception catch (e) {
          log.w(
            'Sync failed for ${row.entityType}/${row.entityId}',
            error: e,
          );
          break;
        }
      }
    } finally {
      _flushing = false;
    }
  }

  /// Migrate old data created with 'local_user' userId
  /// to the real Firebase UID.
  Future<void> migrateLocalUserData(String firebaseUid) async {
    const oldId = 'local_user';
    if (firebaseUid.isEmpty || firebaseUid == oldId) return;

    // Migrate habits
    final habitsUpdated = await (_db.update(_db.habitsTable)
          ..where((t) => t.userId.equals(oldId)))
        .write(HabitsTableCompanion(userId: Value(firebaseUid)));

    // Completions don't have userId — they link via habitId,
    // so they follow the habit migration automatically.

    // Migrate journal entries
    final journalUpdated = await (_db.update(_db.journalEntriesTable)
          ..where((t) => t.userId.equals(oldId)))
        .write(JournalEntriesTableCompanion(userId: Value(firebaseUid)));

    // Migrate sync queue entries
    final queueUpdated = await (_db.update(_db.syncQueueTable)
          ..where((t) => t.userId.equals(oldId)))
        .write(SyncQueueTableCompanion(userId: Value(firebaseUid)));

    if (habitsUpdated + journalUpdated + queueUpdated > 0) {
      log.i('Migrated local_user data to $firebaseUid: '
          '$habitsUpdated habits, '
          '$journalUpdated journal, $queueUpdated queue entries');
    }
  }

  Future<void> pullAndMerge(String userId) async {
    // Migrate any legacy local_user data first
    await migrateLocalUserData(userId);

    if (!await _networkInfo.isConnected) return;

    try {
      await _pullHabits(userId);
    } on Exception catch (e) {
      log.w('Pull habits failed', error: e);
    }
    try {
      await _pullCompletions(userId);
    } on Exception catch (e) {
      log.w('Pull completions failed', error: e);
    }
    try {
      await _pullJournal(userId);
    } on Exception catch (e) {
      log.w('Pull journal failed', error: e);
    }
    try {
      await flushQueue();
    } on Exception catch (e) {
      log.w('Flush queue failed', error: e);
    }
    log.i('Pull & merge completed for $userId');
  }

  Future<void> _processQueueEntry(SyncQueueTableData row) async {
    switch (row.entityType) {
      case 'habit':
        if (row.action == 'delete') {
          await _habitsRemote.deleteHabit(row.entityId, row.userId);
        } else {
          final habit = await _habitsLocal.getHabit(row.entityId);
          await _habitsRemote.upsertHabit(habit);
        }
      case 'completion':
        if (row.action == 'delete') {
          await _habitsRemote.deleteCompletion(row.entityId, row.userId);
        } else {
          // Completions don't have a direct getById — upsert is handled
          // by re-reading from local in the repository before enqueue.
          // For now, skip individual completion sync;
          // pullAndMerge handles full reconciliation.
        }
      case 'journal':
        if (row.action == 'delete') {
          await _journalRemote.deleteEntry(row.entityId, row.userId);
        } else {
          final entries = await _journalLocal.getEntries(row.userId);
          final entry = entries.where((e) => e.id == row.entityId).firstOrNull;
          if (entry != null) {
            await _journalRemote.upsertEntry(entry, row.userId);
          }
        }
    }
  }

  Future<void> _pullHabits(String userId) async {
    final remoteHabits =
        await _habitsRemote.getHabits(userId);
    log.d('Pull habits: ${remoteHabits.length} remote');
    final localHabits =
        await _habitsLocal.getHabits(userId);
    log.d('Pull habits: ${localHabits.length} local');
    final localMap = {
      for (final h in localHabits) h.id: h,
    };

    for (final remote in remoteHabits) {
      final local = localMap[remote.id];
      if (local == null) {
        await _habitsLocal.insertHabit(remote);
      } else {
        final remoteTime = remote.updatedAt ?? DateTime(2020);
        final localTime = local.updatedAt ?? DateTime(2020);
        if (remoteTime.isAfter(localTime)) {
          await _habitsLocal.updateHabit(remote);
        }
      }
      localMap.remove(remote.id);
    }

    // Local-only habits — push to remote
    for (final local in localMap.values) {
      await _habitsRemote.upsertHabit(local);
    }
  }

  Future<void> _pullCompletions(String userId) async {
    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 90));
    final remoteCompletions =
        await _habitsRemote.getCompletions(userId, monthAgo, now);
    final localCompletions =
        await _habitsLocal.getCompletionsForDate(userId, now);
    // Build a broader local set for merge
    final allLocalIds = <String>{};
    for (final c in localCompletions) {
      allLocalIds.add(c.id);
    }

    for (final remote in remoteCompletions) {
      if (!allLocalIds.contains(remote.id)) {
        await _habitsLocal.insertCompletion(remote);
      }
    }
  }

  Future<void> _pullJournal(String userId) async {
    final remoteEntries =
        await _journalRemote.getEntries(userId);
    log.d('Pull journal: ${remoteEntries.length} remote');
    final localEntries =
        await _journalLocal.getEntries(userId);
    log.d('Pull journal: ${localEntries.length} local');
    final localMap = {
      for (final e in localEntries) e.id: e,
    };

    for (final remote in remoteEntries) {
      final local = localMap[remote.id];
      if (local == null) {
        log.d('Inserting remote journal: ${remote.id}');
        await _journalLocal.insertEntry(remote);
      } else {
        final remoteTime =
            remote.updatedAt ?? DateTime(2020);
        final localTime =
            local.updatedAt ?? DateTime(2020);
        if (remoteTime.isAfter(localTime)) {
          await _journalLocal.updateEntry(remote);
        }
      }
      localMap.remove(remote.id);
    }

    // Local-only entries — push to remote
    for (final local in localMap.values) {
      await _journalRemote.upsertEntry(local, userId);
    }
  }
}

// Helper to suppress unawaited future lint
void unawaited(Future<void>? future) {}
