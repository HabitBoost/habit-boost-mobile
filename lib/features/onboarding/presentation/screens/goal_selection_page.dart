import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/extensions/l10n_extension.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/features/onboarding/domain/entities/user_goals.dart';
import 'package:habit_boost/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:habit_boost/features/onboarding/presentation/widgets/page_dots.dart';

class GoalSelectionPage extends StatelessWidget {
  const GoalSelectionPage({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            l10n.onboardingGoalsTitle,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            l10n.onboardingGoalsSubtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colors.textSecondary,
                ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Expanded(child: _buildGoalGrid(context)),
          const SizedBox(height: AppDimensions.paddingL),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                l10n.next,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          const PageDots(count: 3, current: 1),
        ],
      ),
    );
  }

  Widget _buildGoalGrid(BuildContext context) {
    final l10n = context.l10n;
    const goals = GoalCategory.values;
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Column(
          children: [
            for (var i = 0; i < goals.length; i += 2)
              Padding(
                padding: EdgeInsets.only(
                  bottom: i + 2 < goals.length ? 12 : 0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _GoalChip(
                        goal: goals[i],
                        label: goals[i].localizedLabel(l10n),
                        isSelected:
                            state.selectedGoals.contains(goals[i]),
                        onTap: () => context
                            .read<OnboardingBloc>()
                            .add(
                              OnboardingGoalToggled(goals[i]),
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (i + 1 < goals.length)
                      Expanded(
                        child: _GoalChip(
                          goal: goals[i + 1],
                          label: goals[i + 1].localizedLabel(l10n),
                          isSelected: state.selectedGoals
                              .contains(goals[i + 1]),
                          onTap: () => context
                              .read<OnboardingBloc>()
                              .add(
                                OnboardingGoalToggled(
                                  goals[i + 1],
                                ),
                              ),
                        ),
                      )
                    else
                      const Expanded(child: SizedBox()),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _GoalChip extends StatelessWidget {
  const _GoalChip({
    required this.goal,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final GoalCategory goal;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isSelected
              ? colors.badgeGreenBg
              : colors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(
                  color: AppColors.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(goal.icon, size: 28, color: goal.color),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
