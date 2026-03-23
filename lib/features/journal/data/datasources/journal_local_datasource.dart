import 'package:drift/drift.dart';
import 'package:habit_boost/core/database/app_database.dart';
import 'package:habit_boost/core/error/exceptions.dart';
import 'package:habit_boost/core/utils/app_logger.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class JournalLocalDataSource {
  const JournalLocalDataSource(this._db);

  final AppDatabase _db;

  Future<List<JournalEntry>> getEntries(String userId) async {
    try {
      final rows = await (_db.select(_db.journalEntriesTable)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([
              (t) => OrderingTerm.desc(t.date),
            ]))
          .get();
      return rows.map(_entryFromRow).toList();
    } catch (e) {
      log.e('Failed to get journal entries', error: e);
      throw CacheException(
        'Failed to get journal entries: $e',
      );
    }
  }

  Future<void> insertEntry(JournalEntry entry) async {
    log.d('insertEntry: mood=${entry.mood.name}, '
        'tags=${entry.tags}');
    await _db.into(_db.journalEntriesTable).insert(
          JournalEntriesTableCompanion.insert(
            id: entry.id,
            userId: entry.userId,
            date: entry.date,
            content: entry.content,
            mood: Value(entry.mood.name),
            tags: Value(entry.tags.join(',')),
            createdAt: entry.createdAt ?? DateTime.now(),
            updatedAt: entry.updatedAt ?? DateTime.now(),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> updateEntry(JournalEntry entry) async {
    await (_db.update(_db.journalEntriesTable)
          ..where((t) => t.id.equals(entry.id)))
        .write(
      JournalEntriesTableCompanion(
        content: Value(entry.content),
        mood: Value(entry.mood.name),
        tags: Value(entry.tags.join(',')),
        date: Value(entry.date),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<JournalEntry?> getEntry(String id) async {
    final rows = await (_db.select(_db.journalEntriesTable)
          ..where((t) => t.id.equals(id)))
        .get();
    if (rows.isEmpty) return null;
    return _entryFromRow(rows.first);
  }

  Future<void> deleteEntry(String id) async {
    await (_db.delete(_db.journalEntriesTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  JournalEntry _entryFromRow(JournalEntriesTableData row) {
    return JournalEntry(
      id: row.id,
      userId: row.userId,
      date: row.date,
      content: row.content,
      mood: Mood.fromString(row.mood),
      tags: row.tags.isEmpty
          ? const []
          : row.tags.split(','),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
