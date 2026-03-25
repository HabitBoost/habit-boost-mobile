import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/notifications/data/datasources/notification_service.dart';
import 'package:habit_boost/features/notifications/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this._service);

  final NotificationService _service;

  @override
  Future<void> init() => _service.init();

  @override
  Future<bool> requestPermission() => _service.requestPermission();

  @override
  Future<void> scheduleForHabit(Habit habit) async {
    if (habit.reminderEnabled) {
      await _service.scheduleHabitReminders(
        habitId: habit.id,
        title: habit.title,
        reminderTimes: habit.reminderTimes,
        scheduleDays: habit.scheduleDays,
      );
    } else {
      await _service.cancelHabitReminders(habit.id);
    }
  }

  @override
  Future<void> cancelForHabit(String habitId) =>
      _service.cancelHabitReminders(habitId);

  @override
  Future<void> cancelAll() => _service.cancelAll();

  @override
  Future<void> rescheduleAll(List<Habit> habits) async {
    await _service.cancelAll();
    for (final habit in habits) {
      if (habit.reminderEnabled) {
        await scheduleForHabit(habit);
      }
    }
  }
}
