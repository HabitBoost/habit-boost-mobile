import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_period.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_stats.dart';
import 'package:habit_boost/features/progress/domain/usecases/get_progress_stats.dart';
import 'package:habit_boost/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProgressStats extends Mock
    implements GetProgressStats {}

void main() {
  late MockGetProgressStats mockGetProgressStats;

  const testStats = ProgressStats(
    todayCompleted: 2,
    todayTotal: 5,
    currentStreak: 3,
    periodRate: 0.8,
    habitProgresses: [],
    dayCompletions: [],
  );

  setUpAll(() {
    registerFallbackValue(
      const GetProgressStatsParams(
        userId: '',
        period: ProgressPeriod.week,
      ),
    );
  });

  setUp(() {
    mockGetProgressStats = MockGetProgressStats();
  });

  ProgressBloc buildBloc() => ProgressBloc(
        getProgressStats: mockGetProgressStats,
      );

  group('ProgressLoadRequested', () {
    blocTest<ProgressBloc, ProgressState>(
      'emits [loading, loaded] on success',
      build: () {
        when(() => mockGetProgressStats(any()))
            .thenAnswer((_) async => const Right(testStats));
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const ProgressLoadRequested(userId: 'user1'),
      ),
      expect: () => [
        const ProgressState(status: ProgressStatus.loading),
        const ProgressState(
          status: ProgressStatus.loaded,
          stats: testStats,
        ),
      ],
    );

    blocTest<ProgressBloc, ProgressState>(
      'emits [loading, error] on failure',
      build: () {
        when(() => mockGetProgressStats(any())).thenAnswer(
          (_) async => const Left(CacheFailure('Ошибка')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const ProgressLoadRequested(userId: 'user1'),
      ),
      expect: () => [
        const ProgressState(status: ProgressStatus.loading),
        const ProgressState(
          status: ProgressStatus.error,
          errorMessage: 'Ошибка',
        ),
      ],
    );
  });

  group('ProgressPeriodChanged', () {
    blocTest<ProgressBloc, ProgressState>(
      'updates period and reloads',
      build: () {
        when(() => mockGetProgressStats(any()))
            .thenAnswer((_) async => const Right(testStats));
        return buildBloc();
      },
      seed: () => const ProgressState(
        status: ProgressStatus.loaded,
        stats: testStats,
      ),
      act: (bloc) {
        bloc
          ..add(
            const ProgressLoadRequested(userId: 'user1'),
          )
          ..add(
            const ProgressPeriodChanged(
              period: ProgressPeriod.month,
            ),
          );
      },
      expect: () => [
        const ProgressState(
          status: ProgressStatus.loading,
          stats: testStats,
        ),
        const ProgressState(
          status: ProgressStatus.loaded,
          stats: testStats,
        ),
        const ProgressState(
          status: ProgressStatus.loaded,
          stats: testStats,
          period: ProgressPeriod.month,
        ),
        const ProgressState(
          status: ProgressStatus.loading,
          stats: testStats,
          period: ProgressPeriod.month,
        ),
        const ProgressState(
          status: ProgressStatus.loaded,
          stats: testStats,
          period: ProgressPeriod.month,
        ),
      ],
    );
  });
}
