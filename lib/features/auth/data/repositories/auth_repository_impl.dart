import 'package:dartz/dartz.dart';
import 'package:habit_boost/core/error/exceptions.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:habit_boost/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:habit_boost/features/auth/domain/entities/user.dart';
import 'package:habit_boost/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote, this._local);

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<Either<Failure, AppUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remote.login(email: email, password: password);
      await _local.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AppUser>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await _remote.register(
        email: email,
        password: password,
        name: name,
      );
      await _local.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remote.logout();
      await _local.clearCache();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AppUser>> getCurrentUser() async {
    try {
      final remoteUser = await _remote.getCurrentUser();
      if (remoteUser != null) {
        await _local.cacheUser(remoteUser);
        return Right(remoteUser);
      }
      final cachedUser = await _local.getCachedUser();
      if (cachedUser != null) return Right(cachedUser);
      return const Left(AuthFailure('Not authenticated'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException {
      return const Left(AuthFailure('Not authenticated'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await _remote.resetPassword(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
