part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

final class OnboardingCheckRequested extends OnboardingEvent {
  const OnboardingCheckRequested();
}

final class OnboardingPageChanged extends OnboardingEvent {
  const OnboardingPageChanged(this.page);

  final int page;

  @override
  List<Object?> get props => [page];
}

final class OnboardingGoalToggled extends OnboardingEvent {
  const OnboardingGoalToggled(this.goal);

  final GoalCategory goal;

  @override
  List<Object?> get props => [goal];
}

final class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}
