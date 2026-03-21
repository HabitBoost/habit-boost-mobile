import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/core/usecases/usecase.dart';
import 'package:habit_boost/features/habits/domain/entities/habit_completion.dart';
import 'package:habit_boost/features/habits/domain/repositories/habits_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCompletionsForDate
    extends UseCase<List<HabitCompletion>, GetCompletionsForDateParams> {
  GetCompletionsForDate(this._repository);

  final HabitsRepository _repository;

  @override
  Future<Either<Failure, List<HabitCompletion>>> call(
    GetCompletionsForDateParams params,
  ) {
    return _repository.getCompletionsForDate(params.userId, params.date);
  }
}

class GetCompletionsForDateParams extends Equatable {
  const GetCompletionsForDateParams({
    required this.userId,
    required this.date,
  });

  final String userId;
  final DateTime date;

  @override
  List<Object> get props => [userId, date];
}
