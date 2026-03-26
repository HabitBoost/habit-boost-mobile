import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/extensions/l10n_extension.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';
import 'package:habit_boost/l10n/app_localizations.dart';
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
    'productivity': AppColors.accentGreen,
    'reflection': AppColors.accentOrange,
    'health': AppColors.accentIndigo,
    'sport': AppColors.accentGreen,
    'learning': AppColors.accentIndigo,
  };

  static String _tagLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'productivity':
        return l10n.tagProductivity;
      case 'reflection':
        return l10n.tagReflection;
      case 'health':
        return l10n.tagHealth;
      case 'sport':
        return l10n.tagSport;
      case 'learning':
        return l10n.tagLearning;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final l10n = context.l10n;
    final tagBgColors = {
      'productivity': colors.badgeGreenBg,
      'reflection': colors.badgeYellowBg,
      'health': colors.badgeIndigoBg,
      'sport': colors.badgeGreenBg,
      'learning': colors.badgeIndigoBg,
    };

    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat(
      'd MMMM',
      locale,
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
                      _tagLabel(tag, l10n),
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
