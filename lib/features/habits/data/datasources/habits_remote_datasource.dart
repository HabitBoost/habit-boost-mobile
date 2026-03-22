import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/domain/entities/habit_completion.dart';

// Multiple methods defined — lint false positive on abstract class.
// ignore: one_member_abstracts
abstract class HabitsRemoteDataSource {
  Future<List<Habit>> getHabits(String userId);
  Future<void> upsertHabit(Habit habit);
  Future<void> deleteHabit(String habitId, String userId);
  Future<List<HabitCompletion>> getCompletions(
    String userId,
    DateTime from,
    DateTime to,
  );
  Future<void> upsertCompletion(HabitCompletion completion, String userId);
  Future<void> deleteCompletion(String completionId, String userId);
}
