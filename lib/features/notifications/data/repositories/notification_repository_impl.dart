import 'dart:ui';

import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/notifications/data/datasources/notification_service.dart';
import 'package:habit_boost/features/notifications/domain/repositories/notification_repository.dart';
import 'package:habit_boost/l10n/app_localizations.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this._service, this._prefs);

  final NotificationService _service;
  final SharedPreferences _prefs;

  Future<AppLocalizations> _loadL10n() async {
    final code = _prefs.getString('app_locale');
    final locale = code != null ? Locale(code) : const Locale('ru');
    return AppLocalizations.delegate.load(locale);
  }

  List<String> _bodyTemplates(AppLocalizations l10n, String title) => [
        l10n.notifTemplate0(title),
        l10n.notifTemplate1(title),
        l10n.notifTemplate2(title),
        l10n.notifTemplate3(title),
        l10n.notifTemplate4(title),
        l10n.notifTemplate5(title),
        l10n.notifTemplate6(title),
        l10n.notifTemplate7(title),
        l10n.notifTemplate8(title),
        l10n.notifTemplate9(title),
      ];

  @override
  Future<void> init() => _service.init();

  @override
  Future<bool> requestPermission() => _service.requestPermission();

  @override
  Future<void> scheduleForHabit(Habit habit) async {
    if (habit.reminderEnabled) {
      final l10n = await _loadL10n();
      await _service.scheduleHabitReminders(
        habitId: habit.id,
        title: habit.title,
        reminderTimes: habit.reminderTimes,
        scheduleDays: habit.scheduleDays,
        bodyTemplates: _bodyTemplates(l10n, habit.title),
        channelName: l10n.notifChannelName,
        channelDesc: l10n.notifChannelDesc,
      );
    } else {
      await _service.cancelHabitReminders(habit.id);
    }
  }

  @override
  Future<void> cancelForHabit(String habitId) =>
      _service.cancelHabitReminders(habitId);

  @override
  Future<void> cancelAll() => _service.cancelAll();

  @override
  Future<void> rescheduleAll(List<Habit> habits) async {
    await _service.cancelAll();
    for (final habit in habits) {
      if (habit.reminderEnabled) {
        await scheduleForHabit(habit);
      }
    }
  }
}
