import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/features/onboarding/presentation/widgets/page_dots.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            color: AppColors.bgCard,
            child: const Icon(
              Icons.eco,
              size: 120,
              color: AppColors.primary,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.paddingXL),
                Text(
                  'Создавай полезные привычки',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                Text(
                  'HabitBoost поможет вам выработать полезные '
                  'привычки шаг за шагом. Отслеживайте прогресс, '
                  'получайте напоминания и достигайте целей '
                  'каждый день.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: onNext,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Далее',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                const PageDots(count: 3, current: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
