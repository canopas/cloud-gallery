import 'package:data/models/media/media.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_preview_view_model.freezed.dart';

final mediaPreviewStateNotifierProvider = StateNotifierProvider.family
    .autoDispose<MediaPreviewStateNotifier, MediaPreviewState,
        MediaPreviewState>(
  (ref, initial) => MediaPreviewStateNotifier(
    ref.read(localMediaServiceProvider),
    ref.read(googleDriveServiceProvider),
    initial,
  ),
);

class MediaPreviewStateNotifier extends StateNotifier<MediaPreviewState> {
  final LocalMediaService _localMediaService;
  final GoogleDriveService _googleDriveService;

  MediaPreviewStateNotifier(this._localMediaService, this._googleDriveService,
      MediaPreviewState initialState)
      : super(initialState);

  void changeVisibleMediaIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void toggleActionVisibility() {
    state = state.copyWith(showActions: !state.showActions);
  }

  Future<void> deleteMediaFromLocal(String id) async {
    try {
      await _localMediaService.deleteMedias([id]);
    } catch (error) {
      state = state.copyWith(error: error);
    }
  }

  Future<void> deleteMediaFromGoogleDrive(String? id) async {
    try {
      await _googleDriveService.deleteMedia(id!);
    } catch (error) {
      state = state.copyWith(error: error);
    }
  }


  void  updateVideoPosition(Duration position) {
    if(state.videoPosition == position) return;
    state = state.copyWith(videoPosition: position);
  }

  void updateVideoPlaying(bool isPlaying) {
    if(state.isVideoPlaying == isPlaying) return;
    state = state.copyWith(isVideoPlaying: isPlaying);
  }

  void updateVideoBuffering(bool isBuffering) {
    if(state.isVideoBuffering == isBuffering) return;
    state = state.copyWith(isVideoBuffering: isBuffering);
  }

  void updateVideoInitialized(bool isInitialized) {
    if(state.isVideoInitialized == isInitialized) return;
    state = state.copyWith(isVideoInitialized: isInitialized);
  }

  void updateVideoMaxDuration(Duration maxDuration) {
    if(state.videoMaxDuration == maxDuration) return;
    state = state.copyWith(videoMaxDuration: maxDuration);
  }
}

@freezed
class MediaPreviewState with _$MediaPreviewState {
  const factory MediaPreviewState({
    Object? error,
    @Default([]) List<AppMedia> medias,
    @Default(0) int currentIndex,
    @Default(true) bool showActions,
    @Default(false) bool isVideoInitialized,
    @Default(false) bool isVideoBuffering,
    @Default(Duration.zero) Duration videoPosition,
    @Default(Duration.zero) Duration videoMaxDuration,
    @Default(false) bool isVideoPlaying,
  }) = _MediaPreviewState;
}
