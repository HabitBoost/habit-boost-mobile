import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/domain/entities/reminder_time.dart';
import 'package:habit_boost/features/habits/domain/usecases/delete_habit.dart';
import 'package:habit_boost/features/habits/presentation/bloc/habit_form_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_classes.dart';

const _testHabit = Habit(
  id: 'h1',
  userId: 'user1',
  title: 'Бег',
  icon: 'run',
  color: '#FF5722',
);

void main() {
  late MockCreateHabit mockCreateHabit;
  late MockUpdateHabit mockUpdateHabit;
  late MockDeleteHabit mockDeleteHabit;

  setUpAll(() {
    registerFallbackValue(_testHabit);
    registerFallbackValue(const DeleteHabitParams(id: ''));
  });

  setUp(() {
    mockCreateHabit = MockCreateHabit();
    mockUpdateHabit = MockUpdateHabit();
    mockDeleteHabit = MockDeleteHabit();
  });

  HabitFormBloc buildBloc() => HabitFormBloc(
        createHabit: mockCreateHabit,
        updateHabit: mockUpdateHabit,
        deleteHabit: mockDeleteHabit,
      );

  group('HabitFormInitialized', () {
    blocTest<HabitFormBloc, HabitFormState>(
      'без привычки — остаётся в начальном состоянии',
      build: buildBloc,
      act: (bloc) => bloc.add(const HabitFormInitialized()),
      expect: () => <HabitFormState>[],
    );

    blocTest<HabitFormBloc, HabitFormState>(
      'с привычкой — устанавливает режим редактирования',
      build: buildBloc,
      act: (bloc) =>
          bloc.add(const HabitFormInitialized(habit: _testHabit)),
      expect: () => [
        isA<HabitFormState>()
            .having((s) => s.isEditing, 'isEditing', isTrue)
            .having((s) => s.habitId, 'habitId', 'h1')
            .having((s) => s.title, 'title', 'Бег')
            .having((s) => s.icon, 'icon', 'run')
            .having((s) => s.color, 'color', '#FF5722'),
      ],
    );
  });

  group('HabitFormTitleChanged', () {
    blocTest<HabitFormBloc, HabitFormState>(
      'обновляет title в состоянии',
      build: buildBloc,
      act: (bloc) =>
          bloc.add(const HabitFormTitleChanged('Медитация')),
      expect: () => [
        isA<HabitFormState>()
            .having((s) => s.title, 'title', 'Медитация'),
      ],
    );
  });

  group('HabitFormIconChanged', () {
    blocTest<HabitFormBloc, HabitFormState>(
      'обновляет icon в состоянии',
      build: buildBloc,
      act: (bloc) => bloc.add(const HabitFormIconChanged('heart')),
      expect: () => [
        isA<HabitFormState>()
            .having((s) => s.icon, 'icon', 'heart'),
      ],
    );
  });

  group('HabitFormColorChanged', () {
    blocTest<HabitFormBloc, HabitFormState>(
      'обновляет color в состоянии',
      build: buildBloc,
      act: (bloc) =>
          bloc.add(const HabitFormColorChanged('#2196F3')),
      expect: () => [
        isA<HabitFormState>()
            .having((s) => s.color, 'color', '#2196F3'),
      ],
    );
  });

  group('HabitFormDayToggled', () {
    blocTest<HabitFormBloc, HabitFormState>(
      'удаляет день, если он уже выбран',
      build: buildBloc,
      act: (bloc) => bloc.add(const HabitFormDayToggled(1)),
      expect: () => [
        isA<HabitFormState>().having(
          (s) => s.scheduleDays,
          'scheduleDays',
          [2, 3, 4, 5, 6, 7],
        ),
      ],
    );

    blocTest<HabitFormBloc, HabitFormState>(
      'добавляет день, если он не выбран',
      build: buildBloc,
      seed: () => const HabitFormState(scheduleDays: [2, 3]),
      act: (bloc) => bloc.add(const HabitFormDayToggled(5)),
      expect: () => [
        isA<HabitFormState>().having(
          (s) => s.scheduleDays,
          'scheduleDays',
          [2, 3, 5],
        ),
      ],
    );
  });

  group('HabitFormReminderToggled', () {
    blocTest<HabitFormBloc, HabitFormState>(
      'переключает reminderEnabled с false на true',
      build: buildBloc,
      act: (bloc) => bloc.add(const HabitFormReminderToggled()),
      expect: () => [
        isA<HabitFormState>()
            .having((s) => s.reminderEnabled, 'reminderEnabled', isTrue),
      ],
    );

    blocTest<HabitFormBloc, HabitFormState>(
      'переключает reminderEnabled с true на false',
      build: buildBloc,
      seed: () => const HabitFormState(reminderEnabled: true),
      act: (bloc) => bloc.add(const HabitFormReminderToggled()),
      expect: () => [
        isA<HabitFormState>()
            .having(
              (s) => s.reminderEnabled,
              'reminderEnabled',
              isFalse,
            ),
      ],
    );
  });

  group('HabitFormReminderTimeAdded', () {
    blocTest<HabitFormBloc, HabitFormState>(
      'добавляет время в список напоминаний',
      build: buildBloc,
      act: (bloc) => bloc.add(
        const HabitFormReminderTimeAdded(ReminderTime(hour: 20, minute: 0)),
      ),
      expect: () => [
        isA<HabitFormState>().having(
          (s) => s.reminderTimes.length,
          'reminderTimes length',
          2,
        ),
      ],
    );
  });

  group('HabitFormReminderTimeRemoved', () {
    blocTest<HabitFormBloc, HabitFormState>(
      'удаляет время из списка',
      build: buildBloc,
      seed: () => const HabitFormState(
        reminderTimes: [
          ReminderTime(hour: 8, minute: 0),
          ReminderTime(hour: 20, minute: 0),
        ],
      ),
      act: (bloc) => bloc.add(const HabitFormReminderTimeRemoved(1)),
      expect: () => [
        isA<HabitFormState>().having(
          (s) => s.reminderTimes,
          'reminderTimes',
          [const ReminderTime(hour: 8, minute: 0)],
        ),
      ],
    );

    blocTest<HabitFormBloc, HabitFormState>(
      'при удалении последнего подставляет дефолтное 08:00',
      build: buildBloc,
      seed: () => const HabitFormState(
        reminderTimes: [ReminderTime(hour: 9, minute: 0)],
      ),
      act: (bloc) => bloc.add(const HabitFormReminderTimeRemoved(0)),
      expect: () => [
        isA<HabitFormState>().having(
          (s) => s.reminderTimes,
          'reminderTimes',
          [const ReminderTime(hour: 8, minute: 0)],
        ),
      ],
    );
  });

  group('HabitFormSubmitted — создание', () {
    blocTest<HabitFormBloc, HabitFormState>(
      'вызывает createHabit и переходит в статус saved',
      build: () {
        when(() => mockCreateHabit(any())).thenAnswer(
          (_) async => const Right<Failure, Habit>(_testHabit),
        );
        return buildBloc();
      },
      seed: () => const HabitFormState(title: 'Бег'),
      act: (bloc) =>
          bloc.add(const HabitFormSubmitted(userId: 'user1')),
      expect: () => [
        isA<HabitFormState>()
            .having((s) => s.status, 'status', HabitFormStatus.submitting),
        isA<HabitFormState>()
            .having((s) => s.status, 'status', HabitFormStatus.saved),
      ],
      verify: (_) {
        verify(() => mockCreateHabit(any())).called(1);
      },
    );

    blocTest<HabitFormBloc, HabitFormState>(
      'при пустом title — устанавливает сообщение об ошибке',
      build: buildBloc,
      act: (bloc) =>
          bloc.add(const HabitFormSubmitted(userId: 'user1')),
      expect: () => [
        isA<HabitFormState>().having(
          (s) => s.errorMessage,
          'errorMessage',
          'Введите название привычки',
        ),
      ],
      verify: (_) {
        verifyNever(() => mockCreateHabit(any()));
      },
    );

    blocTest<HabitFormBloc, HabitFormState>(
      'при ошибке createHabit — устанавливает errorMessage',
      build: () {
        when(() => mockCreateHabit(any())).thenAnswer(
          (_) async =>
              const Left<Failure, Habit>(ServerFailure('Ошибка сервера')),
        );
        return buildBloc();
      },
      seed: () => const HabitFormState(title: 'Бег'),
      act: (bloc) =>
          bloc.add(const HabitFormSubmitted(userId: 'user1')),
      expect: () => [
        isA<HabitFormState>()
            .having((s) => s.status, 'status', HabitFormStatus.submitting),
        isA<HabitFormState>()
            .having((s) => s.status, 'status', HabitFormStatus.initial)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Ошибка сервера',
            ),
      ],
    );
  });

  group('HabitFormSubmitted — редактирование', () {
    blocTest<HabitFormBloc, HabitFormState>(
      'вызывает updateHabit при isEditing=true',
      build: () {
        when(() => mockUpdateHabit(any())).thenAnswer(
          (_) async => const Right<Failure, Habit>(_testHabit),
        );
        return buildBloc();
      },
      seed: () => const HabitFormState(
        isEditing: true,
        habitId: 'h1',
        title: 'Бег обновлённый',
      ),
      act: (bloc) =>
          bloc.add(const HabitFormSubmitted(userId: 'user1')),
      expect: () => [
        isA<HabitFormState>()
            .having((s) => s.status, 'status', HabitFormStatus.submitting),
        isA<HabitFormState>()
            .having((s) => s.status, 'status', HabitFormStatus.saved),
      ],
      verify: (_) {
        verify(() => mockUpdateHabit(any())).called(1);
        verifyNever(() => mockCreateHabit(any()));
      },
    );
  });

  group('HabitFormDeleteRequested', () {
    blocTest<HabitFormBloc, HabitFormState>(
      'вызывает deleteHabit и переходит в статус deleted',
      build: () {
        when(() => mockDeleteHabit(any())).thenAnswer(
          (_) async => const Right<Failure, void>(null),
        );
        return buildBloc();
      },
      seed: () => const HabitFormState(
        isEditing: true,
        habitId: 'h1',
        title: 'Бег',
      ),
      act: (bloc) => bloc.add(const HabitFormDeleteRequested()),
      expect: () => [
        isA<HabitFormState>()
            .having((s) => s.status, 'status', HabitFormStatus.submitting),
        isA<HabitFormState>()
            .having((s) => s.status, 'status', HabitFormStatus.deleted),
      ],
      verify: (_) {
        verify(() => mockDeleteHabit(any())).called(1);
      },
    );

    blocTest<HabitFormBloc, HabitFormState>(
      'ничего не делает если habitId == null',
      build: buildBloc,
      act: (bloc) => bloc.add(const HabitFormDeleteRequested()),
      expect: () => <HabitFormState>[],
      verify: (_) {
        verifyNever(() => mockDeleteHabit(any()));
      },
    );

    blocTest<HabitFormBloc, HabitFormState>(
      'при ошибке deleteHabit — устанавливает errorMessage',
      build: () {
        when(() => mockDeleteHabit(any())).thenAnswer(
          (_) async =>
              const Left<Failure, void>(CacheFailure('Не найдено')),
        );
        return buildBloc();
      },
      seed: () => const HabitFormState(
        isEditing: true,
        habitId: 'h1',
        title: 'Бег',
      ),
      act: (bloc) => bloc.add(const HabitFormDeleteRequested()),
      expect: () => [
        isA<HabitFormState>()
            .having((s) => s.status, 'status', HabitFormStatus.submitting),
        isA<HabitFormState>()
            .having((s) => s.status, 'status', HabitFormStatus.initial)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Не найдено',
            ),
      ],
    );
  });
}
