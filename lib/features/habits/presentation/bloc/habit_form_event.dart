part of 'habit_form_bloc.dart';

abstract class HabitFormEvent extends Equatable {
  const HabitFormEvent();

  @override
  List<Object?> get props => [];
}

class HabitFormInitialized extends HabitFormEvent {
  const HabitFormInitialized({this.habit});

  final Habit? habit;

  @override
  List<Object?> get props => [habit];
}

class HabitFormTitleChanged extends HabitFormEvent {
  const HabitFormTitleChanged(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

class HabitFormIconChanged extends HabitFormEvent {
  const HabitFormIconChanged(this.icon);

  final String icon;

  @override
  List<Object?> get props => [icon];
}

class HabitFormColorChanged extends HabitFormEvent {
  const HabitFormColorChanged(this.color);

  final String color;

  @override
  List<Object?> get props => [color];
}

class HabitFormCategoryChanged extends HabitFormEvent {
  const HabitFormCategoryChanged(this.category);

  final String category;

  @override
  List<Object?> get props => [category];
}

class HabitFormDayToggled extends HabitFormEvent {
  const HabitFormDayToggled(this.day);

  final int day;

  @override
  List<Object?> get props => [day];
}

class HabitFormReminderToggled extends HabitFormEvent {
  const HabitFormReminderToggled();
}

class HabitFormReminderTimeAdded extends HabitFormEvent {
  const HabitFormReminderTimeAdded(this.time);

  final ReminderTime time;

  @override
  List<Object?> get props => [time];
}

class HabitFormReminderTimeRemoved extends HabitFormEvent {
  const HabitFormReminderTimeRemoved(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class HabitFormReminderTimeUpdated extends HabitFormEvent {
  const HabitFormReminderTimeUpdated({
    required this.index,
    required this.time,
  });

  final int index;
  final ReminderTime time;

  @override
  List<Object?> get props => [index, time];
}

class HabitFormSubmitted extends HabitFormEvent {
  const HabitFormSubmitted({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class HabitFormDeleteRequested extends HabitFormEvent {
  const HabitFormDeleteRequested();
}
