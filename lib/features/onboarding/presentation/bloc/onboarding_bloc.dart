import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_boost/features/onboarding/domain/entities/user_goals.dart';
import 'package:habit_boost/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:injectable/injectable.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc(this._repository) : super(const OnboardingState()) {
    on<OnboardingCheckRequested>(_onCheck);
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingGoalToggled>(_onGoalToggled);
    on<OnboardingGoalsUpdated>(_onGoalsUpdated);
    on<OnboardingCompleted>(_onCompleted);
  }

  final OnboardingRepository _repository;

  Future<void> _onCheck(
    OnboardingCheckRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    final completed =
        await _repository.isOnboardingCompleted();
    final goals = await _repository.getGoals();
    emit(
      state.copyWith(
        isCompleted: completed,
        selectedGoals: goals,
        isLoading: false,
      ),
    );
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(currentPage: event.page));
  }

  void _onGoalToggled(
    OnboardingGoalToggled event,
    Emitter<OnboardingState> emit,
  ) {
    final goals =
        List<GoalCategory>.from(state.selectedGoals);
    if (goals.contains(event.goal)) {
      goals.remove(event.goal);
    } else {
      goals.add(event.goal);
    }
    emit(state.copyWith(selectedGoals: goals));
  }

  Future<void> _onGoalsUpdated(
    OnboardingGoalsUpdated event,
    Emitter<OnboardingState> emit,
  ) async {
    await _repository.saveGoals(event.goals);
    emit(state.copyWith(selectedGoals: event.goals));
  }

  Future<void> _onCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    await _repository.saveGoals(state.selectedGoals);
    await _repository.completeOnboarding();
    emit(state.copyWith(isCompleted: true));
  }
}
