import 'dart:async';
import '../../../domain/extensions/map_extensions.dart';
import '../../../domain/extensions/media_list_extension.dart';
import 'package:data/models/app_process/app_process.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:data/repositories/google_drive_process_repo.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:style/extensions/list_extensions.dart';
import 'home_view_model_helper_mixin.dart';

part 'home_screen_view_model.freezed.dart';

final homeViewStateNotifier =
    StateNotifierProvider.autoDispose<HomeViewStateNotifier, HomeViewState>(
        (ref) {
  final homeView = HomeViewStateNotifier(
    ref.read(localMediaServiceProvider),
    ref.read(googleDriveServiceProvider),
    ref.read(authServiceProvider),
    ref.read(googleDriveProcessRepoProvider),
    ref.read(AppPreferences.googleDriveAutoBackUp),
  );

  ref.listen(AppPreferences.googleDriveAutoBackUp, (previous, next) {
    homeView.updateAutoBackUpStatus(next);
  });
  return homeView;
});

class HomeViewStateNotifier extends StateNotifier<HomeViewState>
    with HomeViewModelHelperMixin {
  bool _autoBackUpStatus;
  final AuthService _authService;
  final GoogleDriveService _googleDriveService;
  final GoogleDriveProcessRepo _googleDriveProcessRepo;
  final LocalMediaService _localMediaService;

  StreamSubscription? _googleAccountSubscription;

  List<AppMedia> _uploadedMedia = [];
  String? _backUpFolderId;
  bool _isGoogleDriveLoading = false;
  bool _isLocalMediaLoading = false;
  bool _isMaxLocalMediaLoaded = false;

  HomeViewStateNotifier(
    this._localMediaService,
    this._googleDriveService,
    this._authService,
    this._googleDriveProcessRepo,
    this._autoBackUpStatus,
  ) : super(const HomeViewState()) {
    _listenUserGoogleAccount();
    _googleDriveProcessRepo.setBackUpFolderId(_backUpFolderId);
    _googleDriveProcessRepo.addListener(_listenGoogleDriveProcess);
    loadMedias();
    _checkAutoBackUp();
  }

  void updateAutoBackUpStatus(bool status) {
    _autoBackUpStatus = status;
    _checkAutoBackUp();
    if (!status) {
      _googleDriveProcessRepo.terminateAllAutoBackupProcess();
    }
  }

  void _checkAutoBackUp() {
    if (_autoBackUpStatus) {
      _googleDriveProcessRepo.autoBackInGoogleDrive();
    }
  }

  void _listenUserGoogleAccount() {
    _googleAccountSubscription =
        _authService.onGoogleAccountChange.listen((event) async {
      state = state.copyWith(googleAccount: event);
      _googleDriveProcessRepo.clearAllQueue();
      if (event != null) {
        _backUpFolderId = await _googleDriveService.getBackUpFolderId();
        _googleDriveProcessRepo.setBackUpFolderId(_backUpFolderId);
        await loadGoogleDriveMedia();
      } else {
        _backUpFolderId = null;
        _uploadedMedia.clear();
        state = state.copyWith(
          medias: removeGoogleDriveRefFromMediaMap(medias: state.medias),
        );
      }
    });
  }

  void _listenGoogleDriveProcess() {
    final successUploads = _googleDriveProcessRepo.uploadQueue
        .where((element) => element.status.isSuccess);

    final successDeletes = _googleDriveProcessRepo.deleteQueue
        .where((element) => element.status.isSuccess)
        .map((e) => e.id);

    final successDownloads = _googleDriveProcessRepo.downloadQueue
        .where((element) => element.status.isSuccess);

    if (successUploads.isNotEmpty) {
      state = state.copyWith(
        medias: addGoogleDriveRefInMediaMap(
          medias: state.medias,
          process: successUploads.toList(),
        ),
      );
    }

    if (successDeletes.isNotEmpty) {
      state = state.copyWith(
        medias: removeGoogleDriveRefFromMediaMap(
          medias: state.medias,
          removeFromIds: successDeletes.toList(),
        ),
      );
    }

    if (successDownloads.isNotEmpty) {
      state = state.copyWith(
        medias: replaceMediaRefInMediaMap(
          medias: state.medias,
          process: successDownloads.toList(),
        ),
      );
    }

    state = state.copyWith(
      mediaProcesses: [
        ..._googleDriveProcessRepo.uploadQueue,
        ..._googleDriveProcessRepo.deleteQueue,
        ..._googleDriveProcessRepo.downloadQueue,
      ],
      showTransfer: _googleDriveProcessRepo.uploadQueue.isNotEmpty ||
          _googleDriveProcessRepo.downloadQueue.isNotEmpty,
    );
  }

  Future<void> loadMedias() async {
    state = state.copyWith(loading: state.medias.isEmpty, error: null);
    final hasAccess = await _localMediaService.requestPermission();
    state = state.copyWith(hasLocalMediaAccess: hasAccess, loading: false);
    if (hasAccess) {
      await Future.wait([loadLocalMedia(), loadGoogleDriveMedia()]);
    } else {
      await loadGoogleDriveMedia();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
      state = state.copyWith(googleAccount: _authService.googleAccount);
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> loadLocalMedia({bool append = false}) async {
    if (_isLocalMediaLoading || (_isMaxLocalMediaLoaded && append)) return;
    if (_isMaxLocalMediaLoaded && !append) {
      _isMaxLocalMediaLoaded = false;
    }
    _isLocalMediaLoading = true;
    try {
      state = state.copyWith(loading: state.medias.isEmpty, error: null);

      final loadedLocalMediaCount = state.medias
          .valuesWhere((e) => e.sources.contains(AppMediaSource.local))
          .length;

      final localMedia = await _localMediaService.getLocalMedia(
        start: append ? loadedLocalMediaCount : 0,
        end: append
            ? loadedLocalMediaCount + 30
            : loadedLocalMediaCount < 30
                ? 30
                : loadedLocalMediaCount,
      );

      if (localMedia.length < 30) {
        _isMaxLocalMediaLoaded = true;
      }

      final mergedMedia = mergeCommonMedia(
        localMedias: localMedia,
        googleDriveMedias: _uploadedMedia,
      );
      List<AppMedia> googleDriveMedia = [];

      if (!append) {
        googleDriveMedia = state.medias.values
            .expand(
              (element) => element.where(
                (element) =>
                    element.sources.contains(AppMediaSource.googleDrive) &&
                    element.sources.length == 1,
              ),
            )
            .toList();
      }

      state = state.copyWith(
        medias: sortMedias(
          medias: append
              ? [
                  ...state.medias.values.expand((element) => element),
                  ...mergedMedia,
                ]
              : [...mergedMedia, ...googleDriveMedia],
        ),
        loading: false,
        lastLocalMediaId: mergedMedia.length > 10
            ? mergedMedia.elementAt(mergedMedia.length - 10).id
            : state.lastLocalMediaId,
      );
      if (append) {
        _checkAutoBackUp();
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    } finally {
      _isLocalMediaLoading = false;
    }
  }

  Future<void> loadGoogleDriveMedia() async {
    if (state.googleAccount == null || _isGoogleDriveLoading) return;
    _isGoogleDriveLoading = true;
    try {
      _backUpFolderId ??= await _googleDriveService.getBackUpFolderId();

      state = state.copyWith(loading: state.medias.isEmpty, error: null);
      final driveMedias = await _googleDriveService.getDriveMedias(
        backUpFolderId: _backUpFolderId!,
      );

      // Separate media by its local existence
      final List<AppMedia> googleDriveMedia = [];
      final List<AppMedia> uploadedMedia = [];
      for (var media in driveMedias) {
        if (media.path.trim().isNotEmpty &&
            await _localMediaService.isLocalFileExist(
              type: media.type,
              id: media.path,
            )) {
          uploadedMedia.add(media);
        } else {
          googleDriveMedia.add(media);
        }
      }
      _uploadedMedia = uploadedMedia;

      //override google drive media if exist.
      state = state.copyWith(
        medias: sortMedias(
          medias: [
            ...mergeCommonMedia(
              localMedias:
                  state.medias.values.expand((element) => element).toList()
                    ..removeGoogleDriveRefFromMedias(),
              googleDriveMedias: uploadedMedia,
            ),
            ...googleDriveMedia,
          ],
        ),
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    } finally {
      _isGoogleDriveLoading = false;
    }
  }

  void toggleMediaSelection(AppMedia media) {
    final selectedMedias = state.selectedMedias.toList();
    selectedMedias.addOrRemove(element: media);
    state = state.copyWith(selectedMedias: selectedMedias);
  }

  Future<void> deleteMediasFromLocal() async {
    try {
      final ids = state.selectedMedias
          .where((element) => element.sources.contains(AppMediaSource.local))
          .map((e) => e.id)
          .toList();

      _uploadedMedia.removeWhere((element) => ids.contains(element.id));

      await _localMediaService.deleteMedias(ids);
      state = state.copyWith(
        selectedMedias: [],
        medias: removeLocalRefFromMediaMap(
          medias: state.medias,
          removeFromIds: ids,
        ),
      );
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> deleteMediasFromGoogleDrive() async {
    try {
      final medias = state.selectedMedias.where(
        (element) =>
            element.sources.contains(AppMediaSource.googleDrive) &&
            element.driveMediaRefId != null,
      );

      _googleDriveProcessRepo.deleteMediasFromGoogleDrive(
        medias: medias.toList(),
      );
      state = state.copyWith(selectedMedias: []);
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> downloadMediaFromGoogleDrive() async {
    try {
      final medias =
          state.selectedMedias.where((element) => element.isGoogleDriveStored);
      _googleDriveProcessRepo.downloadMediasFromGoogleDrive(
        medias: medias.toList(),
      );
      state = state.copyWith(selectedMedias: []);
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> backUpMediaOnGoogleDrive() async {
    try {
      if (!_authService.signedInWithGoogle) {
        await _authService.signInWithGoogle();
        await loadGoogleDriveMedia();
      }
      final List<AppMedia> medias = state.selectedMedias
          .where(
            (element) => !element.sources.contains(AppMediaSource.googleDrive),
          )
          .toList();

      _googleDriveProcessRepo.uploadMedia(medias);
      state = state.copyWith(selectedMedias: []);
    } catch (error) {
      state = state.copyWith(error: error);
    }
  }

  @override
  Future<void> dispose() async {
    await _googleAccountSubscription?.cancel();
    _googleDriveProcessRepo.removeListener(_listenGoogleDriveProcess);
    super.dispose();
  }
}

@freezed
class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    Object? error,
    @Default(false) bool hasLocalMediaAccess,
    @Default(false) bool loading,
    GoogleSignInAccount? googleAccount,
    @Default(false) bool showTransfer,
    String? lastLocalMediaId,
    @Default({}) Map<DateTime, List<AppMedia>> medias,
    @Default([]) List<AppMedia> selectedMedias,
    @Default([]) List<AppProcess> mediaProcesses,
  }) = _HomeViewState;
}
