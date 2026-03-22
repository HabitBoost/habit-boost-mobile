import 'package:dartz/dartz.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';

abstract class JournalRepository {
  Future<Either<Failure, List<JournalEntry>>> getEntries(
    String userId,
  );
  Future<Either<Failure, JournalEntry>> createEntry(
    JournalEntry entry,
  );
  Future<Either<Failure, JournalEntry>> updateEntry(
    JournalEntry entry,
  );
  Future<Either<Failure, void>> deleteEntry(String id);
}
