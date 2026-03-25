import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_boost/app/di/injection_container.dart';
import 'package:habit_boost/app/router/routes.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/constants/app_strings.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/domain/repositories/habits_repository.dart';
import 'package:habit_boost/features/habits/presentation/widgets/habit_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitDetailScreen extends StatefulWidget {
  const HabitDetailScreen({required this.habit, super.key});

  final Habit habit;

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  late Habit _habit;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _habit = widget.habit;
    _loadNotificationSetting();
  }

  Future<void> _loadNotificationSetting() async {
    final prefs = sl<SharedPreferences>();
    final enabled = prefs.getBool('notifications_enabled') ?? true;
    if (mounted) {
      setState(() => _notificationsEnabled = enabled);
    }
  }

  Future<void> _openEdit() async {
    final result = await context.push<bool>(
      Routes.editHabit,
      extra: _habit,
    );
    if ((result ?? false) && mounted) {
      final either =
          await sl<HabitsRepository>().getHabit(_habit.id);
      either.fold(
        (_) {},
        (updated) => setState(() => _habit = updated),
      );
      // Re-check notification setting in case user toggled it.
      await _loadNotificationSetting();
    }
  }

  Color get _habitColor {
    final hexCode = _habit.color.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали привычки'),
        actions: [
          IconButton(
            onPressed: _openEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context),
            const SizedBox(height: AppDimensions.paddingM),
            _buildStatsGrid(context),
            const SizedBox(height: AppDimensions.paddingL),
            _buildScheduleSection(context, colors),
            const SizedBox(height: AppDimensions.paddingL),
            _buildReminderSection(context, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _habitColor,
            _habitColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(
          AppDimensions.radiusCard,
        ),
      ),
      child: Column(
        children: [
          HabitIcon(
            icon: _habit.icon,
            color: Colors.white,
            size: 64,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            _habit.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusChip,
              ),
            ),
            child: Text(
              _habit.category,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department,
            iconColor: AppColors.accentOrange,
            label: AppStrings.currentStreak,
            value: '${_habit.currentStreak}',
          ),
        ),
        const SizedBox(width: AppDimensions.paddingS),
        Expanded(
          child: _StatCard(
            icon: Icons.emoji_events,
            iconColor: AppColors.accentYellow,
            label: AppStrings.bestStreak,
            value: '${_habit.bestStreak}',
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleSection(
    BuildContext context,
    AppColorsTheme colors,
  ) {
    const dayLabels = [
      'Пн',
      'Вт',
      'Ср',
      'Чт',
      'Пт',
      'Сб',
      'Вс',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Расписание',
          style:
              Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final day = index + 1;
            final isActive = _habit.scheduleDays.contains(day);
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isActive
                    ? _habitColor.withValues(alpha: 0.15)
                    : colors.bgCard,
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusChip,
                ),
                border: isActive
                    ? Border.all(color: _habitColor)
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                dayLabels[index],
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(
                      color: isActive
                          ? _habitColor
                          : colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildReminderSection(
    BuildContext context,
    AppColorsTheme colors,
  ) {
    if (!_habit.reminderEnabled) {
      return const SizedBox.shrink();
    }

    final showWarning =
        _habit.reminderEnabled && !_notificationsEnabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: colors.bgCard,
            borderRadius: BorderRadius.circular(
              AppDimensions.radiusCard,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Напоминание',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      _habit.reminderTimes
                          .map((t) => t.toStorageString())
                          .join(', '),
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
        ),
        if (showWarning) ...[
          const SizedBox(height: AppDimensions.paddingS),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            decoration: BoxDecoration(
              color: AppColors.accentOrange.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusCard,
              ),
              border: Border.all(
                color: AppColors.accentOrange.withValues(
                  alpha: 0.3,
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_off_outlined,
                  color: AppColors.accentOrange,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.paddingS),
                Expanded(
                  child: Text(
                    'Уведомления отключены в настройках. '
                    'Включите их в профиле, чтобы '
                    'получать напоминания.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          color: AppColors.accentOrange,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

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
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            value,
            style:
                Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
