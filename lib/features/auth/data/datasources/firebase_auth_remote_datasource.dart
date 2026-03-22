import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_boost/core/error/exceptions.dart';
import 'package:habit_boost/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:habit_boost/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRemoteDataSource)
class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  const FirebaseAuthRemoteDataSource(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCol =>
      _firestore.collection('users');

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapAuthError(e.code));
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);

      final uid = credential.user!.uid;
      await _usersCol.doc(uid).set({
        'email': email,
        'name': name,
        'goals': <String>[],
        'onboardingCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return UserModel(id: uid, email: email, name: name);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapAuthError(e.code));
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _usersCol.doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        return UserModel(
          id: user.uid,
          email: user.email ?? '',
          name: data['name'] as String? ?? user.displayName ?? '',
          goals: (data['goals'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
          onboardingCompleted:
              data['onboardingCompleted'] as bool? ?? false,
        );
      }

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
      );
    } on FirebaseException {
      // Offline fallback — return basic user info from FirebaseAuth cache
      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
      );
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapAuthError(e.code));
    }
  }

  Future<UserModel> _userFromCredential(UserCredential credential) async {
    final user = credential.user!;
    try {
      final doc = await _usersCol.doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        return UserModel(
          id: user.uid,
          email: user.email ?? '',
          name: data['name'] as String? ?? user.displayName ?? '',
          goals: (data['goals'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
          onboardingCompleted:
              data['onboardingCompleted'] as bool? ?? false,
        );
      }
    } on FirebaseException {
      // Firestore unavailable, use auth data only
    }
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
    );
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Пользователь не найден';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Неверный пароль';
      case 'email-already-in-use':
        return 'Email уже используется';
      case 'weak-password':
        return 'Слишком простой пароль';
      case 'invalid-email':
        return 'Некорректный email';
      case 'user-disabled':
        return 'Аккаунт заблокирован';
      default:
        return 'Ошибка авторизации';
    }
  }
}
