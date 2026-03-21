import 'package:equatable/equatable.dart';

class HabitCompletion extends Equatable {
  const HabitCompletion({
    required this.id,
    required this.habitId,
    required this.date,
    this.completed = true,
  });

  final String id;
  final String habitId;
  final DateTime date;
  final bool completed;

  @override
  List<Object?> get props => [id, habitId, date, completed];
}
