import '../flow/accounts/accounts_screen.dart';
import '../flow/media_transfer/media_transfer_screen.dart';
import '../flow/onboard/onboard_screen.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import '../flow/home/home_screen.dart';
import '../flow/media_metadata_details/media_metadata_details.dart';
import '../flow/media_preview/media_preview_screen.dart';

part 'app_router.g.dart';

part 'app_router.freezed.dart';

class AppRoutePath {
  static const home = '/';
  static const onBoard = '/on-board';
  static const accounts = '/accounts';
  static const preview = '/preview';
  static const transfer = '/transfer';
  static const metaDataDetails = '/metadata-details';
}

@TypedGoRoute<HomeRoute>(path: AppRoutePath.home)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

@TypedGoRoute<OnBoardRoute>(path: AppRoutePath.onBoard)
class OnBoardRoute extends GoRouteData {
  const OnBoardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnBoardScreen();
}

@TypedGoRoute<AccountRoute>(path: AppRoutePath.accounts)
class AccountRoute extends GoRouteData {
  const AccountRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AccountsScreen();
}

@TypedGoRoute<TransferRoute>(path: AppRoutePath.transfer)
class TransferRoute extends GoRouteData {
  const TransferRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MediaTransferScreen();
}

@freezed
class MediaPreviewRouteData with _$MediaPreviewRouteData {
  @JsonSerializable(explicitToJson: true)
  const factory MediaPreviewRouteData({
    required List<AppMedia> medias,
    required String startFrom,
  }) = _MediaPreviewRouteData;

  factory MediaPreviewRouteData.fromJson(Map<String, dynamic> json) =>
      _$MediaPreviewRouteDataFromJson(json);
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
