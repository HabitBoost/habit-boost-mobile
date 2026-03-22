import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_stats.dart';

class HabitProgressBar extends StatelessWidget {
  const HabitProgressBar({
    required this.progress,
    super.key,
  });

  final HabitProgress progress;

  Color get _color {
    if (progress.completionRate >= 0.9) {
      return AppColors.accentGreen;
    } else if (progress.completionRate >= 0.7) {
      return AppColors.accentIndigo;
    } else {
      return AppColors.accentOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pct = (progress.completionRate * 100).round();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                progress.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '$pct%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.completionRate,
            backgroundColor: AppColors.bgCard,
            valueColor: AlwaysStoppedAnimation<Color>(_color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
