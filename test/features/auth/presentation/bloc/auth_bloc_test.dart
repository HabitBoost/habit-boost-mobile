import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_boost/core/error/failures.dart';
import 'package:habit_boost/core/usecases/usecase.dart';
import 'package:habit_boost/features/auth/domain/entities/user.dart';
import 'package:habit_boost/features/auth/domain/usecases/login.dart';
import 'package:habit_boost/features/auth/domain/usecases/register.dart';
import 'package:habit_boost/features/auth/domain/usecases/reset_password.dart';
import 'package:habit_boost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_classes.dart';

const _testUser = AppUser(id: '1', email: 'test@test.com', name: 'Test');

void main() {
  late AuthBloc bloc;
  late MockLogin mockLogin;
  late MockRegister mockRegister;
  late MockLogout mockLogout;
  late MockGetCurrentUser mockGetCurrentUser;
  late MockResetPassword mockResetPassword;

  setUpAll(() {
    registerFallbackValue(
      const LoginParams(email: '', password: ''),
    );
    registerFallbackValue(
      const RegisterParams(email: '', password: '', name: ''),
    );
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const ResetPasswordParams(email: ''),
    );
  });

  setUp(() {
    mockLogin = MockLogin();
    mockRegister = MockRegister();
    mockLogout = MockLogout();
    mockGetCurrentUser = MockGetCurrentUser();
    mockResetPassword = MockResetPassword();
    bloc = AuthBloc(
      login: mockLogin,
      register: mockRegister,
      logout: mockLogout,
      getCurrentUser: mockGetCurrentUser,
      resetPassword: mockResetPassword,
    );
  });

  tearDown(() => bloc.close());

  group('AuthCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [Loading, Authenticated] when user is logged in',
      build: () {
        when(() => mockGetCurrentUser(any()))
            .thenAnswer((_) async => const Right(_testUser));
        return bloc;
      },
      act: (bloc) =>
          bloc.add(const AuthCheckRequested()),
      expect: () => [
        const AuthLoading(),
        const Authenticated(_testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [Loading, Unauthenticated] when no user',
      build: () {
        when(() => mockGetCurrentUser(any())).thenAnswer(
          (_) async =>
              const Left(AuthFailure('Not authenticated')),
        );
        return bloc;
      },
      act: (bloc) =>
          bloc.add(const AuthCheckRequested()),
      expect: () => [
        const AuthLoading(),
        const Unauthenticated(),
      ],
    );
  });

  group('AuthLoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [Loading, Authenticated] on success',
      build: () {
        when(() => mockLogin(any()))
            .thenAnswer((_) async => const Right(_testUser));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(
          email: 'test@test.com',
          password: '123456',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const Authenticated(_testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockLogin(any())).thenAnswer(
          (_) async => const Left(AuthFailure('Wrong password')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(
          email: 'test@test.com',
          password: 'wrong',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const AuthError('Wrong password'),
      ],
    );
  });

  group('AuthRegisterRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [Loading, Authenticated] on success',
      build: () {
        when(() => mockRegister(any()))
            .thenAnswer((_) async => const Right(_testUser));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const AuthRegisterRequested(
          email: 'test@test.com',
          password: '123456',
          name: 'Test',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const Authenticated(_testUser),
      ],
    );
  });

  group('AuthLogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [Loading, Unauthenticated] on success',
      build: () {
        when(() => mockLogout(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) =>
          bloc.add(const AuthLogoutRequested()),
      expect: () => [
        const AuthLoading(),
        const Unauthenticated(),
      ],
    );
  });

  group('AuthResetPasswordRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [Loading, PasswordResetSent] on success',
      build: () {
        when(() => mockResetPassword(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const AuthResetPasswordRequested(
          email: 'test@test.com',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const AuthPasswordResetSent(),
      ],
    );
  });
}
