import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_boost/features/habits/data/datasources/habits_remote_datasource.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/domain/entities/habit_completion.dart';
import 'package:habit_boost/features/habits/domain/entities/reminder_time.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HabitsRemoteDataSource)
class HabitsFirestoreDataSource implements HabitsRemoteDataSource {
  const HabitsFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _habitsCol(String userId) =>
      _firestore.collection('users').doc(userId).collection('habits');

  CollectionReference<Map<String, dynamic>> _completionsCol(String userId) =>
      _firestore.collection('users').doc(userId).collection('completions');

  @override
  Future<List<Habit>> getHabits(String userId) async {
    final snapshot = await _habitsCol(userId).get();
    return snapshot.docs.map((doc) => _habitFromDoc(doc, userId)).toList();
  }

  @override
  Future<void> upsertHabit(Habit habit) async {
    await _habitsCol(habit.userId).doc(habit.id).set(
          _habitToMap(habit),
          SetOptions(merge: true),
        );
  }

  @override
  Future<void> deleteHabit(String habitId, String userId) async {
    await _habitsCol(userId).doc(habitId).delete();
  }

  @override
  Future<List<HabitCompletion>> getCompletions(
    String userId,
    DateTime from,
    DateTime to,
  ) async {
    final snapshot = await _completionsCol(userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(to))
        .get();
    return snapshot.docs.map(_completionFromDoc).toList();
  }

  @override
  Future<void> upsertCompletion(
    HabitCompletion completion,
    String userId,
  ) async {
    await _completionsCol(userId).doc(completion.id).set(
          _completionToMap(completion),
          SetOptions(merge: true),
        );
  }

  @override
  Future<void> deleteCompletion(String completionId, String userId) async {
    await _completionsCol(userId).doc(completionId).delete();
  }

  Habit _habitFromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    String userId,
  ) {
    final d = doc.data();
    return Habit(
      id: doc.id,
      userId: userId,
      title: d['title'] as String? ?? '',
      icon: d['icon'] as String? ?? 'dumbbell',
      color: d['color'] as String? ?? '#4CAF50',
      category: d['category'] as String? ?? 'Спорт',
      scheduleDays: (d['scheduleDays'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [1, 2, 3, 4, 5, 6, 7],
      reminderEnabled: d['reminderEnabled'] as bool? ?? false,
      reminderTimes: d['reminderTimes'] != null
          ? ReminderTime.fromFirestoreList(
              d['reminderTimes'] as List<dynamic>,
            )
          : [
              ReminderTime(
                hour: d['reminderHour'] as int? ?? 8,
                minute: d['reminderMinute'] as int? ?? 0,
              ),
            ],
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
      currentStreak: d['currentStreak'] as int? ?? 0,
      bestStreak: d['bestStreak'] as int? ?? 0,
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> _habitToMap(Habit h) {
    return {
      'title': h.title,
      'icon': h.icon,
      'color': h.color,
      'category': h.category,
      'scheduleDays': h.scheduleDays,
      'reminderEnabled': h.reminderEnabled,
      'reminderTimes': ReminderTime.toFirestoreList(h.reminderTimes),
      'createdAt': h.createdAt != null
          ? Timestamp.fromDate(h.createdAt!)
          : FieldValue.serverTimestamp(),
      'currentStreak': h.currentStreak,
      'bestStreak': h.bestStreak,
      'updatedAt': Timestamp.fromDate(h.updatedAt ?? DateTime.now()),
    };
  }

  HabitCompletion _completionFromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data();
    return HabitCompletion(
      id: doc.id,
      habitId: d['habitId'] as String? ?? '',
      date: (d['date'] as Timestamp).toDate(),
      completed: d['completed'] as bool? ?? true,
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> _completionToMap(HabitCompletion c) {
    return {
      'habitId': c.habitId,
      'date': Timestamp.fromDate(c.date),
      'completed': c.completed,
      'updatedAt': Timestamp.fromDate(c.updatedAt ?? DateTime.now()),
    };
  }
}
