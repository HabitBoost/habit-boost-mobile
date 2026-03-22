import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_stats.dart';

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({
    required this.dayCompletions,
    super.key,
  });

  final List<DayCompletion> dayCompletions;

  static const _dayLabels = [
    'ПН',
    'ВТ',
    'СР',
    'ЧТ',
    'ПТ',
    'СБ',
    'ВС',
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday =
        today.subtract(Duration(days: today.weekday - 1));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius:
            BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (i) {
          final date = monday.add(Duration(days: i));
          final completion = dayCompletions.where(
            (d) =>
                d.date.year == date.year &&
                d.date.month == date.month &&
                d.date.day == date.day,
          );
          final dc =
              completion.isEmpty ? null : completion.first;
          final isToday = date == today;
          final allDone = dc != null &&
              dc.totalCount > 0 &&
              dc.completedCount == dc.totalCount;
          final partial = dc != null &&
              dc.completedCount > 0 &&
              !allDone;

          Color circleColor;
          Color textColor;
          if (allDone) {
            circleColor = AppColors.accentGreen;
            textColor = Colors.white;
          } else if (partial) {
            circleColor =
                AppColors.accentGreen.withValues(alpha: 0.3);
            textColor = AppColors.textPrimary;
          } else if (isToday) {
            circleColor = AppColors.accentCoral;
            textColor = Colors.white;
          } else {
            circleColor = Colors.transparent;
            textColor = AppColors.textPrimary;
          }

          return Column(
            children: [
              Text(
                _dayLabels[i],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: circleColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
