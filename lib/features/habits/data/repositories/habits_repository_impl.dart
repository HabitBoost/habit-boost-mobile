import 'package:dartz/dartz.dart';
import 'package:habit_boost/core/error/exceptions.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/features/habits/data/datasources/habits_local_datasource.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/domain/entities/habit_completion.dart';
import 'package:habit_boost/features/habits/domain/repositories/habits_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HabitsRepository)
class HabitsRepositoryImpl implements HabitsRepository {
  const HabitsRepositoryImpl(this._local);

  final HabitsLocalDataSource _local;

  @override
  Future<Either<Failure, List<Habit>>> getTodayHabits(
    String userId,
  ) async {
    try {
      final weekday = DateTime.now().weekday;
      final habits = await _local.getTodayHabits(userId, weekday);
      return Right(habits);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Habit>> getHabit(String id) async {
    try {
      final habit = await _local.getHabit(id);
      return Right(habit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Habit>> createHabit(Habit habit) async {
    try {
      final now = DateTime.now();
      final newHabit = habit.copyWith(
        id: now.microsecondsSinceEpoch.toString(),
        createdAt: now,
      );
      await _local.insertHabit(newHabit);
      return Right(newHabit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Habit>> updateHabit(Habit habit) async {
    try {
      await _local.updateHabit(habit);
      return Right(habit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHabit(String id) async {
    try {
      await _local.deleteHabit(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleCompletion({
    required String habitId,
    required DateTime date,
  }) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);
      final completions = await _local.getCompletions(
        habitId,
        dateOnly,
        dateOnly.add(const Duration(days: 1)),
      );

      if (completions.isNotEmpty) {
        await _local.deleteCompletion(completions.first.id);
      } else {
        final completion = HabitCompletion(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          habitId: habitId,
          date: dateOnly,
        );
        await _local.insertCompletion(completion);
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<HabitCompletion>>> getCompletionsForDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final completions =
          await _local.getCompletionsForDate(userId, date);
      return Right(completions);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
