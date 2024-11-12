import 'dart:async';
import 'dart:io';
import 'package:data/services/google_drive_service.dart';
import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'network_image_preview_view_model.freezed.dart';

final networkImagePreviewStateNotifierProvider =
    StateNotifierProvider.autoDispose<NetworkImagePreviewStateNotifier,
        NetworkImagePreviewState>((ref) {
  return NetworkImagePreviewStateNotifier(ref.read(googleDriveServiceProvider));
});

class NetworkImagePreviewStateNotifier
    extends StateNotifier<NetworkImagePreviewState> {
  final GoogleDriveService _googleDriveServices;

  NetworkImagePreviewStateNotifier(this._googleDriveServices)
      : super(const NetworkImagePreviewState());

  File? tempFile;
  CancelToken? cancelToken;

  Future<void> loadImageFromGoogleDrive(
      {required String id, required String extension}) async {
    try {
      state = state.copyWith(loading: true, error: null);
      cancelToken = CancelToken();
      final dir = await getTemporaryDirectory();
      tempFile = File('${dir.path}/$id.$extension');
      await _googleDriveServices.downloadFromGoogleDrive(
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
  void dispose() {
    tempFile?.deleteSync();
    cancelToken?.cancel();
    super.dispose();
  }
}

@freezed
class NetworkImagePreviewState with _$NetworkImagePreviewState {
  const factory NetworkImagePreviewState({
    @Default(false) bool loading,
    double? progress,
    String? filePath,
    Object? error,
  }) = _NetworkImagePreviewState;
}
