import 'package:flutter/material.dart';
import 'package:habit_boost/app/di/injection_container.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/features/notifications/domain/repositories/notification_repository.dart';
import 'package:habit_boost/features/onboarding/presentation/widgets/page_dots.dart';

class NotificationPermissionPage extends StatelessWidget {
  const NotificationPermissionPage({
    required this.onComplete,
    super.key,
  });

  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
      ),
      child: Column(
        children: [
          const SizedBox(height: 120),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              size: 48,
              color: AppColors.accentCoral,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Text(
            'Не пропускай привычки',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppDimensions.paddingS + 4),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingS,
            ),
            child: Text(
              'Включите уведомления, чтобы получать '
              'напоминания о привычках в нужное время '
              'и не пропускать ни одного дня.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                    color: colors.textSecondary,
                    height: 1.5,
                  ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () async {
                await sl<NotificationRepository>().requestPermission();
                onComplete();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentCoral,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Разрешить уведомления',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          TextButton(
            onPressed: onComplete,
            child: Text(
              'Пропустить',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          const PageDots(count: 3, current: 2),
          const SizedBox(height: AppDimensions.paddingXL),
        ],
      ),
    );
  }
}
