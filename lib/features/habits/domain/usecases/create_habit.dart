import 'package:dartz/dartz.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/core/usecases/usecase.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/domain/repositories/habits_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateHabit extends UseCase<Habit, Habit> {
  CreateHabit(this._repository);

  final HabitsRepository _repository;

  @override
  Future<Either<Failure, Habit>> call(Habit params) {
    return _repository.createHabit(params);
  }
}
