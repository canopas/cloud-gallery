import '../flow/accounts/accounts_screen.dart';
import '../flow/albums/albums_screen.dart';
import '../flow/main/main_screen.dart';
import '../flow/media_transfer/media_transfer_screen.dart';
import '../flow/onboard/onboard_screen.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../flow/home/home_screen.dart';
import '../flow/media_metadata_details/media_metadata_details.dart';
import '../flow/media_preview/media_preview_screen.dart';

part 'app_route.g.dart';

class AppRoutePath {
  static const home = '/';
  static const albums = '/albums';
  static const onBoard = '/on-board';
  static const accounts = '/accounts';
  static const preview = '/preview';
  static const transfer = '/transfer';
  static const metaDataDetails = '/metadata-details';
}

@TypedGoRoute<OnBoardRoute>(path: AppRoutePath.onBoard)
class OnBoardRoute extends GoRouteData {
  const OnBoardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnBoardScreen();
}

@TypedStatefulShellRoute<MainShellRoute>(
  branches: [
    TypedStatefulShellBranch<HomeShellBranch>(
      routes: [
        TypedGoRoute<HomeRoute>(path: AppRoutePath.home),
      ],
    ),
    TypedStatefulShellBranch<AlbumsShellBranch>(
      routes: [
        TypedGoRoute<AlbumsRoute>(path: AppRoutePath.albums),
      ],
    ),
    TypedStatefulShellBranch<TransferShellBranch>(
      routes: [
        TypedGoRoute<TransferRoute>(path: AppRoutePath.transfer),
      ],
    ),
    TypedStatefulShellBranch<AccountsShellBranch>(
      routes: [
        TypedGoRoute<AccountRoute>(path: AppRoutePath.accounts),
      ],
    ),
  ],
)
class MainShellRoute extends StatefulShellRouteData {
  const MainShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) =>
      MainScreen(navigationShell: navigationShell);
}

class HomeShellBranch extends StatefulShellBranchData {}

class AlbumsShellBranch extends StatefulShellBranchData {}

class TransferShellBranch extends StatefulShellBranchData {}

class AccountsShellBranch extends StatefulShellBranchData {}

class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class AlbumsRoute extends GoRouteData {
  const AlbumsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AlbumsScreen();
}

class TransferRoute extends GoRouteData {
  const TransferRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MediaTransferScreen();
}

class AccountRoute extends GoRouteData {
  const AccountRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AccountsScreen();
}

class MediaPreviewRouteData {
  final List<AppMedia> medias;
  final String startFrom;

  const MediaPreviewRouteData({required this.medias, required this.startFrom});
}

@TypedGoRoute<MediaPreviewRoute>(path: AppRoutePath.preview)
class MediaPreviewRoute extends GoRouteData {
  final MediaPreviewRouteData $extra;

  const MediaPreviewRoute({required this.$extra});

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      opaque: false,
      key: state.pageKey,
      child: MediaPreview(medias: $extra.medias, startFrom: $extra.startFrom),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

@TypedGoRoute<MediaMetadataDetailsRoute>(path: AppRoutePath.metaDataDetails)
class MediaMetadataDetailsRoute extends GoRouteData {
  final AppMedia $extra;

  const MediaMetadataDetailsRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MediaMetadataDetailsScreen(media: $extra);
}
