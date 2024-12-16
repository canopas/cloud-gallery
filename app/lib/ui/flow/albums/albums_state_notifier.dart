import 'package:data/log/logger.dart';
import 'package:data/services/dropbox_services.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'albums_state_notifier.freezed.dart';

final albumsStateNotifierProvider =
    StateNotifierProvider.autoDispose<AlbumsStateNotifier, AlbumsState>(
  (ref) => AlbumsStateNotifier(
    ref.read(dropboxServiceProvider),
    ref.read(googleDriveServiceProvider),
    ref.read(loggerProvider),
  ),
);

class AlbumsStateNotifier extends StateNotifier<AlbumsState> {
  final DropboxService _dropboxService;
  final GoogleDriveService _googleDriveService;
  final Logger _logger;

  AlbumsStateNotifier(
    this._dropboxService,
    this._googleDriveService,
    this._logger,
  ) : super(const AlbumsState());

  void loadAlbums() {
    try {
      state = state.copyWith(loading: true);


    } catch (e, s) {
      _logger.e(
        "AlbumsStateNotifier: AError loading albums",
        error: e,
        stackTrace: s,
      );
      state = state.copyWith(loading: false, error: e);
    }
  }
}

@freezed
class AlbumsState with _$AlbumsState {
  const factory AlbumsState({
    @Default(false) bool loading,
    Object? error,
  }) = _AlbumsState;
}
