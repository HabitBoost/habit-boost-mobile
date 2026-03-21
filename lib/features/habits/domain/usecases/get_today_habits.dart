import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/core/usecases/usecase.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/domain/repositories/habits_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTodayHabits extends UseCase<List<Habit>, GetTodayHabitsParams> {
  GetTodayHabits(this._repository);

  final HabitsRepository _repository;

  @override
  Future<Either<Failure, List<Habit>>> call(GetTodayHabitsParams params) {
    return _repository.getTodayHabits(params.userId);
  }
}

class GetTodayHabitsParams extends Equatable {
  const GetTodayHabitsParams({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}
