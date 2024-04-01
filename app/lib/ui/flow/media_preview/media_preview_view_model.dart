import 'package:data/models/media/media.dart';
import 'package:data/services/local_media_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_preview_view_model.freezed.dart';

final mediaPreviewStateNotifierProvider = StateNotifierProvider.family
    .autoDispose<MediaPreviewStateNotifier, MediaPreviewState,
        MediaPreviewState>(
  (ref, initial) => MediaPreviewStateNotifier(
    ref.read(localMediaServiceProvider),
    initial,
  ),
);

class MediaPreviewStateNotifier extends StateNotifier<MediaPreviewState> {
  final LocalMediaService _localMediaService;

  MediaPreviewStateNotifier(
      this._localMediaService, MediaPreviewState initialState)
      : super(initialState);

  void changeVisibleMediaIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void toggleManu() {
    state = state.copyWith(showManu: !state.showManu);
  }

  Future<void> deleteMedia(AppMedia appMedia) async {
   await _localMediaService.deleteMedias([appMedia.id]);
  }
}

@freezed
class MediaPreviewState with _$MediaPreviewState {
  const factory MediaPreviewState({
    Object? error,
    @Default(0) int currentIndex,
    @Default(true) bool showManu,
  }) = _MediaPreviewState;
}
