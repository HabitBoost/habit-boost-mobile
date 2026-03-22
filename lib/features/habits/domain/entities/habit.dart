import 'package:equatable/equatable.dart';

class Habit extends Equatable {
  const Habit({
    required this.id,
    required this.userId,
    required this.title,
    this.icon = 'dumbbell',
    this.color = '#4CAF50',
    this.category = 'Спорт',
    this.scheduleDays = const [1, 2, 3, 4, 5, 6, 7],
    this.reminderEnabled = false,
    this.reminderHour = 8,
    this.reminderMinute = 0,
    this.createdAt,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String title;
  final String icon;
  final String color;
  final String category;
  final List<int> scheduleDays;
  final bool reminderEnabled;
  final int reminderHour;
  final int reminderMinute;
  final DateTime? createdAt;
  final int currentStreak;
  final int bestStreak;
  final DateTime? updatedAt;

  Habit copyWith({
    String? id,
    String? userId,
    String? title,
    String? icon,
    String? color,
    String? category,
    List<int>? scheduleDays,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    DateTime? createdAt,
    int? currentStreak,
    int? bestStreak,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      category: category ?? this.category,
      scheduleDays: scheduleDays ?? this.scheduleDays,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      createdAt: createdAt ?? this.createdAt,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        icon,
        color,
        category,
        scheduleDays,
        reminderEnabled,
        reminderHour,
        reminderMinute,
        createdAt,
        currentStreak,
        bestStreak,
        updatedAt,
      ];
}
