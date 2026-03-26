import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/extensions/l10n_extension.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileAbout)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        children: [
          const SizedBox(height: AppDimensions.paddingL),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.eco,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'HabitBoost',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.aboutVersion,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Text(
            l10n.appSlogan,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          _buildInfoSection(
            context,
            colors,
            icon: Icons.track_changes,
            title: l10n.aboutHabitTracking,
            description: l10n.aboutHabitTrackingDesc,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          _buildInfoSection(
            context,
            colors,
            icon: Icons.cloud_sync,
            title: l10n.aboutCloudSync,
            description: l10n.aboutCloudSyncDesc,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          _buildInfoSection(
            context,
            colors,
            icon: Icons.book_outlined,
            title: l10n.aboutMoodJournal,
            description: l10n.aboutMoodJournalDesc,
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Text(
            l10n.aboutCopyright,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colors.textTertiary),
          ),
          Text(
            l10n.aboutMadeWith,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colors.textTertiary),
          ),
          const SizedBox(height: AppDimensions.paddingL),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    AppColorsTheme colors, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(
          AppDimensions.radiusCard,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
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
