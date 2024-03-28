import 'package:cloud_gallery/ui/flow/accounts/accounts_screen.dart';
import 'package:cloud_gallery/ui/flow/media_preview/image_preview/image_preview_screen.dart';
import 'package:cloud_gallery/ui/flow/media_preview/video_preview_screen.dart';
import 'package:cloud_gallery/ui/flow/onboard/onboard_screen.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
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

  static AppRoute imagePreview({required AppMedia media}) => AppRoute(
        AppRoutePath.imagePreview,
        builder: (context) => ImagePreviewScreen(media: media),
      );

  static AppRoute videoPreview({required String path, required bool isLocal}) =>
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
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          opaque: false,
          key: state.pageKey,
          child: state.widget(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
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
