import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:habit_boost/features/habits/domain/entities/reminder_time.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Low-level wrapper around [FlutterLocalNotificationsPlugin].
///
/// Handles initialization, scheduling recurring notifications
/// per weekday, and cancelling them.
@lazySingleton
class NotificationService {
  NotificationService() : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const _channelId = 'habit_reminders';

  /// Must be called once at app startup.
  Future<void> init() async {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(settings);
  }

  /// Request notification permission (Android 13+ / iOS).
  /// Returns `true` if granted.
  Future<bool> requestPermission() async {
    // Android 13+
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }

    // iOS
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }

    return true;
  }

  /// Schedule weekly recurring notifications for a habit.
  ///
  /// Creates one notification per [reminderTimes] entry per [scheduleDays]
  /// entry. Supports up to 10 reminder times per habit.
  Future<void> scheduleHabitReminders({
    required String habitId,
    required String title,
    required List<ReminderTime> reminderTimes,
    required List<int> scheduleDays,
    required List<String> bodyTemplates,
    required String channelName,
    required String channelDesc,
  }) async {
    // Cancel existing first to avoid duplicates.
    await cancelHabitReminders(habitId);

    for (var ri = 0; ri < reminderTimes.length; ri++) {
      final rt = reminderTimes[ri];
      for (final day in scheduleDays) {
        final id = _notificationId(habitId, ri, day);
        final scheduledDate =
            _nextInstanceOfWeekday(day, rt.hour, rt.minute);
        final body = bodyTemplates[id % bodyTemplates.length];

      await _plugin.zonedSchedule(
        id,
        'HabitBoost',
        body,
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            channelName,
            channelDescription: channelDesc,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
      }
    }
  }

  /// Cancel all scheduled notifications for a habit.
  /// Covers up to 10 reminder slots x 7 weekdays = 70 IDs.
  Future<void> cancelHabitReminders(String habitId) async {
    for (var ri = 0; ri < 10; ri++) {
      for (var day = 1; day <= 7; day++) {
        await _plugin.cancel(_notificationId(habitId, ri, day));
      }
    }
    // Also cancel old-format IDs (hash * 10 + day) from
    // before migration — clamp to 32-bit range.
    for (var day = 1; day <= 7; day++) {
      final oldId = habitId.hashCode * 10 + day;
      if (oldId >= -2147483648 && oldId <= 2147483647) {
        await _plugin.cancel(oldId);
      }
    }
  }

  /// Cancel every pending notification.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ── Helpers ──────────────────────────────────────────────

  /// Deterministic notification ID from habit ID + reminder index + weekday.
  ///
  /// The result must fit in a signed 32-bit integer
  /// (flutter_local_notifications requirement).
  /// We truncate the hash to leave room for the suffix
  /// (reminderIndex 0-9 × 10 + weekday 1-7 → max 97), keeping the sign bit
  /// clear so IDs stay positive.
  int _notificationId(String habitId, int reminderIndex, int weekday) {
    // 2 147 483 647 / 100 = 21 474 836 → safe base range.
    final base =
        habitId.hashCode.abs() % 21474836;
    return base * 100 + reminderIndex * 10 + weekday;
  }

  /// Returns the next [tz.TZDateTime] for the given weekday and time.
  tz.TZDateTime _nextInstanceOfWeekday(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Move to the correct weekday.
    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    // If the time is already past for this week, push to next week.
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }

    return scheduled;
  }
}
