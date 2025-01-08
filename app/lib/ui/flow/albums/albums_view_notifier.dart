import 'package:data/errors/app_error.dart';
import 'package:data/log/logger.dart';
import 'package:data/models/album/album.dart';
import 'package:data/models/dropbox/account/dropbox_account.dart';
import 'package:data/models/media/media.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/services/dropbox_services.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

part 'albums_view_notifier.freezed.dart';

final albumStateNotifierProvider =
    StateNotifierProvider.autoDispose<AlbumStateNotifier, AlbumsState>((ref) {
  final notifier = AlbumStateNotifier(
    ref.read(localMediaServiceProvider),
    ref.read(googleDriveServiceProvider),
    ref.read(dropboxServiceProvider),
    ref.read(loggerProvider),
    ref.read(googleUserAccountProvider),
    ref.read(AppPreferences.dropboxCurrentUserAccount),
  );
  ref.listen(googleUserAccountProvider, (p, c) {
    notifier.onGoogleDriveAccountChange(c);
  });
  ref.listen(AppPreferences.dropboxCurrentUserAccount, (p, c) {
    notifier.onDropboxAccountChange(c);
  });
  return notifier;
});

class AlbumStateNotifier extends StateNotifier<AlbumsState> {
  final LocalMediaService _localMediaService;
  final GoogleDriveService _googleDriveService;
  final DropboxService _dropboxService;
  final Logger _logger;
  String? _backupFolderId;

  AlbumStateNotifier(
    this._localMediaService,
    this._googleDriveService,
    this._dropboxService,
    this._logger,
    GoogleSignInAccount? googleAccount,
    DropboxAccount? dropboxAccount,
  ) : super(
          AlbumsState(
            googleAccount: googleAccount,
            dropboxAccount: dropboxAccount,
          ),
        ) {
    loadAlbums();
  }

  Future<void> onGoogleDriveAccountChange(
    GoogleSignInAccount? googleAccount,
  ) async {
    state = state.copyWith(googleAccount: googleAccount);
    if (googleAccount != null) {
      _backupFolderId = await _googleDriveService.getBackUpFolderId();
      loadAlbums();
    } else {
      _backupFolderId = null;
      state = state.copyWith(
        albums: state.albums
            .where((element) => element.source != AppMediaSource.googleDrive)
            .toList(),
      );
    }
  }

  void onDropboxAccountChange(DropboxAccount? dropboxAccount) {
    state = state.copyWith(dropboxAccount: dropboxAccount);
    if (dropboxAccount != null) {
      loadAlbums();
    } else {
      state = state.copyWith(
        albums: state.albums
            .where((element) => element.source != AppMediaSource.dropbox)
            .toList(),
      );
    }
  }

  /// Lookups for the first media in the album that is available
  Future<({String id, AppMedia media})?> _getThumbnailMedia({
    required Album album,
    required Future<AppMedia?> Function(String id) fetchMedia,
  }) async {
    if (album.medias.isEmpty) return null;

    for (final id in album.medias) {
      final media = await fetchMedia.call(id);
      if (media != null) {
        return (id: album.id, media: media);
      }
    }
    return null;
  }

  Future<void> loadAlbums() async {
    if (state.loading) return;

    state = state.copyWith(loading: true, error: null);
    try {
      if(state.googleAccount != null) {
        _backupFolderId ??= await _googleDriveService.getBackUpFolderId();
      }
      final res = await Future.wait([
        _localMediaService.getAlbums(),
        (state.googleAccount != null && _backupFolderId != null)
            ? _googleDriveService.getAlbums(folderId: _backupFolderId!)
            : Future.value([]),
        (state.dropboxAccount != null)
            ? _dropboxService.getAlbums()
            : Future.value([]),
      ]);

      state = state.copyWith(
        albums: [...res[0], ...res[1], ...res[2]],
        loading: false,
      );

      final medias = await Future.wait([
        for (Album album in res[0])
          _getThumbnailMedia(
            album: album,
            fetchMedia: (id) => _localMediaService.getMedia(id: id),
          ),
        for (final album in res[1])
          _getThumbnailMedia(
            album: album,
            fetchMedia: (id) => _googleDriveService.getMedia(id: id),
          ),
        for (final album in res[2])
          _getThumbnailMedia(
            album: album,
            fetchMedia: (id) => _dropboxService.getMedia(id: id),
          ),
      ]).then(
        (value) => {
          for (final item in value)
            if (item != null) item.id: item.media,
        },
      );

      state = state.copyWith(medias: medias);
    } catch (e, s) {
      state = state.copyWith(loading: false, error: e);
      _logger.e(
        "AlbumStateNotifier: Error loading albums",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> deleteAlbum(Album album) async {
    try {
      state = state.copyWith(actionError: null);
      if (album.source == AppMediaSource.local) {
        await _localMediaService.deleteAlbum(album.id);
      } else if (album.source == AppMediaSource.googleDrive) {
        _backupFolderId ??= await _googleDriveService.getBackUpFolderId();
        if (_backupFolderId == null) {
          throw BackUpFolderNotFound();
        }
        await _googleDriveService.removeAlbum(
          folderId: _backupFolderId!,
          id: album.id,
        );
      } else if (album.source == AppMediaSource.dropbox) {
        await _dropboxService.deleteAlbum(album.id);
      }
      state = state.copyWith(
        albums:
            state.albums.where((element) => element.id != album.id).toList(),
      );
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "AlbumStateNotifier: Error deleting album",
        error: e,
        stackTrace: s,
      );
    }
  }
}

@freezed
class AlbumsState with _$AlbumsState {
  const factory AlbumsState({
    @Default(false) bool loading,
    @Default([]) List<Album> albums,
    @Default({}) Map<String, AppMedia> medias,
    GoogleSignInAccount? googleAccount,
    DropboxAccount? dropboxAccount,
    Object? error,
    Object? actionError,
  }) = _AlbumsState;
}
