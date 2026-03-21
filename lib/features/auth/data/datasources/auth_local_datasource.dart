import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_boost/core/error/exceptions.dart';
import 'package:habit_boost/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._secureStorage);

  static const _userKey = 'cached_user';
  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await _secureStorage.write(
        key: _userKey,
        value: jsonEncode(user.toJson()),
      );
    } catch (e) {
      throw CacheException('Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = await _secureStorage.read(key: _userKey);
      if (jsonString == null) return null;
      return UserModel.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    } catch (e) {
      throw CacheException('Failed to read cached user: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    await _secureStorage.delete(key: _userKey);
  }
}
