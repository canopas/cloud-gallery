import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_preview_view_model.freezed.dart';

final mediaPreviewStateNotifierProvider = StateNotifierProvider.family.autoDispose<
    MediaPreviewStateNotifier,
    MediaPreviewState, MediaPreviewState>((ref, initial) => MediaPreviewStateNotifier(initial));

class MediaPreviewStateNotifier extends StateNotifier<MediaPreviewState> {
  MediaPreviewStateNotifier(MediaPreviewState initialState) : super(initialState);

  void changeVisibleMediaIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void toggleManu() {
    state = state.copyWith(showManu: !state.showManu);
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
