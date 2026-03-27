import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/domain/entities/habit_completion.dart';
import 'package:habit_boost/features/habits/domain/usecases/create_habit.dart';
import 'package:habit_boost/features/habits/domain/usecases/delete_habit.dart';
import 'package:habit_boost/features/habits/domain/usecases/get_completions_for_date.dart';
import 'package:habit_boost/features/habits/domain/usecases/get_today_habits.dart';
import 'package:habit_boost/features/habits/domain/usecases/toggle_completion.dart';
import 'package:habit_boost/features/habits/domain/usecases/update_habit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_classes.dart';

const _testHabit = Habit(id: '1', userId: 'user1', title: 'Бег');

void main() {
  late MockHabitsRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(_testHabit);
  });

  setUp(() {
    mockRepository = MockHabitsRepository();
  });

  group('GetTodayHabits', () {
    test('возвращает список привычек при успехе', () async {
      when(() => mockRepository.getTodayHabits(any())).thenAnswer(
        (_) async => const Right<Failure, List<Habit>>([_testHabit]),
      );

      final result = await GetTodayHabits(mockRepository)(
        const GetTodayHabitsParams(userId: 'user1'),
      );

      expect(result, const Right<Failure, List<Habit>>([_testHabit]));
      verify(() => mockRepository.getTodayHabits('user1')).called(1);
    });

    test('возвращает CacheFailure при ошибке', () async {
      const failure = CacheFailure('Ошибка загрузки');
      when(() => mockRepository.getTodayHabits(any())).thenAnswer(
        (_) async => const Left<Failure, List<Habit>>(failure),
      );

      final result = await GetTodayHabits(mockRepository)(
        const GetTodayHabitsParams(userId: 'user1'),
      );

      expect(result, const Left<Failure, List<Habit>>(failure));
    });
  });

  group('GetCompletionsForDate', () {
    final testDate = DateTime(2026, 3, 27);
    final testCompletion = HabitCompletion(
      id: 'c1',
      habitId: '1',
      date: testDate,
    );

    test('возвращает список выполнений за дату', () async {
      when(
        () => mockRepository.getCompletionsForDate(any(), any()),
      ).thenAnswer(
        (_) async =>
            Right<Failure, List<HabitCompletion>>([testCompletion]),
      );

      final result = await GetCompletionsForDate(mockRepository)(
        GetCompletionsForDateParams(userId: 'user1', date: testDate),
      );

      expect(result.isRight(), isTrue);
      verify(
        () => mockRepository.getCompletionsForDate('user1', testDate),
      ).called(1);
    });

    test('возвращает Failure при ошибке', () async {
      const failure = CacheFailure('Ошибка');
      when(
        () => mockRepository.getCompletionsForDate(any(), any()),
      ).thenAnswer(
        (_) async =>
            const Left<Failure, List<HabitCompletion>>(failure),
      );

      final result = await GetCompletionsForDate(mockRepository)(
        GetCompletionsForDateParams(userId: 'user1', date: testDate),
      );

      expect(result, const Left<Failure, List<HabitCompletion>>(failure));
    });
  });

  group('CreateHabit', () {
    test('возвращает созданную привычку при успехе', () async {
      when(() => mockRepository.createHabit(any())).thenAnswer(
        (_) async => const Right<Failure, Habit>(_testHabit),
      );

      final result = await CreateHabit(mockRepository)(_testHabit);

      expect(result, const Right<Failure, Habit>(_testHabit));
      verify(() => mockRepository.createHabit(_testHabit)).called(1);
    });

    test('возвращает Failure при ошибке', () async {
      const failure = ServerFailure('Ошибка сервера');
      when(() => mockRepository.createHabit(any())).thenAnswer(
        (_) async => const Left<Failure, Habit>(failure),
      );

      final result = await CreateHabit(mockRepository)(_testHabit);

      expect(result, const Left<Failure, Habit>(failure));
    });
  });

  group('UpdateHabit', () {
    test('возвращает обновлённую привычку при успехе', () async {
      const updatedHabit = Habit(id: '1', userId: 'user1', title: 'Бег 2');
      when(() => mockRepository.updateHabit(any())).thenAnswer(
        (_) async => const Right<Failure, Habit>(updatedHabit),
      );

      final result = await UpdateHabit(mockRepository)(updatedHabit);

      expect(result, const Right<Failure, Habit>(updatedHabit));
      verify(() => mockRepository.updateHabit(updatedHabit)).called(1);
    });

    test('возвращает Failure при ошибке', () async {
      const failure = CacheFailure('Ошибка обновления');
      when(() => mockRepository.updateHabit(any())).thenAnswer(
        (_) async => const Left<Failure, Habit>(failure),
      );

      final result = await UpdateHabit(mockRepository)(_testHabit);

      expect(result, const Left<Failure, Habit>(failure));
    });
  });

  group('DeleteHabit', () {
    test('вызывает deleteHabit с правильным id', () async {
      when(() => mockRepository.deleteHabit(any())).thenAnswer(
        (_) async => const Right<Failure, void>(null),
      );

      final result = await DeleteHabit(mockRepository)(
        const DeleteHabitParams(id: '1'),
      );

      expect(result, const Right<Failure, void>(null));
      verify(() => mockRepository.deleteHabit('1')).called(1);
    });

    test('возвращает Failure при ошибке', () async {
      const failure = CacheFailure('Не найдено');
      when(() => mockRepository.deleteHabit(any())).thenAnswer(
        (_) async => const Left<Failure, void>(failure),
      );

      final result = await DeleteHabit(mockRepository)(
        const DeleteHabitParams(id: '1'),
      );

      expect(result, const Left<Failure, void>(failure));
    });
  });

  group('ToggleCompletion', () {
    final testDate = DateTime(2026, 3, 27);

    test('вызывает toggleCompletion с правильными параметрами', () async {
      when(
        () => mockRepository.toggleCompletion(
          habitId: any(named: 'habitId'),
          date: any(named: 'date'),
        ),
      ).thenAnswer(
        (_) async => const Right<Failure, void>(null),
      );

      final result = await ToggleCompletion(mockRepository)(
        ToggleCompletionParams(habitId: '1', date: testDate),
      );

      expect(result, const Right<Failure, void>(null));
      verify(
        () => mockRepository.toggleCompletion(
          habitId: '1',
          date: testDate,
        ),
      ).called(1);
    });

    test('возвращает Failure при ошибке', () async {
      const failure = CacheFailure('Ошибка записи');
      when(
        () => mockRepository.toggleCompletion(
          habitId: any(named: 'habitId'),
          date: any(named: 'date'),
        ),
      ).thenAnswer(
        (_) async => const Left<Failure, void>(failure),
      );

      final result = await ToggleCompletion(mockRepository)(
        ToggleCompletionParams(habitId: '1', date: testDate),
      );

      expect(result, const Left<Failure, void>(failure));
    });
  });
}
