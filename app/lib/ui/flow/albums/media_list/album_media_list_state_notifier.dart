import 'package:collection/collection.dart';
import 'package:data/errors/app_error.dart';
import 'package:data/log/logger.dart';
import 'package:data/models/album/album.dart';
import 'package:data/models/media/media.dart';
import 'package:data/services/dropbox_services.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'album_media_list_state_notifier.freezed.dart';

final albumMediaListStateNotifierProvider = StateNotifierProvider.autoDispose
    .family<AlbumMediaListStateNotifier, AlbumMediaListState, Album>(
  (ref, state) => AlbumMediaListStateNotifier(
    state,
    ref.read(localMediaServiceProvider),
    ref.read(googleDriveServiceProvider),
    ref.read(dropboxServiceProvider),
    ref.read(loggerProvider),
  ),
);

class AlbumMediaListStateNotifier extends StateNotifier<AlbumMediaListState> {
  final LocalMediaService _localMediaService;
  final GoogleDriveService _googleDriveService;
  final DropboxService _dropboxService;
  final Logger _logger;

  AlbumMediaListStateNotifier(
    Album album,
    this._localMediaService,
    this._googleDriveService,
    this._dropboxService,
    this._logger,
  ) : super(
          AlbumMediaListState(album: album),
        ) {
    loadMedia();
  }

  String? _backupFolderId;

  Future<void> loadAlbum() async {
    if (state.loading) return;

    state = state.copyWith(actionError: null);
    List<Album> albums = [];
    try {
      if (state.album.source == AppMediaSource.googleDrive) {
        _backupFolderId ??= await _googleDriveService.getBackUpFolderId();
        if (_backupFolderId == null) {
          throw BackUpFolderNotFound();
        }
        albums =
            await _googleDriveService.getAlbums(folderId: _backupFolderId!);
      } else if (state.album.source == AppMediaSource.dropbox) {
        albums = await _dropboxService.getAlbums();
      } else {
        albums = await _localMediaService.getAlbums();
      }

      state = state.copyWith(
        album: albums
                .firstWhereOrNull((element) => element.id == state.album.id) ??
            state.album,
      );
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "AlbumMediaListStateNotifier: Error loading albums",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> reloadAlbum() async {
    await loadAlbum();
    await loadMedia(reload: true);
  }

  Future<void> deleteAlbum() async {
    try {
      state = state.copyWith(actionError: null);
      if (state.album.source == AppMediaSource.local) {
        await _localMediaService.deleteAlbum(state.album.id);
      } else if (state.album.source == AppMediaSource.googleDrive) {
        _backupFolderId ??= await _googleDriveService.getBackUpFolderId();
        if (_backupFolderId == null) {
          throw BackUpFolderNotFound();
        }
        await _googleDriveService.removeAlbum(
          folderId: _backupFolderId!,
          id: state.album.id,
        );
      } else if (state.album.source == AppMediaSource.dropbox) {
        await _dropboxService.deleteAlbum(state.album.id);
      }
      state = state.copyWith(
        deleteAlbumSuccess: true,
      );
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "AlbumMediaListStateNotifier: Error deleting album",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> updateAlbumMedias({
    required List<String> medias,
    bool append = true,
  }) async {
    try {
      state = state.copyWith(actionError: null);
      if (state.album.source == AppMediaSource.local) {
        await _localMediaService.updateAlbum(
          state.album.copyWith(
            medias: append ? [...state.album.medias, ...medias] : medias,
          ),
        );
      } else if (state.album.source == AppMediaSource.googleDrive) {
        _backupFolderId ??= await _googleDriveService.getBackUpFolderId();
        if (_backupFolderId == null) {
          throw BackUpFolderNotFound();
        }
        await _googleDriveService.updateAlbum(
          folderId: _backupFolderId!,
          album: state.album.copyWith(
            medias: append ? [...state.album.medias, ...medias] : medias,
          ),
        );
      } else if (state.album.source == AppMediaSource.dropbox) {
        await _dropboxService.updateAlbum(
          state.album.copyWith(
            medias: append ? [...state.album.medias, ...medias] : medias,
          ),
        );
      }
      reloadAlbum();
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "AlbumMediaListStateNotifier: Error adding media",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> loadMedia({bool reload = false}) async {
    ///TODO: remove deleted media
    try {
      if (state.loading) return;

      if (reload) {
        state = state.copyWith(medias: []);
      }

      state = state.copyWith(loading: true, error: null, actionError: null);

      List<AppMedia> medias = [];

      if (state.album.source == AppMediaSource.local) {
        final loadedMediaIds = state.medias.map((e) => e.id).toList();
        final moreMediaIds = state.album.medias
            .where((element) => !loadedMediaIds.contains(element))
            .take(30)
            .toList();

        medias = await Future.wait(
          moreMediaIds.map(
            (id) => _localMediaService.getMedia(id: id),
          ),
        ).then(
          (value) => value.nonNulls.toList(),
        );
      } else if (state.album.source == AppMediaSource.googleDrive) {
        final loadedMediaIds =
            state.medias.map((e) => e.driveMediaRefId).nonNulls.toList();
        final moreMediaIds = state.album.medias
            .where((element) => !loadedMediaIds.contains(element))
            .take(30)
            .toList();
        medias = await Future.wait(
          moreMediaIds.map(
            (id) => _googleDriveService.getMedia(id: id),
          ),
        ).then(
          (value) => value.nonNulls.toList(),
        );
      } else if (state.album.source == AppMediaSource.dropbox) {
        final loadedMediaIds =
            state.medias.map((e) => e.dropboxMediaRefId).nonNulls.toList();
        final moreMediaIds = state.album.medias
            .where((element) => !loadedMediaIds.contains(element))
            .take(30)
            .toList();
        medias = await Future.wait(
          moreMediaIds.map(
            (id) => _dropboxService.getMedia(id: id),
          ),
        ).then(
          (value) => value.nonNulls.toList(),
        );
      }

      state =
          state.copyWith(medias: [...state.medias, ...medias], loading: false);
    } catch (e, s) {
      state = state.copyWith(
        loading: false,
        error: state.medias.isEmpty ? e : null,
        actionError: state.medias.isNotEmpty ? e : null,
      );
      _logger.e(
        "AlbumMediaListStateNotifier: Error loading medias",
        error: e,
        stackTrace: s,
      );
    }
  }
}

@freezed
class AlbumMediaListState with _$AlbumMediaListState {
  const factory AlbumMediaListState({
    @Default([]) List<AppMedia> medias,
    required Album album,
    @Default(false) bool loading,
    @Default(false) bool deleteAlbumSuccess,
    Object? error,
    Object? actionError,
  }) = _AlbumMediaListState;
}
