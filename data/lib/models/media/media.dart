import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:googleapis/drive/v3.dart' as drive show File;
import 'package:photo_manager/photo_manager.dart' show AssetEntity;

import '../../domain/config.dart';
import '../../domain/json_converters/date_time_json_converter.dart';
import '../../domain/json_converters/duration_json_converter.dart';

part 'media.freezed.dart';

part 'media.g.dart';

@JsonEnum(valueField: 'value')
enum AppMediaType {
  other('other'),
  image('image'),
  video('video');

  final String value;

  const AppMediaType(this.value);

  bool get isImage => this == AppMediaType.image;

  bool get isVideo => this == AppMediaType.video;

  factory AppMediaType.getType({String? mimeType, required String? location}) {
    if (mimeType != null) {
      return AppMediaType.fromMimeType(mimeType: mimeType);
    } else if (location != null) {
      return AppMediaType.fromLocation(location: location);
    } else {
      return AppMediaType.other;
    }
  }

  factory AppMediaType.fromLocation({required String location}) {
    location = location.toLowerCase();
    if (location.endsWith('.jpg') ||
        location.endsWith('.jpeg') ||
        location.endsWith('.png') ||
        location.endsWith('.gif') ||
        location.endsWith('.heic') ||
        location.endsWith('.webp')) {
      return AppMediaType.image;
    } else if (location.endsWith('.mp4') ||
        location.endsWith('.3gp') ||
        location.endsWith('.mkv') ||
        location.endsWith('.avi') ||
        location.endsWith('.mov') ||
        location.endsWith('.wmv') ||
        location.endsWith('.flv') ||
        location.endsWith('.webm')) {
      return AppMediaType.video;
    }
    return AppMediaType.other;
  }

  factory AppMediaType.fromMimeType({required String mimeType}) {
    if (mimeType.startsWith('image')) {
      return AppMediaType.image;
    } else if (mimeType.startsWith('video')) {
      return AppMediaType.video;
    }
    return AppMediaType.other;
  }
}

@JsonEnum(valueField: 'value')
enum AppMediaOrientation {
  landscape("landscape"),
  portrait('portrait');

  final String value;

  const AppMediaOrientation(this.value);

  bool get isLandscape => this == AppMediaOrientation.landscape;

  bool get isPortrait => this == AppMediaOrientation.portrait;
}

@JsonEnum(valueField: 'value')
enum AppMediaSource {
  local('local'),
  googleDrive('google_drive'),
  dropbox('dropbox');

  final String value;

  const AppMediaSource(this.value);
}

@freezed
class AppMedia with _$AppMedia {
  const AppMedia._();

  const factory AppMedia({
    required String id,
    String? driveMediaRefId,
    String? dropboxMediaRefId,
    String? name,
    required String path,
    String? thumbnailLink,
    double? displayHeight,
    double? displayWidth,
    required AppMediaType type,
    String? mimeType,
    @DateTimeJsonConverter() DateTime? createdTime,
    @DateTimeJsonConverter() DateTime? modifiedTime,
    AppMediaOrientation? orientation,
    String? size,
    @DurationJsonConverter() Duration? videoDuration,
    double? latitude,
    double? longitude,
    @Default([AppMediaSource.local]) List<AppMediaSource> sources,
  }) = _AppMedia;

  factory AppMedia.fromJson(Map<String, dynamic> json) =>
      _$AppMediaFromJson(json);

  factory AppMedia.fromGoogleDriveFile(drive.File file) {
    final type = AppMediaType.getType(
      mimeType: file.mimeType,
      location: file.description ?? '',
    );

    final height = type.isImage
        ? file.imageMediaMetadata?.height?.toDouble()
        : file.videoMediaMetadata?.height?.toDouble();

    final width = type.isImage
        ? file.imageMediaMetadata?.width?.toDouble()
        : file.videoMediaMetadata?.width?.toDouble();

    final orientation = height != null && width != null
        ? height > width
            ? AppMediaOrientation.portrait
            : AppMediaOrientation.landscape
        : null;

    final videoDuration =
        type.isVideo && file.videoMediaMetadata?.durationMillis != null
            ? Duration(
                milliseconds:
                    int.parse(file.videoMediaMetadata?.durationMillis ?? '0'),
              )
            : null;

    return AppMedia(
      id: file.appProperties?[ProviderConstants.localRefIdKey] ?? file.id!,
      path: file.description ?? '',
      thumbnailLink: file.thumbnailLink,
      name: file.name,
      driveMediaRefId: file.id,
      createdTime: file.createdTime,
      modifiedTime: file.modifiedTime,
      mimeType: file.mimeType,
      size: file.size,
      type: type,
      displayHeight: height,
      displayWidth: width,
      videoDuration: videoDuration,
      orientation: orientation,
      latitude: file.imageMediaMetadata?.location?.latitude,
      longitude: file.imageMediaMetadata?.location?.longitude,
      sources: [AppMediaSource.googleDrive],
    );
  }

  static Future<AppMedia?> fromAssetEntity(AssetEntity asset) async {
    final file = await asset.originFile;

    if (file == null) return null;

    final type =
        AppMediaType.getType(mimeType: asset.mimeType, location: file.path);
    final length = await file.length();
    return AppMedia(
      id: asset.id,
      path: file.path,
      name: asset.title,
      mimeType: asset.mimeType,
      size: length.toString(),
      type: type,
      createdTime: asset.createDateTime,
      latitude: asset.latitude,
      longitude: asset.longitude,
      videoDuration: type.isVideo ? asset.videoDuration : null,
      sources: [AppMediaSource.local],
      orientation: asset.orientation == 90 || asset.orientation == 270
          ? AppMediaOrientation.landscape
          : AppMediaOrientation.portrait,
      modifiedTime: asset.modifiedDateTime,
      displayHeight: asset.size.height,
      displayWidth: asset.size.width,
    );
  }

  static AppMedia fromDropboxJson(Map<String, dynamic> json) {
    final id =
        json['property_groups'] != null && json['property_groups'].isNotEmpty
            ? json['property_groups'][0]['fields'][0]['value']
            : null;

    return AppMedia(
      id: id ?? json['id'],
      path: json['path_display'],
      name: json['name'],
      size: json['size'].toString(),
      dropboxMediaRefId: json['id'],
      createdTime: DateTime.parse(json['client_modified']),
      type: AppMediaType.getType(location: json['path_display']),
      sources: [AppMediaSource.dropbox],
    );
  }
}
