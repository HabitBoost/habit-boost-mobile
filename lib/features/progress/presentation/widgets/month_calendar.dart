import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/extensions/l10n_extension.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_stats.dart';
import 'package:intl/intl.dart';

class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    required this.dayCompletions,
    super.key,
  });

  final List<DayCompletion> dayCompletions;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final l10n = context.l10n;
    final dayLabels = [
      l10n.dayMonShort,
      l10n.dayTueShort,
      l10n.dayWedShort,
      l10n.dayThuShort,
      l10n.dayFriShort,
      l10n.daySatShort,
      l10n.daySunShort,
    ];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final firstOfMonth = DateTime(now.year, now.month);
    final daysInMonth =
        DateTime(now.year, now.month + 1, 0).day;
    final startWeekday = firstOfMonth.weekday;
    final locale = Localizations.localeOf(context).languageCode;
    final monthName = DateFormat('LLLL', locale).format(now);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: Column(
        children: [
          Text(
            monthName[0].toUpperCase() + monthName.substring(1),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: dayLabels
                .map(
                  (l) => SizedBox(
                    width: 36,
                    child: Text(
                      l,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colors.textTertiary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          ..._buildWeeks(
            colors, today, firstOfMonth, daysInMonth, startWeekday,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWeeks(
    AppColorsTheme colors,
    DateTime today,
    DateTime firstOfMonth,
    int daysInMonth,
    int startWeekday,
  ) {
    final weeks = <Widget>[];
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
            textColor = colors.textPrimary;
          } else if (isToday) {
            circleColor = AppColors.accentCoral;
            textColor = Colors.white;
          } else {
            circleColor = Colors.transparent;
            textColor = colors.textPrimary;
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
}
