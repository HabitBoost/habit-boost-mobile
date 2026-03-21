import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_boost/app/router/routes.dart';
import 'package:habit_boost/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:habit_boost/features/onboarding/presentation/screens/goal_selection_page.dart';
import 'package:habit_boost/features/onboarding/presentation/screens/notification_permission_page.dart';
import 'package:habit_boost/features/onboarding/presentation/screens/welcome_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onComplete() {
    context.read<OnboardingBloc>().add(const OnboardingCompleted());
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (prev, curr) =>
          prev.currentPage != curr.currentPage,
      listener: (context, state) {
        _goToPage(state.currentPage);
      },
      child: Scaffold(
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              context
                  .read<OnboardingBloc>()
                  .add(OnboardingPageChanged(page));
            },
            children: [
              WelcomePage(onNext: () => _goToPage(1)),
              GoalSelectionPage(onNext: () => _goToPage(2)),
              NotificationPermissionPage(onComplete: _onComplete),
            ],
          ),
        ),
      ),
    );
  }
}
