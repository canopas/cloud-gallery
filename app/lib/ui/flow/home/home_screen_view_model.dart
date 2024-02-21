import 'package:data/models/media/media.dart';
import 'package:data/services/local_media_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_screen_view_model.freezed.dart';

final homeViewStateNotifier =
    StateNotifierProvider.autoDispose<HomeViewStateNotifier, HomeViewState>(
  (ref) => HomeViewStateNotifier(
    ref.read(localMediaServiceProvider),
  ),
);

class HomeViewStateNotifier extends StateNotifier<HomeViewState> {
  final LocalMediaService _localMediaService;

  bool _loading = false;

  HomeViewStateNotifier(this._localMediaService)
      : super(const HomeViewState());

  Future<void> loadMediaCount() async {
    try {
      final count = await _localMediaService.getMediaCount();
      state = state.copyWith(mediaCount: count);
    } catch (error) {
      state = state.copyWith(error: error);
    }
  }

  Future<void> loadMedia({bool append = false}) async {
    if (_loading == true) return;
    _loading = true;
    try {
      state = state.copyWith(loading: state.medias.isEmpty);
      final medias = await _localMediaService.getMedia(
        start: append ? state.medias.length : 0,
        end: append
            ? state.medias.length + 20
            : state.medias.length < 20
                ? 20
                : state.medias.length,
      );
      state = state.copyWith(
        medias: [...state.medias, ...medias],
        loading: false,
      );
    } catch (error) {
      state = state.copyWith(error: error, loading: false);
    }
    _loading = false;
  }

  void mediaSelection(AppMedia media) {
    final selectedMedias = state.selectedMedias;
    if (selectedMedias.contains(media)) {
      state = state.copyWith(
        selectedMedias: selectedMedias.toList()..remove(media),
      );
    } else {
      state = state.copyWith(
        selectedMedias: [...selectedMedias, media],
      );
    }
  }

  void clearMediaSelection() {
    state = state.copyWith(selectedMedias: []);
  }

  Future<void> uploadMediaOnGoogleDrive() async {

  }
}

@freezed
class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    @Default(false) bool loading,
    @Default([]) List<AppMedia> medias,
    @Default([]) List<AppMedia> selectedMedias,
    @Default(0) int mediaCount,
    Object? error,
  }) = _HomeViewState;
}
