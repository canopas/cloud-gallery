import 'dart:async';
import 'package:data/log/logger.dart';
import 'package:data/models/dropbox/account/dropbox_account.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:data/models/media_process/media_process.dart';
import 'package:data/services/dropbox_services.dart';
import 'package:data/models/media/media.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:data/handlers/connectivity_handler.dart';
import 'home_view_model_helper_mixin.dart';
import 'package:data/repositories/media_process_repository.dart';
import 'package:data/domain/config.dart';

part 'home_screen_view_model.freezed.dart';

final homeViewStateNotifier =
    StateNotifierProvider.autoDispose<HomeViewStateNotifier, HomeViewState>(
        (ref) {
  final notifier = HomeViewStateNotifier(
    ref.read(localMediaServiceProvider),
    ref.read(googleDriveServiceProvider),
    ref.read(dropboxServiceProvider),
    ref.read(authServiceProvider),
    ref.read(mediaProcessRepoProvider),
    ref.read(loggerProvider),
    ref.read(connectivityHandlerProvider),
    ref.read(AppPreferences.dropboxCurrentUserAccount),
  );
  ref.listen(AppPreferences.dropboxCurrentUserAccount, (previous, next) {
    notifier.updateDropboxAccount(next);
  });
  return notifier;
});

class HomeViewStateNotifier extends StateNotifier<HomeViewState>
    with HomeViewModelHelperMixin {
  final AuthService _authService;
  final Logger _logger;
  final GoogleDriveService _googleDriveService;
  final DropboxService _dropboxService;
  final LocalMediaService _localMediaService;
  final MediaProcessRepo _mediaProcessRepo;
  final ConnectivityHandler _connectivityHandler;

  StreamSubscription? _googleAccountSubscription;

  // Local
  int _localMediaCount = 0;
  bool _localMaxLoaded = false;

  // Google Drive
  String? _backUpFolderId;
  String? _googleDrivePageToken;
  bool _googleDriveMaxLoaded = false;
  final List<AppMedia> _googleDriveMediasWithLocalRef = [];

  // Dropbox
  String? _dropboxPageToken;
  bool _dropboxMaxLoaded = false;
  final List<AppMedia> _dropboxMediasWithLocalRef = [];

  HomeViewStateNotifier(
    this._localMediaService,
    this._googleDriveService,
    this._dropboxService,
    this._authService,
    this._mediaProcessRepo,
    this._logger,
    this._connectivityHandler,
    DropboxAccount? _dropboxAccount,
  ) : super(
          HomeViewState(
            dropboxAccount: _dropboxAccount,
            googleAccount: _authService.googleAccount,
          ),
        ) {
    _mediaProcessRepo.addListener(_mediaProcessObserve);
    _listenUserGoogleAccount();
    loadMedias(reload: true);
    _mediaProcessObserve();
  }

  // ACCOUNT LISTENERS ---------------------------------------------------------

  /// Listen to google account changes and update the state accordingly.
  void _listenUserGoogleAccount() {
    _googleAccountSubscription =
        _authService.onGoogleAccountChange.listen((event) async {
      if (event != null && state.googleAccount?.id != event.id) {
        state = state.copyWith(googleAccount: event);
        try {
          _backUpFolderId = await _googleDriveService.getBackUpFolderId();
        } catch (e, s) {
          _logger.e(
            "HomeViewStateNotifier: unable to get google drive back up folder id",
            error: e,
            stackTrace: s,
          );
        }
        loadMedias(reload: true);
      } else if (event == null) {
        _backUpFolderId = null;
        state = state.copyWith(
          googleAccount: null,
          medias: mediaMapUpdate(
            update: (media) {
              if (media.driveMediaRefId != null &&
                  media.sources.contains(AppMediaSource.googleDrive) &&
                  media.sources.length > 1) {
                return media.removeGoogleDriveRef();
              } else if (!media.sources.contains(AppMediaSource.googleDrive) &&
                  media.driveMediaRefId == null) {
                return media;
              }
              return null;
            },
            medias: state.medias,
          ),
        );
      }
    });
  }

  /// Listen to dropbox account changes and update the state accordingly.
  void updateDropboxAccount(DropboxAccount? dropboxAccount) {
    if (dropboxAccount == null) {
      state = state.copyWith(
        dropboxAccount: null,
        medias: mediaMapUpdate(
          update: (media) {
            if (media.dropboxMediaRefId != null &&
                media.sources.contains(AppMediaSource.dropbox) &&
                media.sources.length > 1) {
              return media.removeDropboxRef();
            } else if (!media.sources.contains(AppMediaSource.dropbox) &&
                media.dropboxMediaRefId == null) {
              return media;
            }
            return null;
          },
          medias: state.medias,
        ),
      );
    } else {
      state = state.copyWith(dropboxAccount: dropboxAccount);
      loadMedias(reload: true);
    }
  }

  // MEDIA PROCESS OBSERVER ----------------------------------------------------

  void _mediaProcessObserve() {
    state = state.copyWith(
      uploadMediaProcesses: Map.fromEntries(
        _mediaProcessRepo.uploadQueue.map((e) => MapEntry(e.media_id, e)),
      ),
      downloadMediaProcesses: Map.fromEntries(
        _mediaProcessRepo.downloadQueue.map((e) => MapEntry(e.media_id, e)),
      ),
      medias: mediaMapUpdate(
        update: (media) {
          if (_mediaProcessRepo.deleteMediaEvent[media.id]?.source ==
                  AppMediaSource.local &&
              media.isCommonStored) {
            return media.removeLocalRef();
          } else if (media.driveMediaRefId != null &&
              _mediaProcessRepo
                      .deleteMediaEvent[media.driveMediaRefId]?.source ==
                  AppMediaSource.googleDrive &&
              media.isCommonStored) {
            return media.removeGoogleDriveRef();
          } else if (media.dropboxMediaRefId != null &&
              _mediaProcessRepo
                      .deleteMediaEvent[media.dropboxMediaRefId]?.source ==
                  AppMediaSource.dropbox &&
              media.isCommonStored) {
            return media.removeDropboxRef();
          } else if (_mediaProcessRepo.deleteMediaEvent.containsKey(media.id) ||
              (media.driveMediaRefId != null &&
                  _mediaProcessRepo.deleteMediaEvent
                      .containsKey(media.driveMediaRefId)) ||
              (media.dropboxMediaRefId != null &&
                  _mediaProcessRepo.deleteMediaEvent
                      .containsKey(media.dropboxMediaRefId))) {
            return null;
          }
          return media;
        },
        medias: state.medias,
      ),
    );

    for (final process in _mediaProcessRepo.uploadQueue) {
      if (process.status.isCompleted) {
        state = state.copyWith(
          medias: mediaMapUpdate(
            update: (media) {
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
            medias: state.medias,
          ),
        );
      }
    }

    for (final process in _mediaProcessRepo.downloadQueue) {
      if (process.status.isCompleted) {
        state = state.copyWith(
          medias: mediaMapUpdate(
            update: (media) {
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
            medias: state.medias,
          ),
        );
      }
    }
  }

  // MEDIA OPERATIONS ----------------------------------------------------------

  /// Loads medias from local, google drive and dropbox.
  /// it append the medias to the existing medias if reload is false.
  Future<void> loadMedias({bool reload = false}) async {
    if (state.loading || state.cloudLoading) return;
    state = state.copyWith(loading: true, cloudLoading: true, error: null);
    try {
      // Reset all the variables if reload is true
      if (reload) {
        _localMediaCount = 0;
        _localMaxLoaded = false;
        _googleDrivePageToken = null;
        _googleDriveMaxLoaded = false;
        _googleDriveMediasWithLocalRef.clear();
        _dropboxPageToken = null;
        _dropboxMaxLoaded = false;
        _dropboxMediasWithLocalRef.clear();
      }

      // Request local media permission and internet connection
      final res = await Future.wait([
        _localMediaService.requestPermission(),
        _connectivityHandler.hasInternetAccess(),
      ]);

      final hasLocalMediaAccess = res[0];
      final hasInternet = res[1];

      state = state.copyWith(
        hasLocalMediaAccess: hasLocalMediaAccess,
        hasInternet: hasInternet,
      );

      // Load local media if access is granted and not max loaded
      final localMedia = !hasLocalMediaAccess || _localMaxLoaded
          ? <AppMedia>[]
          : await _localMediaService.getLocalMedia(
              start: _localMediaCount,
              end: _localMediaCount + 30,
            );

      // Update the local media count and max loaded
      _localMediaCount += localMedia.length;
      if (localMedia.length < 30) {
        _localMaxLoaded = true;
      }

      // Update the state with the loaded medias and stop showing loading
      state = state.copyWith(
        loading: false,
        medias: sortMedias(
          medias: reload
              ? localMedia
              : [
                  ...state.medias.values.expand((element) => element.values),
                  ...localMedia,
                ],
        ),
        lastLocalMediaId: localMedia.isNotEmpty ? localMedia.last.id : null,
      );

      // Here we store the only cloud based medias.
      final List<AppMedia> cloudBasedMedias = [];

      // Load medias from google drive and separate the local ref medias and only cloud based medias.
      if (!_googleDriveMaxLoaded &&
          state.googleAccount != null &&
          _backUpFolderId != null &&
          hasInternet) {
        final res = await _googleDriveService.getPaginatedMedias(
          folder: _backUpFolderId!,
          nextPageToken: _googleDrivePageToken,
          pageSize: 30,
        );
        _googleDriveMaxLoaded = res.nextPageToken == null;
        _googleDrivePageToken = res.nextPageToken;

        final gdMediaCollection = await splitLocalRefMedias(res.medias);
        _googleDriveMediasWithLocalRef.addAll(gdMediaCollection.localRefMedias);
        cloudBasedMedias.addAll(gdMediaCollection.onlyCloudBasedMedias);
      }

      // Load medias from dropbox and separate the local ref medias and only cloud based medias.
      if (!_dropboxMaxLoaded && state.dropboxAccount != null && hasInternet) {
        final res = await _dropboxService.getPaginatedMedias(
          folder: ProviderConstants.backupFolderPath,
          nextPageToken: _dropboxPageToken,
          pageSize: 30,
        );
        _dropboxMaxLoaded = res.nextPageToken == null;
        _dropboxPageToken = res.nextPageToken;

        final dropboxMediaCollection = await splitLocalRefMedias(res.medias);
        _dropboxMediasWithLocalRef.addAll(
          dropboxMediaCollection.localRefMedias,
        );
        cloudBasedMedias.addAll(dropboxMediaCollection.onlyCloudBasedMedias);
      }

      // Here we store all successfully merged medias.
      final List<AppMedia> allMergedMedias = [];

      for (final media
          in state.medias.values.expand((element) => element.values)) {
        // Refill the google drive local ref medias if it is empty and not max loaded
        if (_googleDriveMediasWithLocalRef.isEmpty &&
            !_googleDriveMaxLoaded &&
            state.googleAccount != null &&
            _backUpFolderId != null &&
            hasInternet) {
          final res = await _googleDriveService.getPaginatedMedias(
            folder: _backUpFolderId!,
            nextPageToken: _googleDrivePageToken,
            pageSize: 30,
          );

          _googleDriveMaxLoaded = res.nextPageToken == null;
          _googleDrivePageToken = res.nextPageToken;

          final gdMediaCollection = await splitLocalRefMedias(res.medias);
          _googleDriveMediasWithLocalRef
              .addAll(gdMediaCollection.localRefMedias);
          cloudBasedMedias.addAll(gdMediaCollection.onlyCloudBasedMedias);
        }

        // Refill the dropbox local ref medias if it is empty and not max loaded
        if (_dropboxMediasWithLocalRef.isEmpty &&
            !_dropboxMaxLoaded &&
            state.dropboxAccount != null &&
            hasInternet) {
          final res = await _dropboxService.getPaginatedMedias(
            folder: ProviderConstants.backupFolderPath,
            nextPageToken: _dropboxPageToken,
            pageSize: 30,
          );
          _dropboxMaxLoaded = res.nextPageToken == null;
          _dropboxPageToken = res.nextPageToken;

          final dropboxMediaCollection = await splitLocalRefMedias(res.medias);
          _dropboxMediasWithLocalRef.addAll(
            dropboxMediaCollection.localRefMedias,
          );
          cloudBasedMedias.addAll(dropboxMediaCollection.onlyCloudBasedMedias);
        }

        // Merge the media with google drive or dropbox media if it exists
        AppMedia mergedMedia = media;

        for (final gdMedia in _googleDriveMediasWithLocalRef.toList()) {
          if (media.id == gdMedia.id) {
            mergedMedia = media.mergeGoogleDriveMedia(gdMedia);
            _googleDriveMediasWithLocalRef
                .removeWhere((e) => e.id == gdMedia.id);
          }
        }
        for (final dropboxMedia in _dropboxMediasWithLocalRef.toList()) {
          if (media.id == dropboxMedia.id) {
            mergedMedia = media.mergeDropboxMedia(dropboxMedia);
            _dropboxMediasWithLocalRef
                .removeWhere((e) => e.id == dropboxMedia.id);
          }
        }

        allMergedMedias.add(mergedMedia);
      }
      state = state.copyWith(
        loading: false,
        medias: sortMedias(medias: [...allMergedMedias, ...cloudBasedMedias]),
        cloudLoading: false,
      );
    } catch (e, s) {
      state = state.copyWith(
        error: state.medias.isEmpty ? e : null,
        actionError: state.medias.isNotEmpty ? e : null,
        loading: false,
        cloudLoading: false,
      );
      _logger.e(
        "HomeViewStateNotifier: unable to load medias",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<({List<AppMedia> onlyCloudBasedMedias, List<AppMedia> localRefMedias})>
      splitLocalRefMedias(List<AppMedia> medias) async {
    final list = await Future.wait(
      [for (final media in medias) _findMediaIsExistOrNot(media)],
    );

    final Map<String, bool> mediaExistence = Map.fromEntries(list);

    return (
      onlyCloudBasedMedias:
          medias.where((e) => !(mediaExistence[e.id] ?? false)).toList(),
      localRefMedias:
          medias.where((e) => mediaExistence[e.id] ?? false).toList(),
    );
  }

  Future<MapEntry<String, bool>> _findMediaIsExistOrNot(AppMedia media) async {
    return MapEntry(media.id, await media.assetEntity.exists);
  }

  void toggleMediaSelection(AppMedia media) {
    final selectedMedias = Map<String, AppMedia>.from(state.selectedMedias);
    if (selectedMedias.containsKey(media.id)) {
      selectedMedias.remove(media.id);
    } else {
      selectedMedias[media.id] = media;
    }
    state = state.copyWith(selectedMedias: selectedMedias);
  }

  Future<void> uploadToGoogleDrive() async {
    try {
      if (state.googleAccount == null) return;
      final selectedMedias = state.selectedMedias.entries
          .where(
            (element) => element.value.sources.contains(AppMediaSource.local),
          )
          .map((e) => e.value)
          .toList();

      state = state.copyWith(
        selectedMedias: {},
        actionError: null,
      );
      if (_backUpFolderId == null) {
        _backUpFolderId = await _googleDriveService.getBackUpFolderId();
      } else {
        await _connectivityHandler.checkInternetAccess();
      }
      _mediaProcessRepo.uploadMedia(
        medias: selectedMedias,
        provider: MediaProvider.googleDrive,
        folderId: _backUpFolderId!,
      );
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "HomeViewStateNotifier: unable to upload to google drive",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> uploadToDropbox() async {
    if (state.dropboxAccount == null) return;
    try {
      final selectedMedias = state.selectedMedias.entries
          .where(
            (element) => element.value.sources.contains(AppMediaSource.local),
          )
          .map((e) => e.value)
          .toList();

      state = state.copyWith(
        selectedMedias: {},
        actionError: null,
      );
      await _connectivityHandler.checkInternetAccess();
      _mediaProcessRepo.uploadMedia(
        medias: selectedMedias,
        provider: MediaProvider.dropbox,
        folderId: ProviderConstants.backupFolderPath,
      );
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "HomeViewStateNotifier: unable to upload to dropbox",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> downloadFromGoogleDrive() async {
    try {
      if (state.googleAccount == null) return;
      final selectedMedias = state.selectedMedias.entries
          .where(
            (element) => element.value.isGoogleDriveStored,
          )
          .map((e) => e.value)
          .toList();

      state = state.copyWith(selectedMedias: {}, actionError: null);

      if (_backUpFolderId == null) {
        _backUpFolderId = await _googleDriveService.getBackUpFolderId();
      } else {
        await _connectivityHandler.checkInternetAccess();
      }

      _mediaProcessRepo.downloadMedia(
        folderId: _backUpFolderId!,
        medias: selectedMedias,
        provider: MediaProvider.googleDrive,
      );
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "HomeViewStateNotifier: unable to download from google drive",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> downloadFromDropbox() async {
    try {
      if (state.dropboxAccount == null) return;
      final selectedMedias = state.selectedMedias.entries
          .where(
            (element) => element.value.isDropboxStored,
          )
          .map((e) => e.value)
          .toList();

      state = state.copyWith(selectedMedias: {}, actionError: null);

      await _connectivityHandler.checkInternetAccess();

      _mediaProcessRepo.downloadMedia(
        folderId: ProviderConstants.backupFolderPath,
        medias: selectedMedias,
        provider: MediaProvider.dropbox,
      );
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "HomeViewStateNotifier: unable to download from dropbox",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> deleteLocalMedias() async {
    try {
      final ids = state.selectedMedias.entries
          .where(
            (element) => element.value.sources.contains(AppMediaSource.local),
          )
          .map((e) => e.key)
          .toList();

      state = state.copyWith(selectedMedias: {}, actionError: null);

      await _localMediaService.deleteMedias(ids);

      _mediaProcessRepo.notifyDeleteMedia(
        ids
            .map((e) => DeleteMediaEvent(id: e, source: AppMediaSource.local))
            .toList(),
      );
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "HomeViewStateNotifier: unable to delete local medias",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> deleteGoogleDriveMedias() async {
    if (state.googleAccount == null) return;
    try {
      final ids = state.selectedMedias.entries
          .where(
            (element) =>
                element.value.sources.contains(AppMediaSource.googleDrive) &&
                element.value.driveMediaRefId != null,
          )
          .map((e) => e.value.driveMediaRefId!)
          .toList();

      state = state.copyWith(selectedMedias: {}, actionError: null);

      await Future.wait(
        ids.map((id) => _googleDriveService.deleteMedia(id: id)),
      );

      _mediaProcessRepo.notifyDeleteMedia(
        ids
            .map(
              (e) =>
                  DeleteMediaEvent(id: e, source: AppMediaSource.googleDrive),
            )
            .toList(),
      );
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "HomeViewStateNotifier: unable to delete google drive medias",
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> deleteDropboxMedias() async {
    if (state.dropboxAccount == null) return;
    try {
      final ids = state.selectedMedias.entries
          .where(
            (element) =>
                element.value.sources.contains(AppMediaSource.dropbox) &&
                element.value.dropboxMediaRefId != null,
          )
          .map((e) => e.value.dropboxMediaRefId!)
          .toList();

      state = state.copyWith(selectedMedias: {}, actionError: null);

      await Future.wait(ids.map((id) => _dropboxService.deleteMedia(id: id)));

      _mediaProcessRepo.notifyDeleteMedia(
        ids
            .map(
              (e) => DeleteMediaEvent(id: e, source: AppMediaSource.dropbox),
            )
            .toList(),
      );
    } catch (e, s) {
      state = state.copyWith(actionError: e);
      _logger.e(
        "HomeViewStateNotifier: unable to delete dropbox medias",
        error: e,
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> dispose() async {
    await _googleAccountSubscription?.cancel();
    _mediaProcessRepo.removeListener(_mediaProcessObserve);
    super.dispose();
  }
}

@freezed
class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    Object? error,
    Object? actionError,
    @Default(false) bool hasLocalMediaAccess,
    @Default(false) bool hasInternet,
    @Default(false) bool loading,
    @Default(false) bool cloudLoading,
    GoogleSignInAccount? googleAccount,
    DropboxAccount? dropboxAccount,
    @Default({}) Map<DateTime, Map<String, AppMedia>> medias,
    @Default({}) Map<String, AppMedia> selectedMedias,
    @Default({}) Map<String, UploadMediaProcess> uploadMediaProcesses,
    @Default({}) Map<String, DownloadMediaProcess> downloadMediaProcesses,
    String? lastLocalMediaId,
  }) = _HomeViewState;
}
