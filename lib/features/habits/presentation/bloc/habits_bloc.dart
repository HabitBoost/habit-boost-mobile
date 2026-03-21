import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/domain/entities/habit_completion.dart';
import 'package:habit_boost/features/habits/domain/usecases/get_completions_for_date.dart';
import 'package:habit_boost/features/habits/domain/usecases/get_today_habits.dart';
import 'package:habit_boost/features/habits/domain/usecases/toggle_completion.dart';
import 'package:injectable/injectable.dart';

part 'habits_event.dart';
part 'habits_state.dart';

@injectable
class HabitsBloc extends Bloc<HabitsEvent, HabitsState> {
  HabitsBloc({
    required GetTodayHabits getTodayHabits,
    required ToggleCompletion toggleCompletion,
    required GetCompletionsForDate getCompletionsForDate,
  })  : _getTodayHabits = getTodayHabits,
        _toggleCompletion = toggleCompletion,
        _getCompletionsForDate = getCompletionsForDate,
        super(const HabitsState()) {
    on<HabitsLoadRequested>(_onLoadRequested);
    on<HabitToggleRequested>(_onToggleRequested);
  }

  final GetTodayHabits _getTodayHabits;
  final ToggleCompletion _toggleCompletion;
  final GetCompletionsForDate _getCompletionsForDate;

  Future<void> _onLoadRequested(
    HabitsLoadRequested event,
    Emitter<HabitsState> emit,
  ) async {
    emit(state.copyWith(status: HabitsStatus.loading));

    final habitsResult = await _getTodayHabits(
      GetTodayHabitsParams(userId: event.userId),
    );

    await habitsResult.fold(
      (failure) async => emit(
        state.copyWith(
          status: HabitsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (habits) async {
        final completionsResult = await _getCompletionsForDate(
          GetCompletionsForDateParams(
            userId: event.userId,
            date: DateTime.now(),
          ),
        );

        completionsResult.fold(
          (failure) => emit(
            state.copyWith(
              status: HabitsStatus.loaded,
              habits: habits,
            ),
          ),
          (completions) => emit(
            state.copyWith(
              status: HabitsStatus.loaded,
              habits: habits,
              completions: completions,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onToggleRequested(
    HabitToggleRequested event,
    Emitter<HabitsState> emit,
  ) async {
    final result = await _toggleCompletion(
      ToggleCompletionParams(
        habitId: event.habitId,
        date: DateTime.now(),
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(errorMessage: failure.message),
      ),
      (_) => add(HabitsLoadRequested(userId: event.userId)),
    );
  }
}
