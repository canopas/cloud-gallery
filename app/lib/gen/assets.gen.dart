/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app_logo.png
  AssetGenImage get appLogo =>
      const AssetGenImage('assets/images/app_logo.png');

  /// File path: assets/images/ic_download.svg
  String get icDownload => 'assets/images/ic_download.svg';

  /// File path: assets/images/ic_dropbox.svg
  String get icDropbox => 'assets/images/ic_dropbox.svg';

  /// File path: assets/images/ic_error.svg
  String get icError => 'assets/images/ic_error.svg';

  /// File path: assets/images/ic_google_drive.svg
  String get icGoogleDrive => 'assets/images/ic_google_drive.svg';

  /// File path: assets/images/ic_logout.svg
  String get icLogout => 'assets/images/ic_logout.svg';

  /// File path: assets/images/ic_no_internet.svg
  String get icNoInternet => 'assets/images/ic_no_internet.svg';

  /// File path: assets/images/ic_notification.svg
  String get icNotification => 'assets/images/ic_notification.svg';

  /// File path: assets/images/ic_privacy_policy.svg
  String get icPrivacyPolicy => 'assets/images/ic_privacy_policy.svg';

  /// File path: assets/images/ic_rate_us.svg
  String get icRateUs => 'assets/images/ic_rate_us.svg';

  /// File path: assets/images/ic_term_of_service.svg
  String get icTermOfService => 'assets/images/ic_term_of_service.svg';

  /// File path: assets/images/ic_upload.svg
  String get icUpload => 'assets/images/ic_upload.svg';

  /// List of all assets
  List<dynamic> get values => [
        appLogo,
        icDownload,
        icDropbox,
        icError,
        icGoogleDrive,
        icLogout,
        icNoInternet,
        icNotification,
        icPrivacyPolicy,
        icRateUs,
        icTermOfService,
        icUpload
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
