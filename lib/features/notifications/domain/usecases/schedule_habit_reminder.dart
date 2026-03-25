import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/notifications/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ScheduleHabitReminder {
  const ScheduleHabitReminder(this._repository);

  final NotificationRepository _repository;

  Future<void> call(Habit habit) => _repository.scheduleForHabit(habit);
}
