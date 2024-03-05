import 'dart:async';

import 'package:data/models/media/media.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style/extensions/list_extensions.dart';

part 'home_screen_view_model.freezed.dart';

final homeViewStateNotifier =
    StateNotifierProvider.autoDispose<HomeViewStateNotifier, HomeViewState>(
  (ref) => HomeViewStateNotifier(
    ref.read(localMediaServiceProvider),
    ref.read(googleDriveServiceProvider),
    ref.read(authServiceProvider),
  ),
);

class HomeViewStateNotifier extends StateNotifier<HomeViewState> {
  final GoogleDriveService _googleDriveService;
  final AuthService _authService;
  final LocalMediaService _localMediaService;

  String? _backUpFolderId;
  List<AppMedia> _localMedias = [];
  int _localMediaCount = 0;
  List<AppMedia> _googleDriveMedias = [];

  HomeViewStateNotifier(
      this._localMediaService, this._googleDriveService, this._authService)
      : super(const HomeViewState()) {
    loadMedias();
  }

  Future<void> loadMedias() async {
    state = state.copyWith(loading: state.medias.isEmpty, error: null);
    try {
      final counts = await _loadMediaCount();
      if (counts != null) {
        await Future.wait([
          _getGoogleDriveMedias(),
          _loadLocalMedias(),
        ]);
      } else {
        await _getGoogleDriveMedias();
      }
      state = state.copyWith(
        loading: false,
        medias: _sortMedia(),
        hasLocalMediaAccess: counts != null,
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error);
    }
  }

  List<AppMedia> _sortMedia() {
    final commonMedias = <AppMedia>[];

    for (AppMedia localMedia in _localMedias.toList()) {
      _googleDriveMedias
          .toList()
          .where((element) => element.path == localMedia.path)
          .forEach((googleDriveMedia) {
        _googleDriveMedias
            .removeWhere((media) => media.id == googleDriveMedia.id);
        _localMedias.removeWhere((media) => media.id == localMedia.id);
        commonMedias.add(localMedia.copyWith(
            sources: [AppMediaSource.local, AppMediaSource.googleDrive],
            thumbnailPath: googleDriveMedia.thumbnailPath));
      });
    }

    List<AppMedia> shortedMedia = [
      ..._localMedias,
      ..._googleDriveMedias,
      ...commonMedias
    ];

    shortedMedia.sort((a, b) => (b.createdTime ?? DateTime.now())
        .compareTo(a.createdTime ?? DateTime.now()));
    return shortedMedia;
  }

  Future<void> _getGoogleDriveMedias() async {
    if(_authService.hasUserSigned){
      _backUpFolderId ??= await _googleDriveService.getBackupFolderId();
      _googleDriveMedias = await _googleDriveService.getDriveMedias(
          backUpFolderId: _backUpFolderId!);
    }
  }

  Future<int?> _loadMediaCount() async {
    final hasAccess = await _localMediaService.requestPermission();
    if (hasAccess) {
      _localMediaCount = await _localMediaService.getMediaCount();
      return _localMediaCount;
    }
    return null;
  }

  Future<void> _loadLocalMedias() async {
    _localMedias = await _localMediaService.getLocalMedia(
      start: 0,
      end: _localMediaCount,
    );
  }

  void mediaSelection(AppMedia media) {
    final selectedMedias = state.selectedMedias.toList();
    if (selectedMedias.contains(media.id)) {
      state = state.copyWith(
        selectedMedias: selectedMedias.toList()..remove(media.id),
        error: null,
      );
    } else {
      state = state.copyWith(
        selectedMedias: [...selectedMedias, media.id],
        error: null,
      );
    }
  }

  Future<void> uploadMediaOnGoogleDrive() async {
    try {
      if (!_authService.hasUserSigned) {
        await _authService.signInWithGoogle();
      }
      List<AppMedia> uploadingMedias = state.medias
          .where((element) =>
              state.selectedMedias.contains(element.id) &&
              !element.sources.contains(AppMediaSource.googleDrive))
          .toList();

      state = state.copyWith(
          uploadingMedias: uploadingMedias.map((e) => e.id).toList(),
          error: null);
      final folderId = await _googleDriveService.getBackupFolderId();

      for (final media in uploadingMedias) {
        await _googleDriveService.uploadInGoogleDrive(
          media: media,
          folderID: folderId!,
        );
        state = state.copyWith(
          medias: state.medias.toList()
            ..updateElement(
              newElement: media.copyWith(
                  sources: media.sources.toList()
                    ..add(AppMediaSource.googleDrive)),
              oldElement: media,
            ),
          uploadingMedias: state.uploadingMedias.toList()..remove(media.id),
        );
      }

      state = state.copyWith(uploadingMedias: [], selectedMedias: []);
    } catch (error) {
      state = state.copyWith(error: error, uploadingMedias: []);
    }
  }
}

@freezed
class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    Object? error,
    @Default(false) bool hasLocalMediaAccess,
    @Default(false) bool loading,
    @Default([]) List<AppMedia> medias,
    @Default([]) List<String> selectedMedias,
    @Default([]) List<String> uploadingMedias,
  }) = _HomeViewState;
}
