import 'package:dartz/dartz.dart';
import 'package:habit_boost/core/error/exceptions.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/core/sync/sync_service.dart';
import 'package:habit_boost/features/journal/data/datasources/journal_local_datasource.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';
import 'package:habit_boost/features/journal/domain/repositories/journal_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: JournalRepository)
class JournalRepositoryImpl implements JournalRepository {
  const JournalRepositoryImpl(this._local, this._syncService);

  final JournalLocalDataSource _local;
  final SyncService _syncService;

  @override
  Future<Either<Failure, List<JournalEntry>>> getEntries(
    String userId,
  ) async {
    try {
      final entries = await _local.getEntries(userId);
      return Right(entries);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, JournalEntry>> createEntry(
    JournalEntry entry,
  ) async {
    try {
      final now = DateTime.now();
      final newEntry = entry.copyWith(
        id: now.microsecondsSinceEpoch.toString(),
        createdAt: now,
        updatedAt: now,
      );
      await _local.insertEntry(newEntry);
      await _syncService.enqueueAndSync(
        entityType: 'journal',
        entityId: newEntry.id,
        userId: newEntry.userId,
        action: 'upsert',
      );
      return Right(newEntry);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, JournalEntry>> updateEntry(
    JournalEntry entry,
  ) async {
    try {
      await _local.updateEntry(entry);
      await _syncService.enqueueAndSync(
        entityType: 'journal',
        entityId: entry.id,
        userId: entry.userId,
        action: 'upsert',
      );
      return Right(entry.copyWith(updatedAt: DateTime.now()));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEntry(String id) async {
    try {
      final entry = await _local.getEntry(id);
      await _local.deleteEntry(id);
      if (entry != null) {
        await _syncService.enqueueAndSync(
          entityType: 'journal',
          entityId: id,
          userId: entry.userId,
          action: 'delete',
        );
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
