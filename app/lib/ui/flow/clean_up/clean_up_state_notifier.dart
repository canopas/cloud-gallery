import 'package:data/log/logger.dart';
import 'package:data/models/media/media.dart';
import 'package:data/services/local_media_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'clean_up_state_notifier.freezed.dart';

final cleanUpStateNotifierProvider =
    StateNotifierProvider.autoDispose<CleanUpStateNotifier, CleanUpState>(
        (ref) {
  return CleanUpStateNotifier(
    ref.read(localMediaServiceProvider),
    ref.read(loggerProvider),
  );
});

class CleanUpStateNotifier extends StateNotifier<CleanUpState> {
  final LocalMediaService _localMediaService;
  final Logger _logger;

  CleanUpStateNotifier(
    this._localMediaService,
    this._logger,
  ) : super(const CleanUpState()) {
    loadCleanUpMedias();
  }

  Future<void> loadCleanUpMedias() async {
    try {
      state = state.copyWith(loading: true, error: null);
      final cleanUpMedias = await _localMediaService.getCleanUpMedias();

      final medias = await Future.wait(
        cleanUpMedias.map(
          (e) => _localMediaService.getMedia(id: e.id),
        ),
      ).then(
        (value) => value.nonNulls.toList(),
      );

      state = state.copyWith(loading: false, medias: medias);
    } catch (e, s) {
      state = state.copyWith(loading: false, error: e);
      _logger.e(
        "CleanUpStateNotifier: Error occur while loading bin items",
        error: e,
        stackTrace: s,
      );
    }
  }

  void toggleSelection(String id) {
    final selected = state.selected.toList();
    if (selected.contains(id)) {
      state = state.copyWith(selected: selected..remove(id));
    } else {
      state = state.copyWith(selected: [...selected, id]);
    }
  }

  Future<void> deleteSelected() async {
    try {
      final deleteMedias = state.selected;
      state = state.copyWith(
        deleteSelectedLoading: deleteMedias,
        selected: [],
        actionError: null,
      );
      final res = await _localMediaService.deleteMedias(deleteMedias);
      if (res.isNotEmpty) {
        await _localMediaService.removeFromCleanUpMediaDatabase(res);
      }
      state = state.copyWith(
        deleteSelectedLoading: [],
        medias: state.medias.where((e) => !res.contains(e.id)).toList(),
      );
    } catch (e, s) {
      state = state.copyWith(deleteSelectedLoading: [], actionError: e);
      _logger.e(
        "CleanUpStateNotifier: Error occur while deleting selected bin items",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> deleteAll() async {
    try {
      state = state.copyWith(deleteAllLoading: true, actionError: null);
      final res = await _localMediaService
          .deleteMedias(state.medias.map((e) => e.id).toList());

      if (res.isNotEmpty) {
        await _localMediaService.clearCleanUpMediaDatabase();
      }
      state = state.copyWith(
        deleteAllLoading: false,
        selected: [],
        medias: res.isNotEmpty ? [] : state.medias,
      );
    } catch (e, s) {
      state = state.copyWith(deleteAllLoading: false, actionError: e);
      _logger.e(
        "CleanUpStateNotifier: Error occur while deleting all bin items",
        error: e,
        stackTrace: s,
      );
    }
  }
}

@freezed
class CleanUpState with _$CleanUpState {
  const factory CleanUpState({
    @Default(false) bool deleteAllLoading,
    @Default([]) List<String> deleteSelectedLoading,
    @Default([]) List<AppMedia> medias,
    @Default([]) List<String> selected,
    @Default(false) bool loading,
    Object? error,
    Object? actionError,
  }) = _CleanUpState;
}
