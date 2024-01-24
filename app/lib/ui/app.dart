import 'package:cloud_gallery/ui/navigation/app_router.dart';
import 'package:cloud_gallery/utils/extensions/context_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:style/theme/theme.dart';
import 'package:style/theme/app_theme_builder.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late GoRouter _router;

  @override
  void initState() {
    _router = GoRouter(
      initialLocation: AppRoutePath.home,
      routes: AppRouter.routes,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        context.isDarkMode ? appColorSchemeDark : appColorSchemeLight;
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
