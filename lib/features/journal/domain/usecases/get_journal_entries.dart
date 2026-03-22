import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/core/usecases/usecase.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';
import 'package:habit_boost/features/journal/domain/repositories/journal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetJournalEntries
    extends UseCase<List<JournalEntry>, GetJournalEntriesParams> {
  GetJournalEntries(this._repository);

  final JournalRepository _repository;

  @override
  Future<Either<Failure, List<JournalEntry>>> call(
    GetJournalEntriesParams params,
  ) {
    return _repository.getEntries(params.userId);
  }
}

class GetJournalEntriesParams extends Equatable {
  const GetJournalEntriesParams({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}
