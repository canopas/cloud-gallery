import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'media.dart';

extension AppMediaExtension on AppMedia {
  Future<Uint8List?> loadThumbnail({Size size = const Size(300, 300)}) async {
    final rootToken = RootIsolateToken.instance!;
    final ThumbNailParameter thumbNailParameter =
        ThumbNailParameter(rootToken, size, id, type);
    final bytes = await compute(_loadThumbnailInBackground, thumbNailParameter);
    return bytes;
  }

  FutureOr<Uint8List?> _loadThumbnailInBackground(
    ThumbNailParameter parameters,
  ) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(parameters.token);
    return await AssetEntity(
      id: parameters.id,
      typeInt: parameters.type.index,
      width: 0,
      height: 0,
    ).thumbnailDataWithSize(
      ThumbnailSize(
        parameters.size.width.toInt(),
        parameters.size.height.toInt(),
      ),
      format: ThumbnailFormat.png,
      quality: 70,
    );
  }

  AppMedia mergeGoogleDriveMedia(AppMedia media) {
    return copyWith(
      mimeType: mimeType ?? media.mimeType,
      longitude: longitude ?? media.longitude,
      latitude: latitude ?? media.latitude,
      orientation: orientation ?? media.orientation,
      videoDuration: videoDuration ?? media.videoDuration,
      displayWidth: displayWidth ?? media.displayWidth,
      displayHeight: displayHeight ?? media.displayHeight,
      size: size ?? media.size,
      modifiedTime: modifiedTime ?? media.modifiedTime,
      createdTime: createdTime ?? media.createdTime,
      name: name ?? media.name,
      thumbnailLink: media.thumbnailLink,
      driveMediaRefId: media.driveMediaRefId,
      sources: sources.toList()..add(AppMediaSource.googleDrive),
    );
  }

  AppMedia removeGoogleDriveRef() {
    return copyWith(
      thumbnailLink: null,
      driveMediaRefId: null,
      sources: sources.toList()..remove(AppMediaSource.googleDrive),
    );
  }

  AppMedia mergeDropboxMedia(AppMedia media) {
    return copyWith(
      mimeType: mimeType ?? media.mimeType,
      longitude: longitude ?? media.longitude,
      latitude: latitude ?? media.latitude,
      orientation: orientation ?? media.orientation,
      videoDuration: videoDuration ?? media.videoDuration,
      displayWidth: displayWidth ?? media.displayWidth,
      displayHeight: displayHeight ?? media.displayHeight,
      size: size ?? media.size,
      modifiedTime: modifiedTime ?? media.modifiedTime,
      createdTime: createdTime ?? media.createdTime,
      name: name ?? media.name,
      dropboxMediaRefId: media.dropboxMediaRefId,
      sources: sources.toList()..add(AppMediaSource.dropbox),
    );
  }

  AppMedia removeDropboxRef() {
    return copyWith(
      dropboxMediaRefId: null,
      sources: sources.toList()..remove(AppMediaSource.dropbox),
    );
  }

  AppMedia removeLocalRef() {
    return copyWith(
      id: driveMediaRefId ?? dropboxMediaRefId ?? '',
      sources: sources.toList()..remove(AppMediaSource.local),
    );
  }

  bool get isGoogleDriveStored =>
      sources.contains(AppMediaSource.googleDrive) && sources.length == 1;

  bool get isLocalStored =>
      sources.contains(AppMediaSource.local) && sources.length == 1;

  bool get isDropboxStored =>
      sources.contains(AppMediaSource.dropbox) && sources.length == 1;

  bool get isCommonStored => sources.length > 1;

  String get extension {
    if (mimeType?.trim().isNotEmpty ?? false) return mimeType!.split('/').last;
    if (type.isVideo) return 'mp4';
    if (type.isImage) return 'jpg';
    return '';
  }

  AssetEntity get assetEntity => AssetEntity(
        id: id,
        typeInt: type.index,
        width: displayWidth?.toInt() ?? 0,
        height: displayHeight?.toInt() ?? 0,
        createDateSecond: createdTime?.millisecondsSinceEpoch,
        title: name,
        latitude: latitude,
        longitude: longitude,
        mimeType: mimeType,
        modifiedDateSecond: modifiedTime?.millisecondsSinceEpoch,
      );
}

class ThumbNailParameter {
  final RootIsolateToken token;
  final Size size;
  final String id;
  final AppMediaType type;

  ThumbNailParameter(this.token, this.size, this.id, this.type);
}
