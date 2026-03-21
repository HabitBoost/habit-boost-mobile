import 'package:dartz/dartz.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/domain/entities/habit_completion.dart';

abstract class HabitsRepository {
  Future<Either<Failure, List<Habit>>> getTodayHabits(String userId);
  Future<Either<Failure, Habit>> getHabit(String id);
  Future<Either<Failure, Habit>> createHabit(Habit habit);
  Future<Either<Failure, Habit>> updateHabit(Habit habit);
  Future<Either<Failure, void>> deleteHabit(String id);
  Future<Either<Failure, void>> toggleCompletion({
    required String habitId,
    required DateTime date,
  });
  Future<Either<Failure, List<HabitCompletion>>> getCompletionsForDate(
    String userId,
    DateTime date,
  );
}
