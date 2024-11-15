// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
      $onBoardRoute,
      $accountRoute,
      $transferRoute,
      $mediaPreviewRoute,
      $mediaMetadataDetailsRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/',
      factory: $HomeRouteExtension._fromState,
    );

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

RouteBase get $accountRoute => GoRouteData.$route(
      path: '/accounts',
      factory: $AccountRouteExtension._fromState,
    );

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

RouteBase get $transferRoute => GoRouteData.$route(
      path: '/transfer',
      factory: $TransferRouteExtension._fromState,
    );

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
