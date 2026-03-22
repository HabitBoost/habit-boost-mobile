import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
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

  static const _tagColors = {
    'Продуктивность': (AppColors.accentGreen, AppColors.badgeGreenBg),
    'Рефлексия': (AppColors.accentOrange, AppColors.badgeYellowBg),
    'Здоровье': (AppColors.accentIndigo, AppColors.badgeIndigoBg),
    'Спорт': (AppColors.accentGreen, AppColors.badgeGreenBg),
    'Учёба': (AppColors.accentIndigo, AppColors.badgeIndigoBg),
  };

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat(
      'd MMMM',
      'ru',
    ).format(entry.date);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
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
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              entry.content,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
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
                  final colors = _tagColors[tag];
                  final textColor =
                      colors?.$1 ?? AppColors.textSecondary;
                  final bgColor =
                      colors?.$2 ?? AppColors.bgCard;

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
