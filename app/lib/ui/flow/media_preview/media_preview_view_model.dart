import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_preview_view_model.freezed.dart';

final mediaPreviewStateNotifierProvider = StateNotifierProvider.autoDispose<
    MediaPreviewStateNotifier,
    MediaPreviewState>((ref) => MediaPreviewStateNotifier());

class MediaPreviewStateNotifier extends StateNotifier<MediaPreviewState> {
  MediaPreviewStateNotifier() : super(const MediaPreviewState());

  void changeVisibleMediaIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}

@freezed
class MediaPreviewState with _$MediaPreviewState {
  const factory MediaPreviewState({
    Object? error,
    @Default(0) int currentIndex,
  }) = _MediaPreviewState;
}
