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

  int _loadedMediaCount = 0;
  String? _backupFolderId;

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

  Future<List<AppMedia>> loadMedia({bool reload = false}) async {
    ///TODO: remove media-ids which is deleted from source
    try {
      if (state.loading || state.loadingMore) state.medias;

      state = state.copyWith(
        loading: state.medias.isEmpty,
        loadingMore: state.medias.isNotEmpty && !reload,
        error: null,
        actionError: null,
      );

      final moreMediaIds = state.album.medias
          .sublist(
            (reload ? 0 : _loadedMediaCount),
          )
          .take(_loadedMediaCount + (reload ? _loadedMediaCount : 30))
          .toList();

      Map<String, AppMedia> medias = {};

      if (state.album.source == AppMediaSource.local) {
        final res = await Future.wait(
          moreMediaIds.map((id) => _localMediaService.getMedia(id: id)),
        ).then((value) => value.nonNulls.toList());
        medias = {for (final item in res) item.id: item};
      } else if (state.album.source == AppMediaSource.googleDrive) {
        final res = await Future.wait(
          moreMediaIds.map((id) => _googleDriveService.getMedia(id: id)),
        ).then((value) => value.nonNulls.toList());
        medias = {for (final item in res) item.driveMediaRefId!: item};
      } else if (state.album.source == AppMediaSource.dropbox) {
        final res = await Future.wait(
          moreMediaIds.map((id) => _dropboxService.getMedia(id: id)),
        ).then((value) => value.nonNulls.toList());
        medias = {for (final item in res) item.dropboxMediaRefId!: item};
      }

      state = state.copyWith(
        medias: reload ? medias : {...state.medias, ...medias},
        loading: false,
        loadingMore: false,
      );

      _loadedMediaCount = reload
          ? moreMediaIds.length
          : _loadedMediaCount + moreMediaIds.length;

      // remove media-ids from album which is deleted from source
      final manuallyRemovedMedia = moreMediaIds
          .where(
            (element) => !medias.keys.contains(element),
          )
          .toList();

      if (manuallyRemovedMedia.isNotEmpty) {
        updateAlbumMedias(
          medias: state.album.medias
              .where(
                (element) => !manuallyRemovedMedia.contains(element),
              )
              .toList(),
          append: false,
        );
      }
    } catch (e, s) {
      state = state.copyWith(
        loading: false,
        loadingMore: false,
        error: state.medias.isEmpty ? e : null,
        actionError: state.medias.isNotEmpty ? e : null,
      );
      _logger.e(
        "AlbumMediaListStateNotifier: Error loading medias",
        error: e,
        stackTrace: s,
      );
    }
    return state.medias.values.toList();
  }

  Future<void> loadAlbum() async {
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
      loadMedia(reload: true);
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "AlbumMediaListStateNotifier: Error loading album",
        error: e,
        stackTrace: s,
      );
    }
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
      loadAlbum();
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "AlbumMediaListStateNotifier: Error adding media",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> removeMediaFromAlbum() async {
    final list = state.album.medias.toList();
    list.removeWhere((element) {
      return state.selectedMedias.contains(element);
    });
    await updateAlbumMedias(medias: list, append: false);
  }

  void toggleMediaSelection(String id) {
    if (state.selectedMedias.contains(id)) {
      state = state.copyWith(
        selectedMedias:
            state.selectedMedias.where((element) => element != id).toList(),
      );
    } else {
      state = state.copyWith(selectedMedias: [...state.selectedMedias, id]);
    }
  }

  void clearSelection() {
    state = state.copyWith(selectedMedias: []);
  }
}

@freezed
class AlbumMediaListState with _$AlbumMediaListState {
  const factory AlbumMediaListState({
    @Default({}) Map<String, AppMedia> medias,
    @Default([]) List<String> selectedMedias,
    required Album album,
    @Default(false) bool loading,
    @Default(false) bool loadingMore,
    @Default(false) bool deleteAlbumSuccess,
    Object? error,
    Object? actionError,
  }) = _AlbumMediaListState;
}
