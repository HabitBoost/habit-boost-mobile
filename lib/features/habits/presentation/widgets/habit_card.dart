import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/presentation/widgets/habit_icon.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    required this.habit,
    required this.isCompleted,
    required this.onToggle,
    this.onTap,
    super.key,
  });

  final Habit habit;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final habitColor = _parseColor(habit.color);

    return Material(
      color: isCompleted
          ? habitColor.withValues(alpha: 0.08)
          : AppColors.bgCard,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Row(
            children: [
              // Icon
              HabitIcon(
                icon: habit.icon,
                color: habitColor,
                isCompleted: isCompleted,
              ),
              const SizedBox(width: AppDimensions.paddingM),

              // Title + category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isCompleted
                                    ? AppColors.textSecondary
                                    : AppColors.textPrimary,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: habitColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusChip,
                            ),
                          ),
                          child: Text(
                            habit.category,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: habitColor),
                          ),
                        ),
                        if (habit.currentStreak > 0) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.local_fire_department,
                            size: 14,
                            color: AppColors.accentOrange,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${habit.currentStreak}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.accentOrange,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Toggle button
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted ? habitColor : Colors.transparent,
                    border: Border.all(
                      color: isCompleted
                          ? habitColor
                          : AppColors.borderEmpty,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
