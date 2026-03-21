import 'package:habit_boost/features/onboarding/domain/entities/user_goals.dart';

abstract class OnboardingRepository {
  Future<bool> isOnboardingCompleted();
  Future<void> completeOnboarding();
  Future<void> saveGoals(List<GoalCategory> goals);
  Future<List<GoalCategory>> getGoals();
}
