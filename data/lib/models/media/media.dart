import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:googleapis/drive/v3.dart' as drive show File;
import 'package:photo_manager/photo_manager.dart' show AssetEntity;

part 'media.freezed.dart';

part 'media.g.dart';

enum UploadStatus { uploading, waiting, none, failed, success }

class UploadProgress {
  final String mediaId;
  final UploadStatus status;

  UploadProgress({required this.mediaId, required this.status});

  @override
  bool operator ==(Object other) {
    return other is UploadProgress &&
        other.mediaId == mediaId &&
        other.status == status;
  }

  @override
  int get hashCode => mediaId.hashCode ^ status.hashCode;
}

enum AppMediaType {
  image,
  video,
  other;

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

enum AppMediaOrientation {
  landscape,
  portrait;

  bool get isLandscape => this == AppMediaOrientation.landscape;

  bool get isPortrait => this == AppMediaOrientation.portrait;
}

enum AppMediaSource {
  local,
  googleDrive,
}

@freezed
class AppMedia with _$AppMedia {
  const factory AppMedia({
    required String id,
    String? name,
    required String path,
    String? thumbnailLink,
    double? displayHeight,
    double? displayWidth,
    required AppMediaType type,
    String? mimeType,
    DateTime? createdTime,
    DateTime? modifiedTime,
    AppMediaOrientation? orientation,
    String? size,
    Duration? videoDuration,
    double? latitude,
    double? longitude,
    @Default([AppMediaSource.local]) List<AppMediaSource> sources,
  }) = _AppMedia;

  factory AppMedia.fromJson(Map<String, dynamic> json) =>
      _$AppMediaFromJson(json);

  factory AppMedia.fromGoogleDriveFile(drive.File file) {
    final type = AppMediaType.getType(
        mimeType: file.mimeType,
        location: file.description ?? '');

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
                    int.parse(file.videoMediaMetadata?.durationMillis ?? '0'))
            : null;
    return AppMedia(
      id: file.id!,
      path: file.description ?? file.thumbnailLink ?? '',
      thumbnailLink: file.thumbnailLink,
      name: file.name,
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
}

extension AppMediaExtension on AppMedia {
  Future<bool> get isExist async {
    return await File(path).exists();
  }
}
