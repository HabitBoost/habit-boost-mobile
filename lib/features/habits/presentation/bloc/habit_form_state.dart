part of 'habit_form_bloc.dart';

enum HabitFormStatus { initial, submitting, success }

class HabitFormState extends Equatable {
  const HabitFormState({
    this.status = HabitFormStatus.initial,
    this.isEditing = false,
    this.habitId,
    this.title = '',
    this.icon = 'dumbbell',
    this.color = '#4CAF50',
    this.category = 'Спорт',
    this.scheduleDays = const [1, 2, 3, 4, 5, 6, 7],
    this.reminderEnabled = false,
    this.reminderHour = 8,
    this.reminderMinute = 0,
    this.errorMessage,
  });

  final HabitFormStatus status;
  final bool isEditing;
  final String? habitId;
  final String title;
  final String icon;
  final String color;
  final String category;
  final List<int> scheduleDays;
  final bool reminderEnabled;
  final int reminderHour;
  final int reminderMinute;
  final String? errorMessage;

  HabitFormState copyWith({
    HabitFormStatus? status,
    bool? isEditing,
    String? habitId,
    String? title,
    String? icon,
    String? color,
    String? category,
    List<int>? scheduleDays,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    String? errorMessage,
  }) {
    return HabitFormState(
      status: status ?? this.status,
      isEditing: isEditing ?? this.isEditing,
      habitId: habitId ?? this.habitId,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      category: category ?? this.category,
      scheduleDays: scheduleDays ?? this.scheduleDays,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isEditing,
        habitId,
        title,
        icon,
        color,
        category,
        scheduleDays,
        reminderEnabled,
        reminderHour,
        reminderMinute,
        errorMessage,
      ];
}
