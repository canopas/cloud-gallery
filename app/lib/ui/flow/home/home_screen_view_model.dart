import 'dart:async';
import 'package:cloud_gallery/domain/extensions/map_extensions.dart';
import 'package:cloud_gallery/domain/formatter/date_formatter.dart';
import 'package:collection/collection.dart';
import 'package:data/errors/app_error.dart';
import 'package:data/models/media/media.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:style/extensions/list_extensions.dart';

part 'home_screen_view_model.freezed.dart';

final homeViewStateNotifier =
    StateNotifierProvider.autoDispose<HomeViewStateNotifier, HomeViewState>(
        (ref) {
  return HomeViewStateNotifier(
    ref.read(localMediaServiceProvider),
    ref.read(googleDriveServiceProvider),
    ref.read(authServiceProvider),
  );
});

class HomeViewStateNotifier extends StateNotifier<HomeViewState> {
  final GoogleDriveService _googleDriveService;
  final AuthService _authService;
  final LocalMediaService _localMediaService;
  StreamSubscription? _googleAccountSubscription;

  List<AppMedia> _uploadedMedia = [];
  String? _backUpFolderId;
  bool _isGoogleDriveLoading = false;
  bool _isLocalMediaLoading = false;
  bool _isMaxLocalMediaLoaded = false;

  HomeViewStateNotifier(
      this._localMediaService, this._googleDriveService, this._authService)
      : super(const HomeViewState()) {
    _googleAccountSubscription =
        _authService.onGoogleAccountChange.listen((event) async {
      state = state.copyWith(googleAccount: event);
      await loadGoogleDriveMedia();
      if (event == null) {
        _uploadedMedia.clear();
        state = state.copyWith(
          medias: _sortMedias(
              medias: _removeGoogleDriveRefFromMedias(state.medias)),
        );
      }
    });
    _loadInitialMedia();
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

      final mergedMedia = _mergeCommonMedia(
        localMedias: localMedia,
        googleDriveMedias: _uploadedMedia,
      );

      state = state.copyWith(
        medias: _sortMedias(
          medias: append
              ? [
                  ...state.medias.values.expand((element) => element).toList(),
                  ...mergedMedia
                ]
              : mergedMedia,
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
      List googleDriveMedia = [];
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
        medias: _sortMedias(medias: [
          ..._mergeCommonMedia(
            localMedias: _removeGoogleDriveRefFromMedias(state.medias),
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

  Future<void> uploadMediaOnGoogleDrive() async {
    try {
      if (!_authService.signedInWithGoogle) {
        await _authService.signInWithGoogle();
        await loadGoogleDriveMedia();
      }

      List<AppMedia> uploadingMedias = state.selectedMedias
          .where((element) =>
              !element.sources.contains(AppMediaSource.googleDrive))
          .toList();

      state = state.copyWith(
        uploadingMedias: uploadingMedias
            .map((e) =>
                UploadProgress(mediaId: e.id, status: UploadStatus.waiting))
            .toList(),
        error: null,
      );

      _backUpFolderId ??= await _googleDriveService.getBackupFolderId();

      for (final media in uploadingMedias) {
        state = state.copyWith(
          uploadingMedias: state.uploadingMedias.toList()
            ..updateElement(
                newElement: UploadProgress(
                    mediaId: media.id, status: UploadStatus.uploading),
                oldElement: UploadProgress(
                    mediaId: media.id, status: UploadStatus.waiting)),
        );

        await _googleDriveService.uploadInGoogleDrive(
          media: media,
          folderID: _backUpFolderId!,
        );

        state = state.copyWith(
          medias: state.medias.map((key, value) {
            value.updateElement(
                newElement: media.copyWith(
                    sources: media.sources.toList()
                      ..add(AppMediaSource.googleDrive)),
                oldElement: media);
            return MapEntry(key, value);
          }),
          uploadingMedias: state.uploadingMedias.toList()
            ..removeWhere((element) => element.mediaId == media.id),
        );
      }

      state = state.copyWith(uploadingMedias: [], selectedMedias: []);
    } catch (error) {
      if (error is BackUpFolderNotFound) {
        _backUpFolderId = await _googleDriveService.getBackupFolderId();
        uploadMediaOnGoogleDrive();
        return;
      }
      state = state.copyWith(error: error, uploadingMedias: []);
    }
  }

  //Helper functions
  List<AppMedia> _mergeCommonMedia({
    required List<AppMedia> localMedias,
    required List<AppMedia> googleDriveMedias,
  }) {
    // If one of the lists is empty, return the other list.
    if (googleDriveMedias.isEmpty) return localMedias;
    if (localMedias.isEmpty) return [];

    // Convert the lists to mutable lists.
    localMedias = localMedias.toList();
    googleDriveMedias = googleDriveMedias.toList();

    final mergedMedias = <AppMedia>[];

    // Add common media to mergedMedias and remove them from the lists.
    for (AppMedia localMedia in localMedias.toList()) {
      googleDriveMedias
          .toList()
          .where((googleDriveMedia) => googleDriveMedia.path == localMedia.path)
          .forEach((googleDriveMedia) {
        localMedias.removeWhere((media) => media.id == localMedia.id);

        mergedMedias.add(localMedia.copyWith(
          sources: [AppMediaSource.local, AppMediaSource.googleDrive],
          thumbnailLink: googleDriveMedia.thumbnailLink,
        ));
      });
    }

    return [...mergedMedias, ...localMedias];
  }

  Map<DateTime, List<AppMedia>> _sortMedias({required List<AppMedia> medias}) {
    medias.sort((a, b) => (b.createdTime ?? DateTime.now())
        .compareTo(a.createdTime ?? DateTime.now()));
    return groupBy<AppMedia, DateTime>(
      medias,
      (AppMedia media) =>
          media.createdTime?.dateOnly ?? DateTime.now().dateOnly,
    );
  }

  List<AppMedia> _removeGoogleDriveRefFromMedias(
      Map<DateTime, List<AppMedia>> medias) {
    final allMedias = medias.values.expand((element) => element).toList();
    for (int index = 0; index < allMedias.length; index++) {
      if (allMedias[index].sources.length > 1) {
        allMedias[index] = allMedias[index].copyWith(
          sources: allMedias[index].sources.toList()
            ..remove(AppMediaSource.googleDrive),
          thumbnailLink: null,
        );
      } else if (allMedias.contains(AppMediaSource.googleDrive)) {
        allMedias.removeAt(index);
      }
    }
    return allMedias;
  }

  @override
  Future<void> dispose() async {
    await _googleAccountSubscription?.cancel();
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
    @Default([]) List<UploadProgress> uploadingMedias,
  }) = _HomeViewState;
}
