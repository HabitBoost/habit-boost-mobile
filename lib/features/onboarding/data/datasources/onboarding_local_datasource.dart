import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> isOnboardingCompleted();
  Future<void> completeOnboarding();
  Future<void> saveGoals(List<String> goals);
  Future<List<String>> getGoals();
}

@LazySingleton(as: OnboardingLocalDataSource)
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  const OnboardingLocalDataSourceImpl(this._prefs);

  static const _completedKey = 'onboarding_completed';
  static const _goalsKey = 'user_goals';
  final SharedPreferences _prefs;

  @override
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(_completedKey) ?? false;
  }

  @override
  Future<void> completeOnboarding() async {
    await _prefs.setBool(_completedKey, true);
  }

  @override
  Future<void> saveGoals(List<String> goals) async {
    await _prefs.setStringList(_goalsKey, goals);
  }

  @override
  Future<List<String>> getGoals() async {
    return _prefs.getStringList(_goalsKey) ?? [];
  }
}
