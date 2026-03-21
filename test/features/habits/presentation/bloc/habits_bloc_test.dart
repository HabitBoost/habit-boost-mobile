import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/domain/entities/habit_completion.dart';
import 'package:habit_boost/features/habits/domain/usecases/get_completions_for_date.dart';
import 'package:habit_boost/features/habits/domain/usecases/get_today_habits.dart';
import 'package:habit_boost/features/habits/domain/usecases/toggle_completion.dart';
import 'package:habit_boost/features/habits/presentation/bloc/habits_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_classes.dart';

void main() {
  late MockGetTodayHabits mockGetTodayHabits;
  late MockToggleCompletion mockToggleCompletion;
  late MockGetCompletionsForDate mockGetCompletionsForDate;

  const testHabit = Habit(
    id: '1',
    userId: 'user1',
    title: 'Бег',
  );

  final testCompletion = HabitCompletion(
    id: 'c1',
    habitId: '1',
    date: DateTime.now(),
  );

  setUpAll(() {
    registerFallbackValue(
      const GetTodayHabitsParams(userId: ''),
    );
    registerFallbackValue(
      GetCompletionsForDateParams(
        userId: '',
        date: DateTime.now(),
      ),
    );
    registerFallbackValue(
      ToggleCompletionParams(
        habitId: '',
        date: DateTime.now(),
      ),
    );
  });

  setUp(() {
    mockGetTodayHabits = MockGetTodayHabits();
    mockToggleCompletion = MockToggleCompletion();
    mockGetCompletionsForDate = MockGetCompletionsForDate();
  });

  HabitsBloc buildBloc() => HabitsBloc(
        getTodayHabits: mockGetTodayHabits,
        toggleCompletion: mockToggleCompletion,
        getCompletionsForDate: mockGetCompletionsForDate,
      );

  group('HabitsLoadRequested', () {
    blocTest<HabitsBloc, HabitsState>(
      'emits [loading, loaded] with habits and completions on success',
      build: () {
        when(() => mockGetTodayHabits(any()))
            .thenAnswer((_) async => const Right([testHabit]));
        when(() => mockGetCompletionsForDate(any()))
            .thenAnswer((_) async => Right([testCompletion]));
        return buildBloc();
      },
      act: (bloc) =>
          bloc.add(const HabitsLoadRequested(userId: 'user1')),
      expect: () => [
        const HabitsState(status: HabitsStatus.loading),
        isA<HabitsState>()
            .having((s) => s.status, 'status', HabitsStatus.loaded)
            .having((s) => s.habits, 'habits', [testHabit])
            .having(
              (s) => s.completions.length,
              'completions length',
              1,
            ),
      ],
    );

    blocTest<HabitsBloc, HabitsState>(
      'emits [loading, error] when getTodayHabits fails',
      build: () {
        when(() => mockGetTodayHabits(any())).thenAnswer(
          (_) async =>
              const Left(CacheFailure('Ошибка загрузки')),
        );
        return buildBloc();
      },
      act: (bloc) =>
          bloc.add(const HabitsLoadRequested(userId: 'user1')),
      expect: () => [
        const HabitsState(status: HabitsStatus.loading),
        const HabitsState(
          status: HabitsStatus.error,
          errorMessage: 'Ошибка загрузки',
        ),
      ],
    );

    blocTest<HabitsBloc, HabitsState>(
      'emits loaded with empty list when no habits',
      build: () {
        when(() => mockGetTodayHabits(any()))
            .thenAnswer((_) async => const Right([]));
        when(() => mockGetCompletionsForDate(any()))
            .thenAnswer((_) async => const Right([]));
        return buildBloc();
      },
      act: (bloc) =>
          bloc.add(const HabitsLoadRequested(userId: 'user1')),
      expect: () => [
        const HabitsState(status: HabitsStatus.loading),
        const HabitsState(status: HabitsStatus.loaded),
      ],
    );
  });

  group('HabitToggleRequested', () {
    blocTest<HabitsBloc, HabitsState>(
      'calls toggleCompletion and reloads on success',
      build: () {
        when(() => mockToggleCompletion(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGetTodayHabits(any()))
            .thenAnswer((_) async => const Right([testHabit]));
        when(() => mockGetCompletionsForDate(any()))
            .thenAnswer((_) async => Right([testCompletion]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const HabitToggleRequested(
          habitId: '1',
          userId: 'user1',
        ),
      ),
      verify: (_) {
        verify(() => mockToggleCompletion(any())).called(1);
      },
    );
  });
}
