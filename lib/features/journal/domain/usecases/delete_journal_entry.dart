import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/core/usecases/usecase.dart';
import 'package:habit_boost/features/journal/domain/repositories/journal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteJournalEntry
    extends UseCase<void, DeleteJournalEntryParams> {
  DeleteJournalEntry(this._repository);

  final JournalRepository _repository;

  @override
  Future<Either<Failure, void>> call(
    DeleteJournalEntryParams params,
  ) {
    return _repository.deleteEntry(params.id);
  }
}

class DeleteJournalEntryParams extends Equatable {
  const DeleteJournalEntryParams({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}
