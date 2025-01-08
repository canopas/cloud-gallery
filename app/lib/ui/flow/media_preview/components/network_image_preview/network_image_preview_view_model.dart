import 'dart:async';
import 'dart:io';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:data/services/dropbox_services.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'network_image_preview_view_model.freezed.dart';

final networkImagePreviewStateNotifierProvider = StateNotifierProvider.family
    .autoDispose<NetworkImagePreviewStateNotifier, NetworkImagePreviewState,
        AppMedia>((ref, media) {
  return NetworkImagePreviewStateNotifier(
    ref.read(googleDriveServiceProvider),
    ref.read(dropboxServiceProvider),
    media,
  );
});

class NetworkImagePreviewStateNotifier
    extends StateNotifier<NetworkImagePreviewState> {
  final GoogleDriveService _googleDriveServices;
  final DropboxService _dropboxService;

  NetworkImagePreviewStateNotifier(
    this._googleDriveServices,
    this._dropboxService,
    AppMedia media,
  ) : super(NetworkImagePreviewState(media: media)) {
    if (media.driveMediaRefId != null) {
      loadImageFromGoogleDrive(
        id: media.driveMediaRefId!,
        extension: media.extension,
      );
    } else if (media.dropboxMediaRefId != null) {
      loadImageFromDropbox(
        id: media.dropboxMediaRefId!,
        extension: media.extension,
      );
    }
  }

  File? tempFile;
  CancelToken? cancelToken;

  Future<void> loadImageFromGoogleDrive({
    required String id,
    required String extension,
  }) async {
    try {
      state = state.copyWith(loading: true, error: null);
      cancelToken = CancelToken();
      final dir = await getApplicationDocumentsDirectory();
      tempFile = File('${dir.path}/network_image_$id.$extension');
      await _googleDriveServices.downloadMedia(
        id: id,
        saveLocation: tempFile!.path,
        cancelToken: cancelToken,
        onProgress: (progress, total) {
          state = state.copyWith(progress: total <= 0 ? 0 : progress / total);
        },
      );
      state = state.copyWith(
        loading: false,
        filePath: tempFile?.path,
      );
    } catch (error) {
      state = state.copyWith(
        error: error,
        loading: false,
      );
    }
  }

  Future<void> loadImageFromDropbox({
    required String id,
    required String extension,
  }) async {
    try {
      state = state.copyWith(loading: true, error: null);
      cancelToken = CancelToken();
      final dir = await getApplicationCacheDirectory();
      tempFile = File('${dir.path}/network_image_$id.$extension');
      await _dropboxService.downloadMedia(
        id: id,
        saveLocation: tempFile!.path,
        cancelToken: cancelToken,
        onProgress: (progress, total) {
          state = state.copyWith(progress: total <= 0 ? 0 : progress / total);
        },
      );
      state = state.copyWith(
        loading: false,
        filePath: tempFile?.path,
      );
    } catch (error) {
      state = state.copyWith(
        error: error,
        loading: false,
      );
    }
  }

  @override
  Future<void> dispose() async {
    if (tempFile != null && await tempFile!.exists()) {
      await tempFile!.delete();
    }
    cancelToken?.cancel();
    super.dispose();
  }
}

@freezed
class NetworkImagePreviewState with _$NetworkImagePreviewState {
  const factory NetworkImagePreviewState({
    required AppMedia media,
    @Default(false) bool loading,
    double? progress,
    String? filePath,
    Object? error,
  }) = _NetworkImagePreviewState;
}
