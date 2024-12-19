import 'dart:async';
import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'components/snack_bar.dart';
import 'domain/handlers/deep_links_handler.dart';
import 'firebase_options.dart';
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

  if (!kDebugMode) {
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  if (Platform.isAndroid) {
    // Workaround for https://github.com/flutter/flutter/issues/35162
    await FlutterDisplayMode.setHighRefreshRate();
  }

  final container = await _configureContainerWithAsyncDependency();

  try {
    DeepLinkHandler.observeDeepLinks(container: container);
  } catch (e) {
    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();
    final context = scaffoldMessengerKey.currentContext;
    if (context != null && context.mounted) {
      showErrorSnackBar(context: context, error: e);
    }
  }

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
