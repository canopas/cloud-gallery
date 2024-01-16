import 'package:cloud_gallery/ui/navigation/app_router.dart';
import 'package:cloud_gallery/utils/extensions/context_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late GoRouter _router;

  @override
  void initState() {
    _router = GoRouter(initialLocation: AppRoutePath.home, routes: AppRouter.routes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return CupertinoApp.router(
        onGenerateTitle: (context) => context.l10n.app_name,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router,
      );
    }
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.app_name,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
