import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_period.dart';

class PeriodSelector extends StatelessWidget {
  const PeriodSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final ProgressPeriod selected;
  final ValueChanged<ProgressPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PeriodChip(
            label: 'Неделя',
            isSelected:
                selected == ProgressPeriod.week,
            onTap: () =>
                onChanged(ProgressPeriod.week),
          ),
          _PeriodChip(
            label: 'Месяц',
            isSelected:
                selected == ProgressPeriod.month,
            onTap: () =>
                onChanged(ProgressPeriod.month),
          ),
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentCoral
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected
                ? FontWeight.w600
                : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
