import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/core/usecases/usecase.dart';
import 'package:habit_boost/features/habits/domain/repositories/habits_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ToggleCompletion extends UseCase<void, ToggleCompletionParams> {
  ToggleCompletion(this._repository);

  final HabitsRepository _repository;

  @override
  Future<Either<Failure, void>> call(ToggleCompletionParams params) {
    return _repository.toggleCompletion(
      habitId: params.habitId,
      date: params.date,
    );
  }
}

class ToggleCompletionParams extends Equatable {
  const ToggleCompletionParams({
    required this.habitId,
    required this.date,
  });

  final String habitId;
  final DateTime date;

  @override
  List<Object> get props => [habitId, date];
}
