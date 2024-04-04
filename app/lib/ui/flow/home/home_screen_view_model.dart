import 'dart:async';
import 'package:cloud_gallery/domain/extensions/map_extensions.dart';
import 'package:data/errors/app_error.dart';
import 'package:data/models/media/media.dart';
import 'package:data/repositories/google_drive_repo.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:style/extensions/list_extensions.dart';
import 'home_view_model_helper_mixin.dart';

part 'home_screen_view_model.freezed.dart';

final homeViewStateNotifier =
    StateNotifierProvider.autoDispose<HomeViewStateNotifier, HomeViewState>(
        (ref) {
  return HomeViewStateNotifier(
    ref.read(localMediaServiceProvider),
    ref.read(googleDriveServiceProvider),
    ref.read(authServiceProvider),
    ref.read(googleDriveRepoProvider),
  );
});

class HomeViewStateNotifier extends StateNotifier<HomeViewState>
    with HomeViewModelHelperMixin {
  final AuthService _authService;
  final GoogleDriveService _googleDriveService;
  final GoogleDriveRepo _googleDriveRepo;
  final LocalMediaService _localMediaService;

  StreamSubscription? _googleAccountSubscription;
  StreamSubscription? _googleDriveProcessSubscription;

  List<AppMedia> _uploadedMedia = [];
  String? _backUpFolderId;
  bool _isGoogleDriveLoading = false;
  bool _isLocalMediaLoading = false;
  bool _isMaxLocalMediaLoaded = false;

  HomeViewStateNotifier(this._localMediaService, this._googleDriveService,
      this._authService, this._googleDriveRepo)
      : super(const HomeViewState()) {
    _listenUserGoogleAccount();
    _listenGoogleDriveProcess();
    _loadInitialMedia();
  }

  void _listenUserGoogleAccount() {
    _googleAccountSubscription =
        _authService.onGoogleAccountChange.listen((event) async {
      state = state.copyWith(googleAccount: event);
      _googleDriveRepo.terminateAllProcess();
      if (event != null) {
        _backUpFolderId = await _googleDriveService.getBackupFolderId();
        await loadGoogleDriveMedia();
      } else {
        _backUpFolderId = null;
        _uploadedMedia.clear();
        state = state.copyWith(
          medias: removeGoogleDriveRefFromMedias(medias: state.medias),
        );
      }
    });
  }

  void _listenGoogleDriveProcess() {
    _googleDriveProcessSubscription =
        _googleDriveRepo.mediaProcessStream.listen((event) {
      final uploadSuccessIds = event
          .where((element) =>
              element.status == AppMediaProcessStatus.uploadingSuccess)
          .map((e) => e.mediaId);

      final deleteSuccessIds = event
          .where((element) =>
              element.status == AppMediaProcessStatus.successDelete)
          .map((e) => e.mediaId);

      if (uploadSuccessIds.isNotEmpty) {
        state = state.copyWith(
            medias: addGoogleDriveRefInMedias(
                medias: state.medias,
                event: event,
                uploadSuccessIds: uploadSuccessIds.toList()));
      }
      if (deleteSuccessIds.isNotEmpty) {
        state = state.copyWith(
            medias: removeGoogleDriveRefFromMedias(
                medias: state.medias,
                removeFromIds: deleteSuccessIds.toList()));
      }

      state = state.copyWith(mediaProcesses: event);
    });
  }

  void _loadInitialMedia() async {
    state = state.copyWith(loading: true, error: null);
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
            .expand((element) => element.where((element) =>
                element.sources.contains(AppMediaSource.googleDrive) &&
                element.sources.length == 1))
            .toList();
      }

      state = state.copyWith(
        medias: sortMedias(
          medias: append
              ? [
                  ...state.medias.values.expand((element) => element).toList(),
                  ...mergedMedia
                ]
              : [...mergedMedia, ...googleDriveMedia],
        ),
        loading: false,
        lastLocalMediaId: mergedMedia.length > 10
            ? mergedMedia.elementAt(mergedMedia.length - 10).id
            : state.lastLocalMediaId,
      );
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
      _backUpFolderId ??= await _googleDriveService.getBackupFolderId();

      state = state.copyWith(loading: state.medias.isEmpty, error: null);
      final driveMedias = await _googleDriveService.getDriveMedias(
        backUpFolderId: _backUpFolderId!,
      );

      // Separate media by its local existence
      List<AppMedia> googleDriveMedia = [];
      List<AppMedia> uploadedMedia = [];
      for (var media in driveMedias) {
        if (await media.isExist) {
          uploadedMedia.add(media);
        } else {
          googleDriveMedia.add(media);
        }
      }
      _uploadedMedia = uploadedMedia;

      //override google drive media if exist.
      state = state.copyWith(
        medias: sortMedias(medias: [
          ...mergeCommonMedia(
            localMedias: removeGoogleDriveRefFromMedias(medias: state.medias)
                .values
                .expand((element) => element)
                .toList(),
            googleDriveMedias: uploadedMedia,
          ),
          ...googleDriveMedia
        ]),
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
      final medias = state.selectedMedias
          .where((element) => element.sources.contains(AppMediaSource.local))
          .map((e) => e.id)
          .toList();
      await _localMediaService.deleteMedias(medias);
      state = state.copyWith(selectedMedias: []);
      await loadLocalMedia();
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> deleteMediasFromGoogleDrive() async {
    try {
      final mediaGoogleDriveIds = state.selectedMedias
          .where(
            (element) =>
                element.sources.contains(AppMediaSource.googleDrive) &&
                element.driveMediaRefId != null,
          )
          .map((e) => e.driveMediaRefId!)
          .toList();

      _googleDriveRepo.deleteMediasInGoogleDrive(mediaIds: mediaGoogleDriveIds);
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

      List<AppMedia> uploadingMedias = state.selectedMedias
          .where((element) =>
              !element.sources.contains(AppMediaSource.googleDrive))
          .toList();
      _backUpFolderId ??= await _googleDriveService.getBackupFolderId();

      _googleDriveRepo.uploadMediasInGoogleDrive(
        medias: uploadingMedias,
        backUpFolderId: _backUpFolderId!,
      );

      state = state.copyWith(selectedMedias: []);
    } catch (error) {
      if (error is BackUpFolderNotFound) {
        _backUpFolderId = await _googleDriveService.getBackupFolderId();
        backUpMediaOnGoogleDrive();
        return;
      }
      state = state.copyWith(error: error);
    }
  }

  @override
  Future<void> dispose() async {
    await _googleAccountSubscription?.cancel();
    await _googleDriveProcessSubscription?.cancel();
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
    String? lastLocalMediaId,
    @Default({}) Map<DateTime, List<AppMedia>> medias,
    @Default([]) List<AppMedia> selectedMedias,
    @Default([]) List<AppMediaProcess> mediaProcesses,
  }) = _HomeViewState;
}
