import 'package:cloud_gallery/ui/flow/onboard/onboard_screen.dart';
import 'package:go_router/go_router.dart';
import '../flow/home/home_screen.dart';
import 'app_route.dart';

class AppRouter {
  static AppRoute get home => AppRoute(
        AppRoutePath.home,
        builder: (context) => const HomeScreen(),
      );

  static AppRoute get onBoard => AppRoute(
        AppRoutePath.onBoard,
        builder: (context) => const OnBoardScreen(),
      );

  static final routes = <GoRoute>[
    home.goRoute,
    onBoard.goRoute,
  ];
}

class AppRoutePath {
  static const home = '/';
  static const onBoard = '/on-board';
}
