import 'package:cloud_gallery/ui/flow/main/main_screen.dart';
import 'package:cloud_gallery/ui/flow/settings%20/settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'app_route.dart';

class AppRouter {
  static AppRoute get home => AppRoute(
        AppRoutePath.home,
        builder: (context) => const HomeScreen(),
      );

  static AppRoute get settings => AppRoute(
        AppRoutePath.settings,
        builder: (context) => const SettingsScreen(),
      );

  static final routes = <GoRoute>[
    home.goRoute,
    GoRoute(
      path: AppRoutePath.settings,
      builder: (context, state) => state.widget(context),
    ),
  ];
}

class AppRoutePath {
  static const home = '/';
  static const settings = '/settings';
}
