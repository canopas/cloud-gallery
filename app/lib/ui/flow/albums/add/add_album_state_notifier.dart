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
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:data/handlers/unique_id_generator.dart';

part 'add_album_state_notifier.freezed.dart';

final addAlbumStateNotifierProvider = StateNotifierProvider.autoDispose
    .family<AddAlbumStateNotifier, AddAlbumsState, Album?>((ref, state) {
  final notifier = AddAlbumStateNotifier(
    ref.read(googleUserAccountProvider),
    ref.read(AppPreferences.dropboxCurrentUserAccount),
    ref.read(localMediaServiceProvider),
    ref.read(googleDriveServiceProvider),
    ref.read(dropboxServiceProvider),
    ref.read(uniqueIdGeneratorProvider),
    ref.read(loggerProvider),
    state,
  );
  final googleDriveAccountSubscription = ref.listen(
    googleUserAccountProvider,
    (_, googleAccount) => notifier.onGoogleDriveAccountChange(googleAccount),
  );
  final dropboxAccountSubscription = ref.listen(
    AppPreferences.dropboxCurrentUserAccount,
    (_, dropboxAccount) => notifier.onDropboxAccountChange(dropboxAccount),
  );

  ref.onDispose(() {
    googleDriveAccountSubscription.close();
    dropboxAccountSubscription.close();
  });

  return notifier;
});

class AddAlbumStateNotifier extends StateNotifier<AddAlbumsState> {
  final GoogleSignInAccount? googleAccount;
  final DropboxAccount? dropboxAccount;
  final LocalMediaService _localMediaService;
  final GoogleDriveService _googleDriveService;
  final DropboxService _dropboxService;
  final UniqueIdGenerator _uniqueIdGenerator;
  final Logger _logger;
  final Album? editAlbum;

  AddAlbumStateNotifier(
    this.googleAccount,
    this.dropboxAccount,
    this._localMediaService,
    this._googleDriveService,
    this._dropboxService,
    this._uniqueIdGenerator,
    this._logger,
    this.editAlbum,
  ) : super(
          AddAlbumsState(
            albumNameController: TextEditingController(text: editAlbum?.name),
            mediaSource: editAlbum?.source ?? AppMediaSource.local,
            googleAccount: googleAccount,
            dropboxAccount: dropboxAccount,
          ),
        );

  void onGoogleDriveAccountChange(GoogleSignInAccount? googleAccount) {
    state = state.copyWith(googleAccount: googleAccount);
  }

  void onDropboxAccountChange(DropboxAccount? dropboxAccount) {
    state = state.copyWith(dropboxAccount: dropboxAccount);
  }

  void onSourceChange(AppMediaSource source) {
    state = state.copyWith(mediaSource: source);
  }

  Future<void> createAlbum() async {
    try {
      state = state.copyWith(loading: true);

      if (state.mediaSource == AppMediaSource.local) {
        if (editAlbum != null) {
          await _localMediaService.updateAlbum(
            editAlbum!.copyWith(
              name: state.albumNameController.text.trim(),
            ),
          );
        } else {
          await _localMediaService.createAlbum(
            id: _uniqueIdGenerator.v4(),
            name: state.albumNameController.text.trim(),
          );
        }
      } else if (state.mediaSource == AppMediaSource.googleDrive &&
          googleAccount != null) {
        final backupFolderId = await _googleDriveService.getBackUpFolderId();

        if (backupFolderId == null) {
          throw BackUpFolderNotFound();
        }
        if (editAlbum != null) {
          final album = editAlbum!.copyWith(
            name: state.albumNameController.text.trim(),
          );
          await _googleDriveService.updateAlbum(
            folderId: backupFolderId,
            album: album,
          );
        } else {
          final album = Album(
            id: _uniqueIdGenerator.v4(),
            name: state.albumNameController.text.trim(),
            source: AppMediaSource.googleDrive,
            created_at: DateTime.now(),
            medias: [],
          );
          await _googleDriveService.createAlbum(
            folderId: backupFolderId,
            newAlbum: album,
          );
        }
      } else if (state.mediaSource == AppMediaSource.dropbox) {
        if (editAlbum != null) {
          await _dropboxService.updateAlbum(
            editAlbum!.copyWith(
              name: state.albumNameController.text.trim(),
            ),
          );
        } else {
          final album = Album(
            id: _uniqueIdGenerator.v4(),
            name: state.albumNameController.text.trim(),
            source: AppMediaSource.dropbox,
            created_at: DateTime.now(),
            medias: [],
          );
          await _dropboxService.createAlbum(album);
        }
      }
      state = state.copyWith(loading: false, succeed: true);
    } catch (e, s) {
      state = state.copyWith(loading: false, error: e);
      _logger.e(
        'AddAlbumStateNotifier: Error creating album',
        error: e,
        stackTrace: s,
      );
    }
  }

  void validateAlbumName(String _) {
    state = state.copyWith(
      allowSave: state.albumNameController.text.trim().isNotEmpty,
    );
  }

  @override
  void dispose() {
    state.albumNameController.dispose();
    super.dispose();
  }
}

@freezed
class AddAlbumsState with _$AddAlbumsState {
  const factory AddAlbumsState({
    @Default(false) bool loading,
    @Default(false) bool succeed,
    @Default(false) bool allowSave,
    @Default(AppMediaSource.local) AppMediaSource mediaSource,
    required TextEditingController albumNameController,
    GoogleSignInAccount? googleAccount,
    DropboxAccount? dropboxAccount,
    Object? error,
  }) = _AddAlbumsState;
}
