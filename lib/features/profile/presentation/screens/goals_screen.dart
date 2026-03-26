import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/extensions/l10n_extension.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/features/onboarding/domain/entities/user_goals.dart';
import 'package:habit_boost/features/onboarding/presentation/bloc/onboarding_bloc.dart';
class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late List<GoalCategory> _selected;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final state = context.read<OnboardingBloc>().state;
      _selected = List.from(state.selectedGoals);
      _initialized = true;
    }
  }

  void _toggle(GoalCategory goal) {
    setState(() {
      if (_selected.contains(goal)) {
        _selected.remove(goal);
      } else {
        _selected.add(goal);
      }
    });
  }

  void _save() {
    context.read<OnboardingBloc>().add(
          OnboardingGoalsUpdated(_selected),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.goalsTitle),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(l10n.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.goalsSubtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                    color: colors.textSecondary,
                  ),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            Expanded(
              child: _buildGoalGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalGrid() {
    final l10n = context.l10n;
    const goals = GoalCategory.values;
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
                    isSelected: _selected.contains(goals[i]),
                    onTap: () => _toggle(goals[i]),
                  ),
                ),
                const SizedBox(width: 12),
                if (i + 1 < goals.length)
                  Expanded(
                    child: _GoalChip(
                      goal: goals[i + 1],
                      label: goals[i + 1].localizedLabel(l10n),
                      isSelected:
                          _selected.contains(goals[i + 1]),
                      onTap: () => _toggle(goals[i + 1]),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
      ],
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
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
