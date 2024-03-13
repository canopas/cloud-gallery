import 'package:cloud_gallery/ui/flow/accounts/accounts_screen.dart';
import 'package:cloud_gallery/ui/flow/media_preview/image_preview_screen.dart';
import 'package:cloud_gallery/ui/flow/media_preview/video_preview_screen.dart';
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

  static AppRoute imagePreview(
          {required String path,
          required String heroTag,
          required bool isLocal}) =>
      AppRoute(
        AppRoutePath.imagePreview,
        builder: (context) =>
            ImagePreviewScreen(url: path, isLocal: isLocal, heroTag: heroTag),
      );

  static AppRoute videoPreview(
          {required String path,
          required String heroTag,
          required bool isLocal}) =>
      AppRoute(
        AppRoutePath.videoPreview,
        builder: (context) => const VideoPreviewScreen(),
      );

  static final routes = <GoRoute>[
    home.goRoute,
    onBoard.goRoute,
    accounts.goRoute,
    GoRoute(
      path: AppRoutePath.imagePreview,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: AppRoutePath.videoPreview,
      builder: (context, state) => state.widget(context),
    ),
  ];
}

class AppRoutePath {
  static const home = '/';
  static const onBoard = '/on-board';
  static const accounts = '/accounts';
  static const imagePreview = '/image_preview';
  static const videoPreview = '/video_preview';
}
