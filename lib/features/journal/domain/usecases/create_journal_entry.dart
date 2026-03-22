import 'package:dartz/dartz.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/core/usecases/usecase.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';
import 'package:habit_boost/features/journal/domain/repositories/journal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateJournalEntry
    extends UseCase<JournalEntry, JournalEntry> {
  CreateJournalEntry(this._repository);

  final JournalRepository _repository;

  @override
  Future<Either<Failure, JournalEntry>> call(
    JournalEntry params,
  ) {
    return _repository.createEntry(params);
  }
}
