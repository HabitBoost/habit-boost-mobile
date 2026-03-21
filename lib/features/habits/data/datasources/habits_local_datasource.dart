import 'package:drift/drift.dart';
import 'package:habit_boost/core/database/app_database.dart';
import 'package:habit_boost/core/error/exceptions.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/domain/entities/habit_completion.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HabitsLocalDataSource {
  const HabitsLocalDataSource(this._db);

  final AppDatabase _db;

  Future<List<Habit>> getHabits(String userId) async {
    try {
      final rows = await (_db.select(_db.habitsTable)
            ..where((t) => t.userId.equals(userId)))
          .get();
      return rows.map(_habitFromRow).toList();
    } catch (e) {
      throw CacheException('Failed to get habits: $e');
    }
  }

  Future<List<Habit>> getTodayHabits(
    String userId,
    int weekday,
  ) async {
    try {
      final rows = await (_db.select(_db.habitsTable)
            ..where((t) => t.userId.equals(userId)))
          .get();
      return rows
          .map(_habitFromRow)
          .where((h) => h.scheduleDays.contains(weekday))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get today habits: $e');
    }
  }

  Future<Habit> getHabit(String id) async {
    try {
      final row = await (_db.select(_db.habitsTable)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      return _habitFromRow(row);
    } catch (e) {
      throw CacheException('Habit not found: $e');
    }
  }

  Future<void> insertHabit(Habit habit) async {
    await _db.into(_db.habitsTable).insert(
          HabitsTableCompanion.insert(
            id: habit.id,
            userId: habit.userId,
            title: habit.title,
            icon: Value(habit.icon),
            color: Value(habit.color),
            category: Value(habit.category),
            scheduleDays: Value(
              habit.scheduleDays.join(','),
            ),
            reminderEnabled: Value(habit.reminderEnabled),
            reminderHour: Value(habit.reminderHour),
            reminderMinute: Value(habit.reminderMinute),
            createdAt: habit.createdAt ?? DateTime.now(),
            currentStreak: Value(habit.currentStreak),
            bestStreak: Value(habit.bestStreak),
          ),
        );
  }

  Future<void> updateHabit(Habit habit) async {
    await (_db.update(_db.habitsTable)
          ..where((t) => t.id.equals(habit.id)))
        .write(
      HabitsTableCompanion(
        title: Value(habit.title),
        icon: Value(habit.icon),
        color: Value(habit.color),
        category: Value(habit.category),
        scheduleDays: Value(
          habit.scheduleDays.join(','),
        ),
        reminderEnabled: Value(habit.reminderEnabled),
        reminderHour: Value(habit.reminderHour),
        reminderMinute: Value(habit.reminderMinute),
        currentStreak: Value(habit.currentStreak),
        bestStreak: Value(habit.bestStreak),
      ),
    );
  }

  Future<void> deleteHabit(String id) async {
    await (_db.delete(_db.habitsTable)
          ..where((t) => t.id.equals(id)))
        .go();
    await (_db.delete(_db.habitCompletionsTable)
          ..where((t) => t.habitId.equals(id)))
        .go();
  }

  Future<List<HabitCompletion>> getCompletions(
    String habitId,
    DateTime from,
    DateTime to,
  ) async {
    final rows = await (_db.select(_db.habitCompletionsTable)
          ..where(
            (t) =>
                t.habitId.equals(habitId) &
                t.date.isBiggerOrEqualValue(from) &
                t.date.isSmallerOrEqualValue(to),
          ))
        .get();
    return rows.map(_completionFromRow).toList();
  }

  Future<List<HabitCompletion>> getCompletionsForDate(
    String userId,
    DateTime date,
  ) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final rows = await (_db.select(_db.habitCompletionsTable)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerThanValue(end),
          ))
        .get();
    return rows.map(_completionFromRow).toList();
  }

  Future<void> insertCompletion(HabitCompletion completion) async {
    await _db.into(_db.habitCompletionsTable).insert(
          HabitCompletionsTableCompanion.insert(
            id: completion.id,
            habitId: completion.habitId,
            date: completion.date,
            completed: Value(completion.completed),
          ),
        );
  }

  Future<void> deleteCompletion(String id) async {
    await (_db.delete(_db.habitCompletionsTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Habit _habitFromRow(HabitsTableData row) {
    return Habit(
      id: row.id,
      userId: row.userId,
      title: row.title,
      icon: row.icon,
      color: row.color,
      category: row.category,
      scheduleDays: row.scheduleDays
          .split(',')
          .map(int.parse)
          .toList(),
      reminderEnabled: row.reminderEnabled,
      reminderHour: row.reminderHour,
      reminderMinute: row.reminderMinute,
      createdAt: row.createdAt,
      currentStreak: row.currentStreak,
      bestStreak: row.bestStreak,
    );
  }

  HabitCompletion _completionFromRow(
    HabitCompletionsTableData row,
  ) {
    return HabitCompletion(
      id: row.id,
      habitId: row.habitId,
      date: row.date,
      completed: row.completed,
    );
  }
}
