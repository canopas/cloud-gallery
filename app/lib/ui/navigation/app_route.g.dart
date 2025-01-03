// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $onBoardRoute,
      $mainShellRoute,
      $mediaPreviewRoute,
      $mediaMetadataDetailsRoute,
      $mediaSelectionRoute,
    ];

RouteBase get $onBoardRoute => GoRouteData.$route(
      path: '/on-board',
      factory: $OnBoardRouteExtension._fromState,
    );

extension $OnBoardRouteExtension on OnBoardRoute {
  static OnBoardRoute _fromState(GoRouterState state) => const OnBoardRoute();

  String get location => GoRouteData.$location(
        '/on-board',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mainShellRoute => StatefulShellRouteData.$route(
      factory: $MainShellRouteExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/',
              factory: $HomeRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/albums',
              factory: $AlbumsRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'add',
                  parentNavigatorKey: AddAlbumRoute.$parentNavigatorKey,
                  factory: $AddAlbumRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'media-list',
                  parentNavigatorKey: AlbumMediaListRoute.$parentNavigatorKey,
                  factory: $AlbumMediaListRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/transfer',
              factory: $TransferRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/accounts',
              factory: $AccountRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $MainShellRouteExtension on MainShellRoute {
  static MainShellRoute _fromState(GoRouterState state) =>
      const MainShellRoute();
}

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AlbumsRouteExtension on AlbumsRoute {
  static AlbumsRoute _fromState(GoRouterState state) => const AlbumsRoute();

  String get location => GoRouteData.$location(
        '/albums',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AddAlbumRouteExtension on AddAlbumRoute {
  static AddAlbumRoute _fromState(GoRouterState state) => AddAlbumRoute(
        $extra: state.extra as Album?,
      );

  String get location => GoRouteData.$location(
        '/albums/add',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $AlbumMediaListRouteExtension on AlbumMediaListRoute {
  static AlbumMediaListRoute _fromState(GoRouterState state) =>
      AlbumMediaListRoute(
        $extra: state.extra as Album,
      );

  String get location => GoRouteData.$location(
        '/albums/media-list',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $TransferRouteExtension on TransferRoute {
  static TransferRoute _fromState(GoRouterState state) => const TransferRoute();

  String get location => GoRouteData.$location(
        '/transfer',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AccountRouteExtension on AccountRoute {
  static AccountRoute _fromState(GoRouterState state) => const AccountRoute();

  String get location => GoRouteData.$location(
        '/accounts',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mediaPreviewRoute => GoRouteData.$route(
      path: '/preview',
      factory: $MediaPreviewRouteExtension._fromState,
    );

extension $MediaPreviewRouteExtension on MediaPreviewRoute {
  static MediaPreviewRoute _fromState(GoRouterState state) => MediaPreviewRoute(
        $extra: state.extra as MediaPreviewRouteData,
      );

  String get location => GoRouteData.$location(
        '/preview',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $mediaMetadataDetailsRoute => GoRouteData.$route(
      path: '/metadata-details',
      factory: $MediaMetadataDetailsRouteExtension._fromState,
    );

extension $MediaMetadataDetailsRouteExtension on MediaMetadataDetailsRoute {
  static MediaMetadataDetailsRoute _fromState(GoRouterState state) =>
      MediaMetadataDetailsRoute(
        $extra: state.extra as AppMedia,
      );

  String get location => GoRouteData.$location(
        '/metadata-details',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $mediaSelectionRoute => GoRouteData.$route(
      path: '/select',
      factory: $MediaSelectionRouteExtension._fromState,
    );

extension $MediaSelectionRouteExtension on MediaSelectionRoute {
  static MediaSelectionRoute _fromState(GoRouterState state) =>
      MediaSelectionRoute(
        $extra: state.extra as AppMediaSource,
      );

  String get location => GoRouteData.$location(
        '/select',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}
