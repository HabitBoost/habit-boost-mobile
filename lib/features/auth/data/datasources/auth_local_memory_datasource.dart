import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_boost/core/error/exceptions.dart';
import 'package:habit_boost/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:habit_boost/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

/// Local implementation of [AuthRemoteDataSource] that stores users
/// in [FlutterSecureStorage]. Used for development without a backend.
/// Can be replaced with Supabase/Firebase by swapping the DI environment.
@LazySingleton(as: AuthRemoteDataSource)
class LocalAuthRemoteDataSource implements AuthRemoteDataSource {
  const LocalAuthRemoteDataSource(this._storage);

  final FlutterSecureStorage _storage;

  static const _usersKey = 'local_users';
  static const _currentUserKey = 'local_current_user';

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final users = await _readUsers();
    final rawEntry = users[email];

    if (rawEntry == null) {
      throw const ServerException('Пользователь не найден');
    }

    final userEntry = Map<String, dynamic>.from(rawEntry as Map);

    if (userEntry['password'] != password) {
      throw const ServerException('Неверный пароль');
    }

    final user = UserModel(
      id: userEntry['id'] as String,
      email: email,
      name: userEntry['name'] as String? ?? '',
    );

    await _setCurrentUser(user);
    return user;
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final users = await _readUsers();

    if (users.containsKey(email)) {
      throw const ServerException(
        'Пользователь с таким email уже существует',
      );
    }

    final id = 'local_${DateTime.now().millisecondsSinceEpoch}';
    users[email] = {
      'id': id,
      'name': name,
      'password': password,
    };
    await _writeUsers(users);

    final user = UserModel(id: id, email: email, name: name);
    await _setCurrentUser(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: _currentUserKey);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final json = await _storage.read(key: _currentUserKey);
    if (json == null) return null;
    return UserModel.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> resetPassword({required String email}) async {
    final users = await _readUsers();
    if (!users.containsKey(email)) {
      throw const ServerException('Пользователь не найден');
    }
    // No-op in local mode — no email to send.
  }

  Future<Map<String, dynamic>> _readUsers() async {
    final json = await _storage.read(key: _usersKey);
    if (json == null) return {};
    return Map<String, dynamic>.from(
      jsonDecode(json) as Map,
    );
  }

  Future<void> _writeUsers(Map<String, dynamic> users) async {
    await _storage.write(
      key: _usersKey,
      value: jsonEncode(users),
    );
  }

  Future<void> _setCurrentUser(UserModel user) async {
    await _storage.write(
      key: _currentUserKey,
      value: jsonEncode(user.toJson()),
    );
  }
}
