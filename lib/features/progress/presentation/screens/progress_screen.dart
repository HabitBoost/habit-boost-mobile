import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_period.dart';
import 'package:habit_boost/features/progress/domain/entities/progress_stats.dart';
import 'package:habit_boost/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:habit_boost/features/progress/presentation/widgets/habit_progress_bar.dart';
import 'package:habit_boost/features/progress/presentation/widgets/month_calendar.dart';
import 'package:habit_boost/features/progress/presentation/widgets/period_selector.dart';
import 'package:habit_boost/features/progress/presentation/widgets/stats_card.dart';
import 'package:habit_boost/features/progress/presentation/widgets/week_calendar.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  void _loadProgress() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<ProgressBloc>().add(
            ProgressLoadRequested(userId: authState.user.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProgressBloc, ProgressState>(
          builder: (context, state) {
            if (state.status == ProgressStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == ProgressStatus.error) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'Ошибка загрузки',
                  style: const TextStyle(
                    color: AppColors.accentCoral,
                  ),
                ),
              );
            }

            final stats = state.stats;

            return RefreshIndicator(
              onRefresh: () async => _loadProgress(),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL,
                ),
                children: [
                  const SizedBox(height: AppDimensions.paddingM),
                  _buildHeader(state.period),
                  const SizedBox(height: AppDimensions.paddingL),
                  _buildStatsRow(stats, state.period),
                  const SizedBox(height: AppDimensions.paddingL),
                  if (state.period == ProgressPeriod.week)
                    WeekCalendar(
                      dayCompletions: stats.dayCompletions,
                    )
                  else
                    MonthCalendar(
                      dayCompletions: stats.dayCompletions,
                    ),
                  const SizedBox(height: AppDimensions.paddingL),
                  if (stats.habitProgresses.isNotEmpty)
                    _buildHabitProgress(stats),
                  const SizedBox(height: AppDimensions.paddingL),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ProgressPeriod period) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Прогресс',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        PeriodSelector(
          selected: period,
          onChanged: (p) => context
              .read<ProgressBloc>()
              .add(ProgressPeriodChanged(period: p)),
        ),
      ],
    );
  }

  Widget _buildStatsRow(
    ProgressStats s,
    ProgressPeriod period,
  ) {
    final ratePct = (s.periodRate * 100).round();
    final periodLabel = period == ProgressPeriod.week
        ? 'За неделю'
        : 'За месяц';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatsCard(
            value: '${s.todayCompleted}/${s.todayTotal}',
            label: 'Сегодня',
            valueColor: AppColors.accentCoral,
          ),
          const SizedBox(width: 12),
          StatsCard(
            value: '${s.currentStreak}',
            label: 'Текущий стрик',
            valueColor: AppColors.accentGreen,
          ),
          const SizedBox(width: 12),
          StatsCard(
            value: '$ratePct%',
            label: periodLabel,
            valueColor: AppColors.accentIndigo,
          ),
        ],
      ),
    );
  }

  Widget _buildHabitProgress(ProgressStats s) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Прогресс привычек',
          style:
              Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
        ),
        const SizedBox(height: 12),
        ...s.habitProgresses.map(
          (hp) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: HabitProgressBar(progress: hp),
          ),
        ),
      ],
    );
  }
}
