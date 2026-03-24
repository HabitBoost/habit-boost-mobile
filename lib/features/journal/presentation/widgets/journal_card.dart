import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';
import 'package:intl/intl.dart';

class JournalCard extends StatelessWidget {
  const JournalCard({
    required this.entry,
    required this.onTap,
    super.key,
  });

  final JournalEntry entry;
  final VoidCallback onTap;

  static const _tagTextColors = {
    'Продуктивность': AppColors.accentGreen,
    'Рефлексия': AppColors.accentOrange,
    'Здоровье': AppColors.accentIndigo,
    'Спорт': AppColors.accentGreen,
    'Учёба': AppColors.accentIndigo,
  };

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final tagBgColors = {
      'Продуктивность': colors.badgeGreenBg,
      'Рефлексия': colors.badgeYellowBg,
      'Здоровье': colors.badgeIndigoBg,
      'Спорт': colors.badgeGreenBg,
      'Учёба': colors.badgeIndigoBg,
    };

    final dateStr = DateFormat(
      'd MMMM',
      'ru',
    ).format(entry.date);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: colors.bgCard,
          borderRadius:
              BorderRadius.circular(AppDimensions.radiusCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  entry.mood.icon,
                  size: 24,
                  color: colors.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              entry.content,
              style: TextStyle(
                fontSize: 14,
                color: colors.textSecondary,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (entry.tags.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: entry.tags.map((tag) {
                  final textColor = _tagTextColors[tag] ??
                      colors.textSecondary;
                  final bgColor =
                      tagBgColors[tag] ?? colors.bgCard;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
