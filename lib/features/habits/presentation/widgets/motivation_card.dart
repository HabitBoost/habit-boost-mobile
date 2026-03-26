import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/extensions/l10n_extension.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/l10n/app_localizations.dart';

class MotivationCard extends StatelessWidget {
  const MotivationCard({super.key});

  static List<String> _quotes(AppLocalizations l10n) => [
        l10n.quote0,
        l10n.quote1,
        l10n.quote2,
        l10n.quote3,
        l10n.quote4,
      ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final quotes = _quotes(context.l10n);
    final quoteIndex = DateTime.now().day % quotes.length;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: colors.bgHighlight,
        borderRadius:
            BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color:
              AppColors.accentYellow.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Text(
            '\u{1F4A1}',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Expanded(
            child: Text(
              quotes[quoteIndex],
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: colors.textPrimary,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
