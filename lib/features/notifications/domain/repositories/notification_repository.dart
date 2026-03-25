import 'package:habit_boost/features/habits/domain/entities/habit.dart';

abstract class NotificationRepository {
  /// Initialize the notification plugin. Call once at startup.
  Future<void> init();

  /// Request notification permission from the OS.
  Future<bool> requestPermission();

  /// Schedule recurring reminders for a habit based on its settings.
  /// No-op if `reminderEnabled` is `false`.
  Future<void> scheduleForHabit(Habit habit);

  /// Cancel all reminders for the given habit.
  Future<void> cancelForHabit(String habitId);

  /// Cancel all scheduled notifications.
  Future<void> cancelAll();

  /// Re-schedule reminders for all habits that have reminders enabled.
  Future<void> rescheduleAll(List<Habit> habits);
}
