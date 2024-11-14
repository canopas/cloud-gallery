import '../../ui/navigation/app_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  Future<void> init(BuildContext context) async {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    if (context.mounted) _initLocalNotifications(context);
  }

  void requestPermission() {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> _initLocalNotifications(BuildContext context) async {
    _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('cloud_gallery_logo'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        if (context.mounted) {
          context.go(AppRoutePath.home);
          context.push(AppRoutePath.transfer);
        }
      },
    );

    final initial = await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    if (initial?.didNotificationLaunchApp == true) {
      if (context.mounted) {
        context.go(AppRoutePath.home);
        context.push(AppRoutePath.transfer);
      }
    }
  }

  Future<void> showNotification({
    required int id,
    required String name,
    required String description,
    bool vibration = true,
    int? progress,
    int maxProgress = 100,
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
          channelDescription: _androidChannel.description,
        ),
      ),
    );
  }
}
