import 'dart:async';
import 'dart:io';
import 'package:cloud_gallery/firebase_options.dart';
import 'package:data/storage/provider/preferences_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
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

  Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
  );

  Workmanager().registerOneOffTask("cloud-gallery-background-process", "simpleTask");

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

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print("task executed");
    return Future.value(true);
  });
}