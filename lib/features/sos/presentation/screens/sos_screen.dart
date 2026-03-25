import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  static const _techniques = [
    _Technique(
      icon: Icons.air,
      title: 'Дыхание 4-7-8',
      description: 'Вдох 4 сек → задержка 7 сек → выдох 8 сек. '
          'Повторите 3–4 раза.',
      color: AppColors.accentIndigo,
    ),
    _Technique(
      icon: Icons.visibility_outlined,
      title: 'Техника 5-4-3-2-1',
      description: 'Назовите 5 вещей, которые видите, '
          '4 — слышите, 3 — ощущаете, '
          '2 — чувствуете запах, 1 — вкус.',
      color: AppColors.accentGreen,
    ),
    _Technique(
      icon: Icons.self_improvement,
      title: 'Сканирование тела',
      description: 'Закройте глаза. Медленно переведите внимание '
          'от макушки к стопам, замечая ощущения.',
      color: AppColors.accentOrange,
    ),
    _Technique(
      icon: Icons.directions_walk,
      title: 'Смена обстановки',
      description: 'Встаньте, пройдитесь, выпейте воды. '
          'Даже 2 минуты движения помогают.',
      color: AppColors.primary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Экстренная помощь'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.accentCoral.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusCard,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'SOS',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.accentCoral,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingS),
                Text(
                  'Сорвались или на грани? Это нормально.\n'
                  'Используйте техники ниже, чтобы вернуть контроль.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Text(
            'Техники самопомощи',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          ..._techniques.map(
            (t) => Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimensions.paddingS,
              ),
              child: _TechniqueCard(technique: t),
            ),
          ),
        ],
      ),
    );
  }
}

class _Technique {
  const _Technique({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
}

class _TechniqueCard extends StatelessWidget {
  const _TechniqueCard({required this.technique});

  final _Technique technique;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(
          AppDimensions.radiusCard,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: technique.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusButton,
              ),
            ),
            child: Icon(
              technique.icon,
              color: technique.color,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  technique.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  technique.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
