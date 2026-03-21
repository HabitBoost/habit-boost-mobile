import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/domain/usecases/create_habit.dart';
import 'package:habit_boost/features/habits/domain/usecases/delete_habit.dart';
import 'package:habit_boost/features/habits/domain/usecases/update_habit.dart';
import 'package:injectable/injectable.dart';

part 'habit_form_event.dart';
part 'habit_form_state.dart';

@injectable
class HabitFormBloc extends Bloc<HabitFormEvent, HabitFormState> {
  HabitFormBloc({
    required CreateHabit createHabit,
    required UpdateHabit updateHabit,
    required DeleteHabit deleteHabit,
  })  : _createHabit = createHabit,
        _updateHabit = updateHabit,
        _deleteHabit = deleteHabit,
        super(const HabitFormState()) {
    on<HabitFormInitialized>(_onInitialized);
    on<HabitFormTitleChanged>(_onTitleChanged);
    on<HabitFormIconChanged>(_onIconChanged);
    on<HabitFormColorChanged>(_onColorChanged);
    on<HabitFormCategoryChanged>(_onCategoryChanged);
    on<HabitFormDayToggled>(_onDayToggled);
    on<HabitFormReminderToggled>(_onReminderToggled);
    on<HabitFormReminderTimeChanged>(_onReminderTimeChanged);
    on<HabitFormSubmitted>(_onSubmitted);
    on<HabitFormDeleteRequested>(_onDeleteRequested);
  }

  final CreateHabit _createHabit;
  final UpdateHabit _updateHabit;
  final DeleteHabit _deleteHabit;

  void _onInitialized(
    HabitFormInitialized event,
    Emitter<HabitFormState> emit,
  ) {
    if (event.habit != null) {
      final h = event.habit!;
      emit(
        state.copyWith(
          isEditing: true,
          habitId: h.id,
          title: h.title,
          icon: h.icon,
          color: h.color,
          category: h.category,
          scheduleDays: h.scheduleDays,
          reminderEnabled: h.reminderEnabled,
          reminderHour: h.reminderHour,
          reminderMinute: h.reminderMinute,
        ),
      );
    }
  }

  void _onTitleChanged(
    HabitFormTitleChanged event,
    Emitter<HabitFormState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onIconChanged(
    HabitFormIconChanged event,
    Emitter<HabitFormState> emit,
  ) {
    emit(state.copyWith(icon: event.icon));
  }

  void _onColorChanged(
    HabitFormColorChanged event,
    Emitter<HabitFormState> emit,
  ) {
    emit(state.copyWith(color: event.color));
  }

  void _onCategoryChanged(
    HabitFormCategoryChanged event,
    Emitter<HabitFormState> emit,
  ) {
    emit(state.copyWith(category: event.category));
  }

  void _onDayToggled(
    HabitFormDayToggled event,
    Emitter<HabitFormState> emit,
  ) {
    final days = List<int>.from(state.scheduleDays);
    if (days.contains(event.day)) {
      days.remove(event.day);
    } else {
      days.add(event.day);
    }
    emit(state.copyWith(scheduleDays: days));
  }

  void _onReminderToggled(
    HabitFormReminderToggled event,
    Emitter<HabitFormState> emit,
  ) {
    emit(state.copyWith(reminderEnabled: !state.reminderEnabled));
  }

  void _onReminderTimeChanged(
    HabitFormReminderTimeChanged event,
    Emitter<HabitFormState> emit,
  ) {
    emit(
      state.copyWith(
        reminderHour: event.hour,
        reminderMinute: event.minute,
      ),
    );
  }

  Future<void> _onSubmitted(
    HabitFormSubmitted event,
    Emitter<HabitFormState> emit,
  ) async {
    if (state.title.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Введите название привычки'));
      return;
    }

    emit(state.copyWith(status: HabitFormStatus.submitting));

    final habit = Habit(
      id: state.habitId ?? '',
      userId: event.userId,
      title: state.title.trim(),
      icon: state.icon,
      color: state.color,
      category: state.category,
      scheduleDays: state.scheduleDays,
      reminderEnabled: state.reminderEnabled,
      reminderHour: state.reminderHour,
      reminderMinute: state.reminderMinute,
    );

    final result = state.isEditing
        ? await _updateHabit(habit)
        : await _createHabit(habit);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HabitFormStatus.initial,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: HabitFormStatus.success)),
    );
  }

  Future<void> _onDeleteRequested(
    HabitFormDeleteRequested event,
    Emitter<HabitFormState> emit,
  ) async {
    if (state.habitId == null) return;

    emit(state.copyWith(status: HabitFormStatus.submitting));

    final result = await _deleteHabit(
      DeleteHabitParams(id: state.habitId!),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HabitFormStatus.initial,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: HabitFormStatus.success)),
    );
  }
}
