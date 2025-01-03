import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'navigation/app_route.dart';
import '../domain/extensions/context_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/theme/theme.dart';
import 'package:style/theme/app_theme_builder.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:data/handlers/notification_handler.dart';

class CloudGalleryApp extends ConsumerStatefulWidget {
  const CloudGalleryApp({super.key});

  @override
  ConsumerState<CloudGalleryApp> createState() => _CloudGalleryAppState();
}

class _CloudGalleryAppState extends ConsumerState<CloudGalleryApp> {
  late GoRouter _router;
  late NotificationHandler _notificationHandler;

  String _configureInitialRoute() {
    if (!ref.read(AppPreferences.isOnBoardComplete)) {
      return AppRoutePath.onBoard;
    } else {
      return AppRoutePath.home;
    }
  }

  @override
  void initState() {
    _notificationHandler = ref.read(notificationHandlerProvider);
    _handleNotification();

    _router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: _configureInitialRoute(),
      routes: $appRoutes,
      redirect: (context, state) {
        if (state.uri.path.contains('/auth')) {
          return '/';
        }
        return null;
      },
    );
    super.initState();
  }

  Future<void> _handleNotification() async {
    final res = await _notificationHandler.init(
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationReceived,
      onDidReceiveNotificationResponse: (response) {
        ///TODO: manage notification tap
      },
    );
    if (res?.didNotificationLaunchApp == true) {
      ///TODO: manage notification tap
    }
  }

  @override
  void dispose() {
    PhotoManager.clearFileCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool? isDarkMode = ref.watch(AppPreferences.isDarkMode);
    final colorScheme = (isDarkMode ?? context.systemThemeIsDark)
        ? appColorSchemeDark
        : appColorSchemeLight;
    return AppTheme(
      colorScheme: colorScheme,
      child: _buildApp(
        context: context,
        colorScheme: colorScheme,
      ),
    );
  }

  Widget _buildApp({
    required BuildContext context,
    required AppColorScheme colorScheme,
  }) {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return CupertinoApp.router(
        onGenerateTitle: (context) => context.l10n.app_name,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router,
        theme: AppThemeBuilder.cupertinoThemeFromColorScheme(
          colorScheme: colorScheme,
        ),
      );
    }
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.app_name,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
      theme: AppThemeBuilder.materialThemeFromColorScheme(
        colorScheme: colorScheme,
      ),
    );
  }
}

@pragma('vm:entry-point')
void onBackgroundNotificationReceived(NotificationResponse response) {}
