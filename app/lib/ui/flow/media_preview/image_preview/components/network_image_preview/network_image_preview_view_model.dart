import 'package:data/models/media_content/media_content.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_image_preview_view_model.freezed.dart';

final networkImagePreviewStateNotifierProvider = StateNotifierProvider<
    NetworkImagePreviewStateNotifier, NetworkImagePreviewState>((ref) {
  return NetworkImagePreviewStateNotifier(ref.read(googleDriveServiceProvider));
});

class NetworkImagePreviewStateNotifier
    extends StateNotifier<NetworkImagePreviewState> {
  final GoogleDriveService _googleDriveServices;

  NetworkImagePreviewStateNotifier(this._googleDriveServices)
      : super(const NetworkImagePreviewState());

  Future<void> loadImage(String mediaId) async {
    try {
      state = state.copyWith(loading: true, error: null);
      final mediaContent = await _googleDriveServices.fetchMediaBytes(mediaId);
      final mediaByte = <int>[];
      await for (var mediaBytes in mediaContent.stream) {
        mediaByte.addAll(mediaBytes);
      }
      state = state.copyWith(
          mediaContent: mediaContent, mediaBytes: mediaByte, loading: false);
    } catch (error) {
      state = state.copyWith(error: error, loading: false);
    }
  }
}

@freezed
class NetworkImagePreviewState with _$NetworkImagePreviewState {
  const factory NetworkImagePreviewState({
    @Default(false) bool loading,
    AppMediaContent? mediaContent,
    List<int>? mediaBytes,
    Object? error,
  }) = _NetworkImagePreviewState;
}
