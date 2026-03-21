part of 'onboarding_bloc.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    this.currentPage = 0,
    this.selectedGoals = const [],
    this.isCompleted = false,
    this.isLoading = true,
  });

  final int currentPage;
  final List<GoalCategory> selectedGoals;
  final bool isCompleted;
  final bool isLoading;

  OnboardingState copyWith({
    int? currentPage,
    List<GoalCategory>? selectedGoals,
    bool? isCompleted,
    bool? isLoading,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      isCompleted: isCompleted ?? this.isCompleted,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        selectedGoals,
        isCompleted,
        isLoading,
      ];
}
