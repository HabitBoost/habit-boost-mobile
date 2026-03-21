import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_boost/features/onboarding/domain/entities/user_goals.dart';
import 'package:habit_boost/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_classes.dart';

void main() {
  late OnboardingBloc bloc;
  late MockOnboardingRepository mockRepository;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    bloc = OnboardingBloc(mockRepository);
  });

  tearDown(() => bloc.close());

  group('OnboardingCheckRequested', () {
    blocTest<OnboardingBloc, OnboardingState>(
      'emits state with isCompleted=false when not completed',
      build: () {
        when(() => mockRepository.isOnboardingCompleted())
            .thenAnswer((_) async => false);
        when(() => mockRepository.getGoals())
            .thenAnswer((_) async => []);
        return bloc;
      },
      act: (bloc) =>
          bloc.add(const OnboardingCheckRequested()),
      expect: () => [
        const OnboardingState(isLoading: false),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'emits state with isCompleted=true and goals',
      build: () {
        when(() => mockRepository.isOnboardingCompleted())
            .thenAnswer((_) async => true);
        when(() => mockRepository.getGoals())
            .thenAnswer((_) async => [GoalCategory.health]);
        return bloc;
      },
      act: (bloc) =>
          bloc.add(const OnboardingCheckRequested()),
      expect: () => [
        const OnboardingState(
          isCompleted: true,
          selectedGoals: [GoalCategory.health],
          isLoading: false,
        ),
      ],
    );
  });

  group('OnboardingGoalToggled', () {
    blocTest<OnboardingBloc, OnboardingState>(
      'adds goal when not selected',
      build: () => bloc,
      act: (bloc) => bloc.add(
        const OnboardingGoalToggled(GoalCategory.health),
      ),
      expect: () => [
        const OnboardingState(
          selectedGoals: [GoalCategory.health],
        ),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'removes goal when already selected',
      build: () => bloc,
      seed: () => const OnboardingState(
        selectedGoals: [GoalCategory.health],
      ),
      act: (bloc) => bloc.add(
        const OnboardingGoalToggled(GoalCategory.health),
      ),
      expect: () => [
        const OnboardingState(),
      ],
    );
  });

  group('OnboardingCompleted', () {
    blocTest<OnboardingBloc, OnboardingState>(
      'saves goals and completes onboarding',
      build: () {
        when(
          () => mockRepository.saveGoals(any()),
        ).thenAnswer((_) async {});
        when(
          () => mockRepository.completeOnboarding(),
        ).thenAnswer((_) async {});
        return bloc;
      },
      seed: () => const OnboardingState(
        selectedGoals: [GoalCategory.health, GoalCategory.sport],
      ),
      act: (bloc) =>
          bloc.add(const OnboardingCompleted()),
      expect: () => [
        const OnboardingState(
          selectedGoals: [
            GoalCategory.health,
            GoalCategory.sport,
          ],
          isCompleted: true,
        ),
      ],
      verify: (_) {
        verify(
          () => mockRepository.saveGoals(
            [GoalCategory.health, GoalCategory.sport],
          ),
        ).called(1);
        verify(() => mockRepository.completeOnboarding())
            .called(1);
      },
    );
  });
}
