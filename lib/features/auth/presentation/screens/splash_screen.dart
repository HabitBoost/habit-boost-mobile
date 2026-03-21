import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_boost/app/router/routes.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habit_boost/features/onboarding/presentation/bloc/onboarding_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthCheckRequested());
    context
        .read<OnboardingBloc>()
        .add(const OnboardingCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: _handleNavigation,
        ),
        BlocListener<OnboardingBloc, OnboardingState>(
          listenWhen: (prev, curr) =>
              prev.isLoading && !curr.isLoading,
          listener: _handleNavigation,
        ),
      ],
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Logo(),
              SizedBox(height: 200),
              _LoadingDots(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, dynamic state) {
    final authState = context.read<AuthBloc>().state;
    final onboardingState = context.read<OnboardingBloc>().state;

    if (authState is AuthLoading || onboardingState.isLoading) return;

    if (authState is Unauthenticated || authState is AuthError) {
      context.go(Routes.login);
    } else if (authState is Authenticated) {
      if (!onboardingState.isCompleted) {
        context.go(Routes.onboarding);
      } else {
        context.go(Routes.home);
      }
    }
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            Icons.eco,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'HabitBoost',
          style: TextStyle(
            fontFamily: 'BricolageGrotesque',
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Маленькие шаги к большим переменам',
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 14,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(1),
        const SizedBox(width: 8),
        _dot(0.5),
        const SizedBox(width: 8),
        _dot(0.3),
      ],
    );
  }

  Widget _dot(double opacity) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: opacity),
      ),
    );
  }
}
