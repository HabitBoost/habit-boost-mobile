import 'package:equatable/equatable.dart';

class HabitProgress extends Equatable {
  const HabitProgress({
    required this.habitId,
    required this.title,
    required this.icon,
    required this.color,
    required this.completionRate,
  });

  final String habitId;
  final String title;
  final String icon;
  final String color;
  final double completionRate;

  @override
  List<Object?> get props => [
        habitId,
        title,
        icon,
        color,
        completionRate,
      ];
}

class DayCompletion extends Equatable {
  const DayCompletion({
    required this.date,
    required this.completedCount,
    required this.totalCount,
  });

  final DateTime date;
  final int completedCount;
  final int totalCount;

  double get rate =>
      totalCount > 0 ? completedCount / totalCount : 0;

  @override
  List<Object?> get props => [date, completedCount, totalCount];
}

class ProgressStats extends Equatable {
  const ProgressStats({
    required this.todayCompleted,
    required this.todayTotal,
    required this.currentStreak,
    required this.periodRate,
    required this.habitProgresses,
    required this.dayCompletions,
  });

  static const empty = ProgressStats(
    todayCompleted: 0,
    todayTotal: 0,
    currentStreak: 0,
    periodRate: 0,
    habitProgresses: [],
    dayCompletions: [],
  );

  final int todayCompleted;
  final int todayTotal;
  final int currentStreak;
  final double periodRate;
  final List<HabitProgress> habitProgresses;
  final List<DayCompletion> dayCompletions;

  @override
  List<Object?> get props => [
        todayCompleted,
        todayTotal,
        currentStreak,
        periodRate,
        habitProgresses,
        dayCompletions,
      ];
}
