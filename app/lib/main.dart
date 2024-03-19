import 'dart:async';
import 'dart:io';
import 'package:background_fetch/background_fetch.dart';
import 'package:cloud_gallery/firebase_options.dart';
import 'package:data/storage/provider/preferences_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (Platform.isAndroid) {
    // Workaround for https://github.com/flutter/flutter/issues/35162
    await FlutterDisplayMode.setHighRefreshRate();
  }

  final container = await _configureContainerWithAsyncDependency();

  _backgroundFetchTaskConfigure();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CloudGalleryApp(),
    ),
  );
}

Future<ProviderContainer> _configureContainerWithAsyncDependency() async {
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );
  return container;
}

Future<void> _backgroundFetchTaskConfigure() async {
  // Register to receive BackgroundFetch events after app is terminated.
  await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  // Optionally configure the plugin by setting the minimum time between
  BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        forceAlarmManager: true,
      ), (String taskId) async {
    if (taskId == 'com.canopas.googleDriveBackUp') {
      for (var i = 0; i < 10; i++) {
        print('BackgroundFetch: $i');
        await Future.delayed(const Duration(seconds: 1));
      }
      final pref = await SharedPreferences.getInstance();
      await pref.setBool('is_onboard_complete', false);
      BackgroundFetch.finish(taskId);
    }
  }, (String taskId) async {
    print("[BackgroundFetch Configure] taskId: $taskId timed out.");
  });
  await BackgroundFetch.scheduleTask(TaskConfig(
    taskId: 'com.canopas.googleDriveBackUp',
    stopOnTerminate: false,
    periodic: true,
    enableHeadless: true,
    forceAlarmManager: true,
    delay: 0,
  ));
}

@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  final pref = await SharedPreferences.getInstance();
  await pref.setBool('is_onboard_complete', false);
  BackgroundFetch.finish(taskId);
}
