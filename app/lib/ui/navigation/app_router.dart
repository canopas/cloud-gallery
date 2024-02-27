import 'package:cloud_gallery/ui/flow/accounts/accounts_screen.dart';
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

  static AppRoute get accounts => AppRoute(
        AppRoutePath.accounts,
        builder: (context) => const AccountsScreen(),
      );

  static final routes = <GoRoute>[
    home.goRoute,
    onBoard.goRoute,
    accounts.goRoute,
  ];
}

class AppRoutePath {
  static const home = '/';
  static const onBoard = '/on-board';
  static const accounts = '/accounts';
}
