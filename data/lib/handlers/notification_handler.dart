import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _androidChannel = AndroidNotificationChannel(
  'notification-channel-cloud-gallery', // id
  'Cloud Gallery Notification', // title
  description:
      'This channel is used to notify you about the processes in the app.',
  // description
  importance: Importance.max,
);

final notificationHandlerProvider = Provider.autoDispose((ref) {
  return NotificationHandler();
});

class NotificationHandler {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<NotificationAppLaunchDetails?> init({
    void Function(NotificationResponse)?
        onDidReceiveBackgroundNotificationResponse,
    void Function(NotificationResponse)? onDidReceiveNotificationResponse,
  }) async {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    await _initLocalNotifications(
      onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse,
    );

    await requestPermission();

    return await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
  }

  Future<bool?> requestPermission() async {
    return await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<bool?> checkPermissionIsEnabled() async {
    if (Platform.isIOS) {
      final res = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.checkPermissions();

      return res?.isEnabled;
    } else {
      return await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
    }
  }

  Future<void> _initLocalNotifications(
    void Function(NotificationResponse)?
        onDidReceiveBackgroundNotificationResponse,
    void Function(NotificationResponse)? onDidReceiveNotificationResponse,
  ) async {
    _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('cloud_gallery_logo'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showNotification({
    required int id,
    required String name,
    required String description,
    AndroidNotificationCategory? category,
    bool fullScreenIntent = false,
    StyleInformation? styleInformation,
    bool setAsGroupSummary = false,
    String? groupKey,
    bool vibration = true,
    bool silent = false,
    int? progress,
    int maxProgress = 100,
    bool onlyAlertOnce = false,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      id,
      name,
      description,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelAction: AndroidNotificationChannelAction.update,
          _androidChannel.id,
          _androidChannel.name,
          icon: "cloud_gallery_logo",
          priority: Priority.defaultPriority,
          enableVibration: vibration,
          importance: Importance.defaultImportance,
          showProgress: progress != null,
          maxProgress: maxProgress,
          progress: progress ?? 0,
          groupKey: groupKey,
          category: category,
          silent: silent,
          fullScreenIntent: fullScreenIntent,
          groupAlertBehavior: GroupAlertBehavior.all,
          ongoing: progress != null,
          styleInformation: styleInformation,
          channelDescription: _androidChannel.description,
          setAsGroupSummary: setAsGroupSummary,
          onlyAlertOnce: onlyAlertOnce,
        ),
        iOS: DarwinNotificationDetails(
          presentSound: !silent,
          threadIdentifier: groupKey,
          presentBanner: !silent,
          presentAlert: !silent,
        ),
      ),
    );
  }
}
