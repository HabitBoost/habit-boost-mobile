import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_boost/app/router/routes.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/extensions/l10n_extension.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habit_boost/features/habits/presentation/bloc/habits_bloc.dart';
import 'package:habit_boost/features/habits/presentation/widgets/habit_card.dart';
import 'package:habit_boost/features/habits/presentation/widgets/motivation_card.dart';
import 'package:habit_boost/features/habits/presentation/widgets/streak_banner.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String get _userId {
    final authState = context.read<AuthBloc>().state;
    return authState is Authenticated ? authState.user.id : '';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<HabitsBloc>()
          .add(HabitsLoadRequested(userId: _userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final l10n = context.l10n;
    final today = DateTime.now();
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat('d MMMM, EEEE', locale);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HabitsBloc, HabitsState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.paddingM,
                      AppDimensions.paddingM,
                      AppDimensions.paddingM,
                      AppDimensions.paddingS,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.navHome,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dateFormat.format(today),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: colors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.push(Routes.sos),
                          icon: const Text(
                            'SOS',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppColors.accentCoral,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              context.go(Routes.profile),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: colors.bgCard,
                            child: Icon(
                              Icons.person,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Motivation quote
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                    ),
                    child: MotivationCard(),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppDimensions.paddingS),
                ),

                // Streak banner
                if (state.status == HabitsStatus.loaded &&
                    state.habits.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingM,
                      ),
                      child: StreakBanner(
                        completedCount: state.completedCount,
                        totalCount: state.habits.length,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppDimensions.paddingM),
                ),

                // Section header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                    ),
                    child: Text(
                      l10n.habitTodayTitle,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppDimensions.paddingS),
                ),

                // Content
                _buildContent(context, state),

                // Bottom padding for FAB
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await context.push<bool>(Routes.addHabit);
          if ((result ?? false) && context.mounted) {
            context.read<HabitsBloc>().add(
                  HabitsLoadRequested(userId: _userId),
                );
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(l10n.habitAdd),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HabitsState state) {
    final colors = AppColorsTheme.of(context);
    final l10n = context.l10n;
    if (state.status == HabitsStatus.loading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.status == HabitsStatus.error) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.accentCoral,
              ),
              const SizedBox(height: 16),
              Text(
                state.errorMessage ?? l10n.errorSomethingWrong,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.read<HabitsBloc>().add(
                      HabitsLoadRequested(userId: _userId),
                    ),
                child: Text(l10n.errorTryAgain),
              ),
            ],
          ),
        ),
      );
    }

    if (state.habits.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emoji_nature_outlined,
                size: 80,
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.emptyHabits,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.emptyHabitsSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
      ),
      sliver: SliverList.separated(
        itemCount: state.habits.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppDimensions.paddingS),
        itemBuilder: (context, index) {
          final habit = state.habits[index];
          final isCompleted = state.isCompleted(habit.id);

          return HabitCard(
            habit: habit,
            isCompleted: isCompleted,
            onToggle: () => context.read<HabitsBloc>().add(
                  HabitToggleRequested(
                    habitId: habit.id,
                    userId: _userId,
                  ),
                ),
            onTap: () async {
              await context.push<bool>(
                Routes.habitDetail,
                extra: habit,
              );
              if (context.mounted) {
                context.read<HabitsBloc>().add(
                      HabitsLoadRequested(
                        userId: _userId,
                      ),
                    );
              }
            },
          );
        },
      ),
    );
  }
}
