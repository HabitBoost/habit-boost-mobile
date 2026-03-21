import 'package:habit_boost/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:habit_boost/features/onboarding/domain/entities/user_goals.dart';
import 'package:habit_boost/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._local);

  final OnboardingLocalDataSource _local;

  @override
  Future<bool> isOnboardingCompleted() => _local.isOnboardingCompleted();

  @override
  Future<void> completeOnboarding() => _local.completeOnboarding();

  @override
  Future<void> saveGoals(List<GoalCategory> goals) {
    return _local.saveGoals(goals.map((g) => g.name).toList());
  }

  @override
  Future<List<GoalCategory>> getGoals() async {
    final names = await _local.getGoals();
    return names
        .map(
          (name) => GoalCategory.values
              .where((g) => g.name == name)
              .firstOrNull,
        )
        .whereType<GoalCategory>()
        .toList();
  }
}
