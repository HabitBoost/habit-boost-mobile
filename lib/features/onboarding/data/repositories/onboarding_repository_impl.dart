import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_boost/core/utils/app_logger.dart';
import 'package:habit_boost/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:habit_boost/features/onboarding/domain/entities/user_goals.dart';
import 'package:habit_boost/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(
    this._local,
    this._firebaseAuth,
    this._firestore,
  );

  final OnboardingLocalDataSource _local;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Future<bool> isOnboardingCompleted() =>
      _local.isOnboardingCompleted();

  @override
  Future<void> completeOnboarding() async {
    await _local.completeOnboarding();
    await _syncToFirestore({'onboardingCompleted': true});
  }

  @override
  Future<void> saveGoals(List<GoalCategory> goals) async {
    await _local.saveGoals(
      goals.map((g) => g.name).toList(),
    );
    await _syncToFirestore({
      'goals': goals.map((g) => g.name).toList(),
    });
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

  Future<void> _syncToFirestore(
    Map<String, dynamic> data,
  ) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return;
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update(data);
    } on Exception catch (e) {
      log.w('Failed to sync onboarding to Firestore',
          error: e);
    }
  }
}
