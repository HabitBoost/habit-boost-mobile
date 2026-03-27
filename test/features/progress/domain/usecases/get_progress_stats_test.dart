import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_period.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_stats.dart';
import 'package:habit_boost/features/progress/domain/usecases/get_progress_stats.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_classes.dart';

const _testStats = ProgressStats(
  todayCompleted: 3,
  todayTotal: 5,
  currentStreak: 7,
  periodRate: 0.75,
  habitProgresses: [],
  dayCompletions: [],
);

void main() {
  late MockProgressRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(ProgressPeriod.week);
  });

  setUp(() {
    mockRepository = MockProgressRepository();
  });

  group('GetProgressStats', () {
    test('возвращает статистику за неделю при успехе', () async {
      when(
        () => mockRepository.getProgressStats(
          userId: any(named: 'userId'),
          period: any(named: 'period'),
        ),
      ).thenAnswer(
        (_) async =>
            const Right<Failure, ProgressStats>(_testStats),
      );

      final result = await GetProgressStats(mockRepository)(
        const GetProgressStatsParams(
          userId: 'user1',
          period: ProgressPeriod.week,
        ),
      );

      expect(result, const Right<Failure, ProgressStats>(_testStats));
      verify(
        () => mockRepository.getProgressStats(
          userId: 'user1',
          period: ProgressPeriod.week,
        ),
      ).called(1);
    });

    test('возвращает статистику за месяц при успехе', () async {
      when(
        () => mockRepository.getProgressStats(
          userId: any(named: 'userId'),
          period: any(named: 'period'),
        ),
      ).thenAnswer(
        (_) async =>
            const Right<Failure, ProgressStats>(_testStats),
      );

      final result = await GetProgressStats(mockRepository)(
        const GetProgressStatsParams(
          userId: 'user1',
          period: ProgressPeriod.month,
        ),
      );

      expect(result, const Right<Failure, ProgressStats>(_testStats));
      verify(
        () => mockRepository.getProgressStats(
          userId: 'user1',
          period: ProgressPeriod.month,
        ),
      ).called(1);
    });

    test('возвращает CacheFailure при ошибке', () async {
      const failure = CacheFailure('Ошибка загрузки');
      when(
        () => mockRepository.getProgressStats(
          userId: any(named: 'userId'),
          period: any(named: 'period'),
        ),
      ).thenAnswer(
        (_) async =>
            const Left<Failure, ProgressStats>(failure),
      );

      final result = await GetProgressStats(mockRepository)(
        const GetProgressStatsParams(
          userId: 'user1',
          period: ProgressPeriod.week,
        ),
      );

      expect(result, const Left<Failure, ProgressStats>(failure));
    });
  });
}
