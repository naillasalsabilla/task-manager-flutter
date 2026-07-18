import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const darwinSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _notifications.initialize(
      settings: initializationSettings,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> scheduleTaskNotification({
    required int id,
    required String title,
    required DateTime deadline,
  }) async {
    final scheduledDate = tz.TZDateTime(
      tz.local,
      deadline.year,
      deadline.month,
      deadline.day,
      9,
      0,
    );

    if (scheduledDate.isBefore(
      tz.TZDateTime.now(tz.local),
    )) {
      return;
    }

    await _notifications.zonedSchedule(
      id: id,
      title: 'Deadline Task',
      body: title,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_deadline_channel',
          'Task Deadline',
          channelDescription:
              'Notifikasi deadline task',
          importance: Importance.high,
          priority: Priority.high,
        ),

        iOS: DarwinNotificationDetails(),
      ),

      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> cancelTaskNotification(
    int id,
  ) async {
    await _notifications.cancel(id: id);
  }
}