import 'dart:async';
import 'package:data/domain/config.dart';
import 'package:data/handlers/connectivity_handler.dart';
import 'package:data/log/logger.dart';
import 'package:data/models/dropbox/account/dropbox_account.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:data/models/media_process/media_process.dart';
import 'package:data/repositories/media_process_repository.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/services/dropbox_services.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

part 'media_preview_view_model.freezed.dart';

final mediaPreviewStateNotifierProvider =
    StateNotifierProvider.family.autoDispose<
        MediaPreviewStateNotifier,
        MediaPreviewState,
        ({
          int startIndex,
          List<AppMedia> medias,
        })>((ref, state) {
  final notifier = MediaPreviewStateNotifier(
    ref.read(localMediaServiceProvider),
    ref.read(googleDriveServiceProvider),
    ref.read(dropboxServiceProvider),
    ref.read(mediaProcessRepoProvider),
    ref.read(authServiceProvider),
    ref.read(connectivityHandlerProvider),
    ref.read(loggerProvider),
    state.medias,
    state.startIndex,
    ref.read(AppPreferences.dropboxCurrentUserAccount),
  );
  ref.listen(AppPreferences.dropboxCurrentUserAccount, (previous, next) {
    notifier._listenDropboxAccount(next);
  });
  return notifier;
});

class MediaPreviewStateNotifier extends StateNotifier<MediaPreviewState> {
  final LocalMediaService _localMediaService;
  final GoogleDriveService _googleDriveService;
  final DropboxService _dropboxService;
  final MediaProcessRepo _mediaProcessRepo;
  final ConnectivityHandler _connectivityHandler;
  final AuthService _authService;
  final Logger _logger;

  StreamSubscription? _googleAccountSubscription;
  String? _backUpFolderId;

  MediaPreviewStateNotifier(
    this._localMediaService,
    this._googleDriveService,
    this._dropboxService,
    this._mediaProcessRepo,
    this._authService,
    this._connectivityHandler,
    this._logger,
    List<AppMedia> medias,
    int startIndex,
    DropboxAccount? dropboxAccount,
  ) : super(
          MediaPreviewState(
            googleAccount: _authService.googleAccount,
            currentIndex: startIndex,
            medias: medias,
            dropboxAccount: dropboxAccount,
          ),
        ) {
    _mediaProcessRepo.addListener(_mediaProcessObserve);
    _setBackUpFolderId();
    _listenGoogleAccount();
  }

  // Google Account Listener ---------------------------------------------------

  void _listenGoogleAccount() {
    _googleAccountSubscription = _authService.onGoogleAccountChange.listen(
      (account) {
        state = state.copyWith(googleAccount: account);
        if (account == null) {
          _backUpFolderId = null;
        } else {
          _setBackUpFolderId();
        }
      },
    );
  }

  void _listenDropboxAccount(DropboxAccount? account) {
    state = state.copyWith(dropboxAccount: account);
  }

  Future<void> _setBackUpFolderId() async {
    try {
      if (state.googleAccount == null) return;
      state = state.copyWith(actionError: null);
      _backUpFolderId = await _googleDriveService.getBackUpFolderId();
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "MediaPreviewStateNotifier: unable to get backup folder id",
        error: e,
        stackTrace: s,
      );
    }
  }

  // Media Process Observer ----------------------------------------------------

  void _mediaProcessObserve() {
    state = state.copyWith(
      uploadMediaProcesses: Map.fromEntries(
        _mediaProcessRepo.uploadQueue.map((e) => MapEntry(e.media_id, e)),
      ),
      downloadMediaProcesses: Map.fromEntries(
        _mediaProcessRepo.downloadQueue.map((e) => MapEntry(e.media_id, e)),
      ),
    );

    for (final process in _mediaProcessRepo.uploadQueue) {
      if (process.status.isCompleted) {
        state = state.copyWith(
          medias: state.medias.map(
            (media) {
              if (media.id == process.media_id &&
                  process.provider == MediaProvider.googleDrive &&
                  !media.sources.contains(AppMediaSource.googleDrive) &&
                  process.response != null) {
                return media.mergeGoogleDriveMedia(process.response!);
              } else if (media.id == process.media_id &&
                  process.provider == MediaProvider.dropbox &&
                  !media.sources.contains(AppMediaSource.dropbox) &&
                  process.response != null) {
                return media.mergeDropboxMedia(process.response!);
              }
              return media;
            },
          ).toList(),
        );
      }
    }

    for (final process in _mediaProcessRepo.downloadQueue) {
      if (process.status.isCompleted) {
        state = state.copyWith(
          medias: state.medias.map(
            (media) {
              if (media.driveMediaRefId != null &&
                  media.driveMediaRefId == process.media_id &&
                  process.provider == MediaProvider.googleDrive &&
                  !media.sources.contains(AppMediaSource.local) &&
                  process.response != null) {
                return process.response!.mergeGoogleDriveMedia(media);
              } else if (media.dropboxMediaRefId != null &&
                  media.dropboxMediaRefId == process.media_id &&
                  process.provider == MediaProvider.dropbox &&
                  !media.sources.contains(AppMediaSource.local) &&
                  process.response != null) {
                return process.response!.mergeDropboxMedia(media);
              }
              return media;
            },
          ).toList(),
        );
      }
    }
  }

  // Media Actions -------------------------------------------------------------

  Future<void> deleteMediaFromLocal(String id) async {
    try {
      state = state.copyWith(actionError: null);
      await _localMediaService.deleteMedias([id]);
      final List<AppMedia> medias = [];
      for (final media in state.medias) {
        if (media.id != id) {
          medias.add(media);
        } else if (media.id == id && media.isCommonStored) {
          medias.add(media.removeLocalRef());
        }
      }
      state = state.copyWith(medias: medias);
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "MediaPreviewStateNotifier: unable to delete media from local",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> deleteMediaFromGoogleDrive(String id) async {
    try {
      if (state.googleAccount == null) return;
      state = state.copyWith(actionError: null);
      await _googleDriveService.deleteMedia(id: id);
      final List<AppMedia> medias = [];
      for (final media in state.medias) {
        if (media.driveMediaRefId != id) {
          medias.add(media);
        } else if (media.driveMediaRefId == id && media.isCommonStored) {
          medias.add(media.removeGoogleDriveRef());
        }
      }
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "MediaPreviewStateNotifier: unable to delete media from Google Drive",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> deleteMediaFromDropbox(String id) async {
    try {
      if (_authService.dropboxAccount == null) return;
      state = state.copyWith(actionError: null);
      await _dropboxService.deleteMedia(id: id);
      final List<AppMedia> medias = [];
      for (final media in state.medias) {
        if (media.dropboxMediaRefId != id) {
          medias.add(media);
        } else if (media.dropboxMediaRefId == id && media.isCommonStored) {
          medias.add(media.removeDropboxRef());
        }
      }
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "MediaPreviewStateNotifier: unable to delete media from Dropbox",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> uploadMediaInGoogleDrive({required AppMedia media}) async {
    try {
      if (state.googleAccount == null) return;

      state = state.copyWith(actionError: null);

      _backUpFolderId ??= await _googleDriveService.getBackUpFolderId();

      _mediaProcessRepo.uploadMedia(
        folderId: _backUpFolderId!,
        medias: [media],
        provider: MediaProvider.googleDrive,
      );
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "MediaPreviewStateNotifier: unable to upload media to Google Drive",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> uploadMediaInDropbox({required AppMedia media}) async {
    try {
      if (_authService.dropboxAccount == null) return;

      state = state.copyWith(actionError: null);

      await _connectivityHandler.checkInternetAccess();

      _mediaProcessRepo.uploadMedia(
        folderId: ProviderConstants.backupFolderPath,
        medias: [media],
        provider: MediaProvider.dropbox,
      );
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "MediaPreviewStateNotifier: unable to upload media to Dropbox",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> downloadFromGoogleDrive({required AppMedia media}) async {
    try {
      if (state.googleAccount == null) return;
      state = state.copyWith(actionError: null);
      _backUpFolderId ??= await _googleDriveService.getBackUpFolderId();

      _mediaProcessRepo.downloadMedia(
        folderId: _backUpFolderId!,
        medias: [media],
        provider: MediaProvider.googleDrive,
      );
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "MediaPreviewStateNotifier: unable to download media from Google Drive",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> downloadFromDropbox({required AppMedia media}) async {
    try {
      if (_authService.dropboxAccount == null) return;

      state = state.copyWith(actionError: null);

      await _connectivityHandler.checkInternetAccess();

      _mediaProcessRepo.downloadMedia(
        folderId: ProviderConstants.backupFolderPath,
        medias: [media],
        provider: MediaProvider.dropbox,
      );
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "MediaPreviewStateNotifier: unable to download media from Dropbox",
        error: e,
        stackTrace: s,
      );
    }
  }

  // Preview Actions -----------------------------------------------------------

  void changeVisibleMediaIndex(int index) {
    ///TODO: return user back if there is no media to preview
    state = state.copyWith(currentIndex: index);
  }

  // Video Player Actions ------------------------------------------------------

  void toggleActionVisibility() {
    state = state.copyWith(showActions: !state.showActions);
  }

  void updateVideoPosition(Duration position) {
    if (state.videoPosition == position) return;
    state = state.copyWith(videoPosition: position);
  }

  void updateVideoPlaying(bool isPlaying) {
    if (state.isVideoPlaying == isPlaying) return;
    state = state.copyWith(isVideoPlaying: isPlaying);
  }

  void updateVideoBuffering(bool isBuffering) {
    if (state.isVideoBuffering == isBuffering) return;
    state = state.copyWith(isVideoBuffering: isBuffering);
  }

  void updateVideoInitialized(bool isInitialized) {
    if (state.isVideoInitialized == isInitialized) return;
    state = state.copyWith(isVideoInitialized: isInitialized);
  }

  void updateVideoMaxDuration(Duration maxDuration) {
    if (state.videoMaxDuration == maxDuration) return;
    state = state.copyWith(videoMaxDuration: maxDuration);
  }

  @override
  void dispose() {
    _googleAccountSubscription?.cancel();
    _mediaProcessRepo.removeListener(_mediaProcessObserve);
    super.dispose();
  }
}

@freezed
class MediaPreviewState with _$MediaPreviewState {
  const factory MediaPreviewState({
    GoogleSignInAccount? googleAccount,
    DropboxAccount? dropboxAccount,
    Object? error,
    Object? actionError,
    @Default([]) List<AppMedia> medias,
    @Default(0) int currentIndex,
    @Default(true) bool showActions,
    @Default(false) bool isVideoInitialized,
    @Default(false) bool isVideoBuffering,
    @Default(Duration.zero) Duration videoPosition,
    @Default(Duration.zero) Duration videoMaxDuration,
    @Default(false) bool isVideoPlaying,
    @Default({}) Map<String, UploadMediaProcess> uploadMediaProcesses,
    @Default({}) Map<String, DownloadMediaProcess> downloadMediaProcesses,
  }) = _MediaPreviewState;
}
