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

  StreamSubscription? _googleAccountSubscription;
  int _localMediaCount = 0;
  bool _localMaxLoaded = false;

  ///Google Drive
  String? _backUpFolderId;
  String? _googleDrivePageToken;
  bool _googleDriveMaxLoaded = false;
  final List<AppMedia> _googleDriveMediasWithLocalRef = [];

  ///Dropbox
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
    DropboxAccount? _dropboxAccount,
  ) : super(HomeViewState(dropboxAccount: _dropboxAccount)) {
    _mediaProcessRepo.addListener(_mediaProcessObserve);
    _listenUserGoogleAccount();
    loadMedias();
  }

  void updateDropboxAccount(DropboxAccount? dropboxAccount) {
    state = state.copyWith(dropboxAccount: dropboxAccount);
  }

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
              if (media.id == process.media_id &&
                  !media.sources.contains(AppMediaSource.local) &&
                  process.response != null) {
                return process.response!.mergeGoogleDriveMedia(media);
              }
              return media;
            },
            medias: state.medias,
          ),
        );
      }
    }
  }

  void _listenUserGoogleAccount() {
    _googleAccountSubscription =
        _authService.onGoogleAccountChange.listen((event) async {
      state = state.copyWith(googleAccount: event);
      if (event != null) {
        _backUpFolderId = await _googleDriveService.getBackUpFolderId();
      } else {
        _backUpFolderId = null;
        state = state.copyWith(
          medias: mediaMapUpdate(
            update: (media) => media.driveMediaRefId != null &&
                    media.sources.contains(AppMediaSource.googleDrive)
                ? media.removeGoogleDriveRef()
                : media,
            medias: state.medias,
          ),
        );
      }
    });
  }

  Future<void> loadMedias({bool reload = false}) async {
    state = state.copyWith(loading: true, error: null);
    try {
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

      final hasAccess = await _localMediaService.requestPermission();
      state = state.copyWith(hasLocalMediaAccess: hasAccess);

      final localMedia = !hasAccess || _localMaxLoaded
          ? <AppMedia>[]
          : await _localMediaService.getLocalMedia(
              start: _localMediaCount,
              end: _localMediaCount + 30,
            );

      if (localMedia.length < 30) {
        _localMaxLoaded = true;
      }

      state = state.copyWith(
        lastLocalMediaId:
            localMedia.isNotEmpty ? localMedia.last.id : state.lastLocalMediaId,
      );

      final List<AppMedia> cloudBasedMedias = [];

      if (!_googleDriveMaxLoaded && state.googleAccount != null) {
        _backUpFolderId ??= await _googleDriveService.getBackUpFolderId();

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

      if (!_dropboxMaxLoaded && state.dropboxAccount != null) {
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
      final List<AppMedia> previousMedias =
          state.medias.values.expand((element) => element.values).toList();

      final List<AppMedia> allMergedMedias = [];

      for (final media in [...previousMedias, ...localMedia]) {
        AppMedia mergedMedia = media;
        for (final gdMedia in _googleDriveMediasWithLocalRef) {
          if (media.id == gdMedia.id) {
            mergedMedia = media.mergeGoogleDriveMedia(gdMedia);
          }
        }
        for (final dropboxMedia in _dropboxMediasWithLocalRef) {
          if (media.id == dropboxMedia.id) {
            mergedMedia = media.mergeDropboxMedia(dropboxMedia);
          }
        }

        ///TODO: fetch more cloud media list if its empty
        allMergedMedias.add(mergedMedia);
      }
      state = state.copyWith(
        loading: false,
        medias: sortMedias(medias: [...allMergedMedias, ...cloudBasedMedias]),
      );
    } catch (e, s) {
      state = state.copyWith(error: e, loading: false);
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
    _mediaProcessRepo.uploadMedia(
      medias: selectedMedias,
      provider: MediaProvider.googleDrive,
      folderId: _backUpFolderId!,
    );
  }

  Future<void> uploadToDropbox() async {
    if (state.dropboxAccount == null) return;
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
    _mediaProcessRepo.uploadMedia(
      medias: selectedMedias,
      provider: MediaProvider.dropbox,
      folderId: ProviderConstants.backupFolderPath,
    );
  }

  Future<void> downloadFromGoogleDrive() async {
    if (state.googleAccount == null) return;
    final selectedMedias = state.selectedMedias.entries
        .where(
          (element) => element.value.isGoogleDriveStored,
        )
        .map((e) => e.value)
        .toList();

    state = state.copyWith(selectedMedias: {});

    _mediaProcessRepo.downloadMedia(
      folderId: _backUpFolderId!,
      medias: selectedMedias,
      provider: MediaProvider.googleDrive,
    );
  }

  Future<void> downloadFromDropbox() async {
    if (state.dropboxAccount == null) return;
    final selectedMedias = state.selectedMedias.entries
        .where(
          (element) => element.value.isDropboxStored,
        )
        .map((e) => e.value)
        .toList();

    state = state.copyWith(selectedMedias: {});

    _mediaProcessRepo.downloadMedia(
      folderId: ProviderConstants.backupFolderPath,
      medias: selectedMedias,
      provider: MediaProvider.dropbox,
    );
  }

  Future<void> deleteLocalMedias() async {
    try {
      final ids = state.selectedMedias.entries
          .where(
            (element) => element.value.sources.contains(AppMediaSource.local),
          )
          .map((e) => e.key)
          .toList();

      state = state.copyWith(
        selectedMedias: {},
        actionError: null,
      );

      await _localMediaService.deleteMedias(ids);

      state = state.copyWith(
        medias: mediaMapUpdate(
          update: (media) {
            if (ids.contains(media.id) && media.isCommonStored) {
              return media.removeLocalRef();
            } else if (ids.contains(media.id) && !media.isLocalStored) {
              return null;
            }
            return media;
          },
          medias: state.medias,
        ),
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

      state = state.copyWith(
        selectedMedias: {},
        actionError: null,
      );

      await Future.wait(
        ids.map((id) => _googleDriveService.deleteMedia(id: id)),
      );

      state = state.copyWith(
        medias: mediaMapUpdate(
          update: (media) {
            if (media.driveMediaRefId != null &&
                ids.contains(media.driveMediaRefId) &&
                media.isCommonStored) {
              return media.removeGoogleDriveRef();
            } else if (media.driveMediaRefId != null &&
                ids.contains(media.driveMediaRefId) &&
                media.isGoogleDriveStored) {
              return null;
            }
            return media;
          },
          medias: state.medias,
        ),
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

      state = state.copyWith(
        selectedMedias: {},
        actionError: null,
      );

      await Future.wait(ids.map((id) => _dropboxService.deleteMedia(id: id)));

      state = state.copyWith(
        medias: mediaMapUpdate(
          update: (media) {
            if (media.dropboxMediaRefId != null &&
                ids.contains(media.dropboxMediaRefId) &&
                media.isCommonStored) {
              return media.removeLocalRef();
            } else if (media.dropboxMediaRefId != null &&
                ids.contains(media.dropboxMediaRefId) &&
                media.isDropboxStored) {
              return null;
            }
            return media;
          },
          medias: state.medias,
        ),
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
    @Default(false) bool loading,
    GoogleSignInAccount? googleAccount,
    DropboxAccount? dropboxAccount,
    @Default({}) Map<DateTime, Map<String, AppMedia>> medias,
    @Default({}) Map<String, AppMedia> selectedMedias,
    @Default({}) Map<String, UploadMediaProcess> uploadMediaProcesses,
    @Default({}) Map<String, DownloadMediaProcess> downloadMediaProcesses,
    String? lastLocalMediaId,
  }) = _HomeViewState;
}
