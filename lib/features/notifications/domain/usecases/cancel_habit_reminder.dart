import 'package:habit_boost/features/notifications/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CancelHabitReminder {
  const CancelHabitReminder(this._repository);

  final NotificationRepository _repository;

  Future<void> call(String habitId) => _repository.cancelForHabit(habitId);
}
