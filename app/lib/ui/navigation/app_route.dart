import 'package:data/models/album/album.dart';
import '../flow/accounts/accounts_screen.dart';
import '../flow/albums/add/add_album_screen.dart';
import '../flow/albums/albums_screen.dart';
import '../flow/albums/media_list/album_media_list_screen.dart';
import '../flow/main/main_screen.dart';
import '../flow/media_selection/media_selection_screen.dart';
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
  static const onBoard = '/on-board';
  static const home = '/';
  static const albums = '/albums';
  static const addAlbum = '/add-album';
  static const albumMediaList = '/albums/:albumId';
  static const transfer = '/transfer';
  static const accounts = '/accounts';
  static const preview = '/preview';
  static const metaDataDetails = '/metadata-details';
  static const mediaSelection = '/select';
}

final rootNavigatorKey = GlobalKey<NavigatorState>();

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

@TypedGoRoute<AddAlbumRoute>(path: AppRoutePath.addAlbum)
class AddAlbumRoute extends GoRouteData {
  final Album? $extra;

  const AddAlbumRoute({this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AddAlbumScreen(editAlbum: $extra);
}

@TypedGoRoute<AlbumMediaListRoute>(path: AppRoutePath.albumMediaList)
class AlbumMediaListRoute extends GoRouteData {
  final Album $extra;
  final String albumId;

  const AlbumMediaListRoute({required this.$extra, required this.albumId});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AlbumMediaListScreen(album: $extra);
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
  final String heroTag;
  final Future<List<AppMedia>> Function() onLoadMore;
  final String startFrom;

  const MediaPreviewRouteData({
    required this.medias,
    required this.startFrom,
    required this.onLoadMore,
    required this.heroTag,
  });
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
      child: MediaPreview(
        medias: $extra.medias,
        startFrom: $extra.startFrom,
        onLoadMore: $extra.onLoadMore,
        heroTag: $extra.heroTag,
      ),
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

@TypedGoRoute<MediaSelectionRoute>(path: AppRoutePath.mediaSelection)
class MediaSelectionRoute extends GoRouteData {
  final AppMediaSource $extra;

  const MediaSelectionRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MediaSelectionScreen(source: $extra);
}
