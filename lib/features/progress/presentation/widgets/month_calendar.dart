import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_stats.dart';

class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    required this.dayCompletions,
    super.key,
  });

  final List<DayCompletion> dayCompletions;

  static const _dayLabels = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final firstOfMonth = DateTime(now.year, now.month);
    final daysInMonth =
        DateTime(now.year, now.month + 1, 0).day;
    // Monday = 1, Sunday = 7; offset for first day of month
    final startWeekday = firstOfMonth.weekday; // 1..7

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: Column(
        children: [
          Text(
            _monthName(now.month),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _dayLabels
                .map(
                  (l) => SizedBox(
                    width: 36,
                    child: Text(
                      l,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          ..._buildWeeks(today, firstOfMonth, daysInMonth, startWeekday),
        ],
      ),
    );
  }

  List<Widget> _buildWeeks(
    DateTime today,
    DateTime firstOfMonth,
    int daysInMonth,
    int startWeekday,
  ) {
    final weeks = <Widget>[];
    // Number of rows needed
    final totalCells = (startWeekday - 1) + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    for (var week = 0; week < rowCount; week++) {
      final cells = <Widget>[];
      for (var col = 0; col < 7; col++) {
        final cellIndex = week * 7 + col;
        final dayNum = cellIndex - (startWeekday - 1) + 1;

        if (dayNum < 1 || dayNum > daysInMonth) {
          cells.add(const SizedBox(width: 36, height: 36));
        } else {
          final date = DateTime(firstOfMonth.year, firstOfMonth.month, dayNum);
          final dc = _findCompletion(date);
          final isToday = date == today;
          final allDone = dc != null &&
              dc.totalCount > 0 &&
              dc.completedCount == dc.totalCount;
          final partial =
              dc != null && dc.completedCount > 0 && !allDone;

          Color circleColor;
          Color textColor;
          if (allDone) {
            circleColor = AppColors.accentGreen;
            textColor = Colors.white;
          } else if (partial) {
            circleColor = AppColors.accentGreen.withValues(alpha: 0.3);
            textColor = AppColors.textPrimary;
          } else if (isToday) {
            circleColor = AppColors.accentCoral;
            textColor = Colors.white;
          } else {
            circleColor = Colors.transparent;
            textColor = AppColors.textPrimary;
          }

          cells.add(
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: circleColor,
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Text(
                '$dayNum',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          );
        }
      }

      weeks.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: cells,
          ),
        ),
      );
    }
    return weeks;
  }

  DayCompletion? _findCompletion(DateTime date) {
    for (final dc in dayCompletions) {
      if (dc.date.year == date.year &&
          dc.date.month == date.month &&
          dc.date.day == date.day) {
        return dc;
      }
    }
    return null;
  }

  String _monthName(int month) {
    const names = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь',
    ];
    return names[month - 1];
  }
}
