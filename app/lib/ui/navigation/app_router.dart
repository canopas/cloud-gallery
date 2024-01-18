import 'package:cloud_gallery/ui/flow/main/main_screen.dart';
import 'package:go_router/go_router.dart';
import 'app_route.dart';

class AppRouter {
  static AppRoute get home => AppRoute(
        AppRoutePath.home,
        builder: (context) => const HomeScreen(),
      );

  static final routes = <GoRoute>[
    home.goRoute,
  ];
}

class AppRoutePath {
  static const home = '/';
}
