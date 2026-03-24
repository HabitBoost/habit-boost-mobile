import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';

class MotivationCard extends StatelessWidget {
  const MotivationCard({super.key});

  // TODO(sergey): fetch from remote or local quotes list
  static const _quotes = [
    // Russian string cannot be split mid-word.
    // ignore: lines_longer_than_80_chars
    'Маленькие ежедневные улучшения — ключ к ошеломляющим долгосрочным результатам.',
    // Russian string cannot be split mid-word.
    // ignore: lines_longer_than_80_chars
    'Вы не поднимаетесь до уровня своих целей. Вы опускаетесь до уровня своих систем.',
    'Привычка — это не финишная черта, а образ жизни.',
    // Russian string cannot be split mid-word.
    // ignore: lines_longer_than_80_chars
    'Лучшее время посадить дерево было 20 лет назад. Второе лучшее время — сейчас.',
    'Дисциплина — это мост между целями и достижениями.',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final quoteIndex = DateTime.now().day % _quotes.length;

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
              _quotes[quoteIndex],
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
