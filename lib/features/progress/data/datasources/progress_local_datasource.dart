import 'package:drift/drift.dart';
import 'package:habit_boost/core/database/app_database.dart';
import 'package:habit_boost/core/error/exceptions.dart';
import 'package:habit_boost/core/utils/app_logger.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_period.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_stats.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ProgressLocalDataSource {
  const ProgressLocalDataSource(this._db);

  final AppDatabase _db;

  Future<ProgressStats> getProgressStats({
    required String userId,
    required ProgressPeriod period,
  }) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final periodStart = period == ProgressPeriod.week
          ? today.subtract(Duration(days: today.weekday - 1))
          : DateTime(today.year, today.month);
      final periodEnd =
          today.add(const Duration(days: 1));

      final habits = await (_db.select(_db.habitsTable)
            ..where((t) => t.userId.equals(userId)))
          .get();

      if (habits.isEmpty) {
        return ProgressStats.empty;
      }

      // Today's completions
      final todayCompletions =
          await _getCompletionsForDay(today);
      final todayHabits = habits
          .where(
            (h) => _scheduledForDay(h.scheduleDays, today.weekday),
          )
          .toList();

      // Per-habit progress for the period
      final allCompletions = await _getCompletionsInRange(
        periodStart,
        periodEnd,
      );

      final habitProgresses = <HabitProgress>[];
      for (final habit in habits) {
        final days = _countScheduledDays(
          habit.scheduleDays,
          periodStart,
          periodEnd,
        );
        if (days == 0) continue;

        final completed = allCompletions
            .where((c) => c.habitId == habit.id)
            .length;
        final rate = (completed / days).clamp(0.0, 1.0);

        habitProgresses.add(
          HabitProgress(
            habitId: habit.id,
            title: habit.title,
            icon: habit.icon,
            color: habit.color,
            completionRate: rate,
          ),
        );
      }

      // Day completions for calendar
      final dayCompletions = <DayCompletion>[];
      var day = periodStart;
      while (day.isBefore(periodEnd)) {
        final scheduled = habits
            .where(
              (h) => _scheduledForDay(
                h.scheduleDays,
                day.weekday,
              ),
            )
            .length;
        final done = allCompletions
            .where(
              (c) =>
                  c.date.year == day.year &&
                  c.date.month == day.month &&
                  c.date.day == day.day,
            )
            .length;

        dayCompletions.add(
          DayCompletion(
            date: day,
            completedCount: done,
            totalCount: scheduled,
          ),
        );
        day = day.add(const Duration(days: 1));
      }

      // Current streak (consecutive days with all done)
      final streak = await _calculateStreak(
        habits,
        today,
      );

      // Period rate
      final totalScheduled = habitProgresses.isEmpty
          ? 0
          : dayCompletions.fold<int>(
              0,
              (sum, d) => sum + d.totalCount,
            );
      final totalDone = dayCompletions.fold<int>(
        0,
        (sum, d) => sum + d.completedCount,
      );
      final periodRate = totalScheduled > 0
          ? totalDone / totalScheduled
          : 0.0;

      return ProgressStats(
        todayCompleted: todayCompletions
            .where(
              (c) => todayHabits.any((h) => h.id == c.habitId),
            )
            .length,
        todayTotal: todayHabits.length,
        currentStreak: streak,
        periodRate: periodRate,
        habitProgresses: habitProgresses,
        dayCompletions: dayCompletions,
      );
    } catch (e) {
      log.e('Failed to get progress stats', error: e);
      throw CacheException('Failed to get progress stats: $e');
    }
  }

  Future<List<HabitCompletionsTableData>> _getCompletionsForDay(
    DateTime day,
  ) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (_db.select(_db.habitCompletionsTable)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerThanValue(end),
          ))
        .get();
  }

  Future<List<HabitCompletionsTableData>> _getCompletionsInRange(
    DateTime from,
    DateTime to,
  ) async {
    return (_db.select(_db.habitCompletionsTable)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(from) &
                t.date.isSmallerThanValue(to),
          ))
        .get();
  }

  bool _scheduledForDay(String scheduleDays, int weekday) {
    if (scheduleDays.isEmpty) return false;
    return scheduleDays
        .split(',')
        .map(int.parse)
        .contains(weekday);
  }

  int _countScheduledDays(
    String scheduleDays,
    DateTime from,
    DateTime to,
  ) {
    if (scheduleDays.isEmpty) return 0;
    final days =
        scheduleDays.split(',').map(int.parse).toSet();
    var count = 0;
    var day = from;
    while (day.isBefore(to)) {
      if (days.contains(day.weekday)) count++;
      day = day.add(const Duration(days: 1));
    }
    return count;
  }

  Future<int> _calculateStreak(
    List<HabitsTableData> habits,
    DateTime today,
  ) async {
    var streak = 0;
    var day = today;

    for (var i = 0; i < 365; i++) {
      final scheduled = habits
          .where(
            (h) =>
                _scheduledForDay(h.scheduleDays, day.weekday),
          )
          .toList();

      if (scheduled.isEmpty) {
        day = day.subtract(const Duration(days: 1));
        continue;
      }

      final completions = await _getCompletionsForDay(day);
      final allDone = scheduled.every(
        (h) => completions.any((c) => c.habitId == h.id),
      );

      if (!allDone && day != today) break;
      if (allDone) streak++;
      if (!allDone && day == today) {
        day = day.subtract(const Duration(days: 1));
        continue;
      }

      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }
}
