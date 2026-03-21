part of 'habits_bloc.dart';

enum HabitsStatus { initial, loading, loaded, error }

class HabitsState extends Equatable {
  const HabitsState({
    this.status = HabitsStatus.initial,
    this.habits = const [],
    this.completions = const [],
    this.errorMessage,
  });

  final HabitsStatus status;
  final List<Habit> habits;
  final List<HabitCompletion> completions;
  final String? errorMessage;

  bool isCompleted(String habitId) {
    return completions.any((c) => c.habitId == habitId && c.completed);
  }

  int get completedCount => habits.where((h) => isCompleted(h.id)).length;

  HabitsState copyWith({
    HabitsStatus? status,
    List<Habit>? habits,
    List<HabitCompletion>? completions,
    String? errorMessage,
  }) {
    return HabitsState(
      status: status ?? this.status,
      habits: habits ?? this.habits,
      completions: completions ?? this.completions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, habits, completions, errorMessage];
}
