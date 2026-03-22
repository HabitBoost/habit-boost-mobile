import 'package:equatable/equatable.dart';

class HabitCompletion extends Equatable {
  const HabitCompletion({
    required this.id,
    required this.habitId,
    required this.date,
    this.completed = true,
    this.updatedAt,
  });

  final String id;
  final String habitId;
  final DateTime date;
  final bool completed;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [id, habitId, date, completed, updatedAt];
}
