import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/extensions/l10n_extension.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/l10n/app_localizations.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  static List<_Technique> _techniques(AppLocalizations l10n) => [
        _Technique(
          icon: Icons.air,
          title: l10n.sosTechnique1Title,
          description: l10n.sosTechnique1Desc,
          color: AppColors.accentIndigo,
        ),
        _Technique(
          icon: Icons.visibility_outlined,
          title: l10n.sosTechnique2Title,
          description: l10n.sosTechnique2Desc,
          color: AppColors.accentGreen,
        ),
        _Technique(
          icon: Icons.self_improvement,
          title: l10n.sosTechnique3Title,
          description: l10n.sosTechnique3Desc,
          color: AppColors.accentOrange,
        ),
        _Technique(
          icon: Icons.directions_walk,
          title: l10n.sosTechnique4Title,
          description: l10n.sosTechnique4Desc,
          color: AppColors.primary,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final l10n = context.l10n;
    final techniques = _techniques(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sosTitle),
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
                  l10n.sosBanner,
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
            l10n.sosTechniquesTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          ...techniques.map(
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
