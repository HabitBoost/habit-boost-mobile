part of 'habits_bloc.dart';

abstract class HabitsEvent extends Equatable {
  const HabitsEvent();

  @override
  List<Object?> get props => [];
}

class HabitsLoadRequested extends HabitsEvent {
  const HabitsLoadRequested({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class HabitToggleRequested extends HabitsEvent {
  const HabitToggleRequested({
    required this.habitId,
    required this.userId,
  });

  final String habitId;
  final String userId;

  @override
  List<Object?> get props => [habitId, userId];
}
