import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/core/usecases/usecase.dart';
import 'package:habit_boost/features/auth/domain/entities/user.dart';
import 'package:habit_boost/features/auth/domain/usecases/get_current_user.dart';
import 'package:habit_boost/features/auth/domain/usecases/login.dart';
import 'package:habit_boost/features/auth/domain/usecases/logout.dart';
import 'package:habit_boost/features/auth/domain/usecases/register.dart';
import 'package:habit_boost/features/auth/domain/usecases/reset_password.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_classes.dart';

const _testUser = AppUser(id: '1', email: 'test@test.com', name: 'Test');

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  group('Login', () {
    test('возвращает AppUser при успехе', () async {
      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const Right<Failure, AppUser>(_testUser),
      );

      final result = await Login(mockRepository)(
        const LoginParams(email: 'test@test.com', password: '123456'),
      );

      expect(result, const Right<Failure, AppUser>(_testUser));
      verify(
        () => mockRepository.login(
          email: 'test@test.com',
          password: '123456',
        ),
      ).called(1);
    });

    test('возвращает AuthFailure при ошибке', () async {
      const failure = AuthFailure('Неверный пароль');
      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const Left<Failure, AppUser>(failure),
      );

      final result = await Login(mockRepository)(
        const LoginParams(email: 'test@test.com', password: 'wrong'),
      );

      expect(result, const Left<Failure, AppUser>(failure));
    });
  });

  group('Register', () {
    test('возвращает AppUser при успехе', () async {
      when(
        () => mockRepository.register(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer(
        (_) async => const Right<Failure, AppUser>(_testUser),
      );

      final result = await Register(mockRepository)(
        const RegisterParams(
          email: 'test@test.com',
          password: '123456',
          name: 'Test',
        ),
      );

      expect(result, const Right<Failure, AppUser>(_testUser));
      verify(
        () => mockRepository.register(
          email: 'test@test.com',
          password: '123456',
          name: 'Test',
        ),
      ).called(1);
    });

    test('возвращает Failure при ошибке регистрации', () async {
      const failure = AuthFailure('Email уже занят');
      when(
        () => mockRepository.register(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer(
        (_) async => const Left<Failure, AppUser>(failure),
      );

      final result = await Register(mockRepository)(
        const RegisterParams(
          email: 'taken@test.com',
          password: '123456',
          name: 'Test',
        ),
      );

      expect(result, const Left<Failure, AppUser>(failure));
    });
  });

  group('Logout', () {
    test('вызывает logout у репозитория и возвращает Right(null)', () async {
      when(() => mockRepository.logout()).thenAnswer(
        (_) async => const Right<Failure, void>(null),
      );

      final result = await Logout(mockRepository)(NoParams());

      expect(result, const Right<Failure, void>(null));
      verify(() => mockRepository.logout()).called(1);
    });

    test('возвращает Failure при ошибке', () async {
      const failure = ServerFailure('Ошибка сети');
      when(() => mockRepository.logout()).thenAnswer(
        (_) async => const Left<Failure, void>(failure),
      );

      final result = await Logout(mockRepository)(NoParams());

      expect(result, const Left<Failure, void>(failure));
    });
  });

  group('GetCurrentUser', () {
    test('возвращает AppUser когда пользователь авторизован', () async {
      when(() => mockRepository.getCurrentUser()).thenAnswer(
        (_) async => const Right<Failure, AppUser>(_testUser),
      );

      final result = await GetCurrentUser(mockRepository)(NoParams());

      expect(result, const Right<Failure, AppUser>(_testUser));
    });

    test('возвращает AuthFailure когда пользователь не авторизован', () async {
      const failure = AuthFailure('Не авторизован');
      when(() => mockRepository.getCurrentUser()).thenAnswer(
        (_) async => const Left<Failure, AppUser>(failure),
      );

      final result = await GetCurrentUser(mockRepository)(NoParams());

      expect(result, const Left<Failure, AppUser>(failure));
    });
  });

  group('ResetPassword', () {
    test('вызывает resetPassword с правильным email', () async {
      when(
        () => mockRepository.resetPassword(email: any(named: 'email')),
      ).thenAnswer(
        (_) async => const Right<Failure, void>(null),
      );

      final result = await ResetPassword(mockRepository)(
        const ResetPasswordParams(email: 'test@test.com'),
      );

      expect(result, const Right<Failure, void>(null));
      verify(
        () => mockRepository.resetPassword(email: 'test@test.com'),
      ).called(1);
    });

    test('возвращает Failure при ошибке', () async {
      const failure = ServerFailure('Email не найден');
      when(
        () => mockRepository.resetPassword(email: any(named: 'email')),
      ).thenAnswer(
        (_) async => const Left<Failure, void>(failure),
      );

      final result = await ResetPassword(mockRepository)(
        const ResetPasswordParams(email: 'unknown@test.com'),
      );

      expect(result, const Left<Failure, void>(failure));
    });
  });
}
