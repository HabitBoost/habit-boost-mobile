import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';

class MoodSelector extends StatelessWidget {
  const MoodSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final Mood selected;
  final ValueChanged<Mood> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Row(
      children: Mood.values.map((mood) {
        final isSelected = mood == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(mood),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accentCoral
                        .withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.accentCoral
                      : colors.borderSubtle,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Icon(
                mood.icon,
                size: 28,
                color: isSelected
                    ? AppColors.accentCoral
                    : colors.textTertiary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
