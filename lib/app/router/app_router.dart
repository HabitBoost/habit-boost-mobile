import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_boost/app/di/injection_container.dart';
import 'package:habit_boost/app/router/routes.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_strings.dart';
import 'package:habit_boost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habit_boost/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:habit_boost/features/auth/presentation/screens/login_screen.dart';
import 'package:habit_boost/features/auth/presentation/screens/register_screen.dart';
import 'package:habit_boost/features/auth/presentation/screens/splash_screen.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/presentation/bloc/habits_bloc.dart';
import 'package:habit_boost/features/habits/presentation/screens/add_edit_habit_screen.dart';
import 'package:habit_boost/features/habits/presentation/screens/habit_detail_screen.dart';
import 'package:habit_boost/features/habits/presentation/screens/home_screen.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';
import 'package:habit_boost/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:habit_boost/features/journal/presentation/screens/journal_entry_screen.dart';
import 'package:habit_boost/features/journal/presentation/screens/journal_screen.dart';
import 'package:habit_boost/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:habit_boost/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:habit_boost/features/profile/presentation/screens/profile_screen.dart';
import 'package:habit_boost/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:habit_boost/features/progress/presentation/screens/progress_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder: (context, state) =>
                NoTransitionPage(
              child: BlocProvider(
                create: (_) => sl<HabitsBloc>(),
                child: const HomeScreen(),
              ),
            ),
          ),
          GoRoute(
            path: Routes.progress,
            pageBuilder: (context, state) =>
                NoTransitionPage(
              child: BlocProvider(
                create: (_) => sl<ProgressBloc>(),
                child: const ProgressScreen(),
              ),
            ),
          ),
          GoRoute(
            path: Routes.journal,
            pageBuilder: (context, state) =>
                NoTransitionPage(
              child: BlocProvider(
                create: (_) => sl<JournalBloc>(),
                child: const JournalScreen(),
              ),
            ),
          ),
          GoRoute(
            path: Routes.profile,
            pageBuilder: (context, state) =>
                const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.addHabit,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            const AddEditHabitScreen(),
      ),
      GoRoute(
        path: Routes.editHabit,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final habit = state.extra! as Habit;
          return AddEditHabitScreen(habit: habit);
        },
      ),
      GoRoute(
        path: Routes.habitDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final habit = state.extra! as Habit;
          return HabitDetailScreen(habit: habit);
        },
      ),
      GoRoute(
        path: Routes.journalEntry,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final entry = state.extra as JournalEntry?;
          return BlocProvider.value(
            value: sl<JournalBloc>(),
            child: JournalEntryScreen(entry: entry),
          );
        },
      ),
      GoRoute(
        path: Routes.sos,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'SOS'),
      ),
    ],
  );
}

/// Creates all global BLoC providers wrapping the app.
Widget createBlocProviders({required Widget child}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
      BlocProvider<OnboardingBloc>(
        create: (_) => sl<OnboardingBloc>(),
      ),
    ],
    child: child,
  );
}

class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.child});

  final Widget child;

  static const _tabs = [
    Routes.home,
    Routes.progress,
    Routes.journal,
    Routes.profile,
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _tabs.indexWhere(location.startsWith);
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          context.go(_tabs[index]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: AppStrings.home,
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: AppStrings.progress,
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: AppStrings.journal,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.construction,
              size: 64,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Скоро здесь будет контент',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
