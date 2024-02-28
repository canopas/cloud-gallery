import 'package:data/models/media/media.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_media_screen_view_model.freezed.dart';

final localMediasViewStateNotifier = StateNotifierProvider.autoDispose<
    LocalMediasViewStateNotifier, LocalMediasViewState>(
  (ref) => LocalMediasViewStateNotifier(
    ref.read(localMediaServiceProvider),
    ref.read(googleDriveServiceProvider),
    ref.read(authServiceProvider),
  ),
);

class LocalMediasViewStateNotifier extends StateNotifier<LocalMediasViewState> {
  final LocalMediaService _localMediaService;
  final GoogleDriveService _googleDriveService;
  final AuthService _authService;

  bool _loading = false;

  LocalMediasViewStateNotifier(
      this._localMediaService, this._googleDriveService, this._authService)
      : super(const LocalMediasViewState());

  Future<void> loadMediaCount() async {
    try {
      state = state.copyWith(error: null);
      final hasAccess = await _localMediaService.requestPermission();
      if (hasAccess) {
        final count = await _localMediaService.getMediaCount();
        state = state.copyWith(
          mediaCount: count,
          hasLocalMediaAccess: hasAccess,
        );
      } else {
        state = state.copyWith(hasLocalMediaAccess: hasAccess);
      }
    } catch (error) {
      state = state.copyWith(error: error);
    }
  }

  Future<void> loadMedia({bool append = false}) async {
    if (_loading == true) return;
    _loading = true;
    try {
      state = state.copyWith(loading: state.medias.isEmpty, error: null);
      final medias = await _localMediaService.getMedia(
        start: append ? state.medias.length : 0,
        end: append
            ? state.medias.length + 20
            : state.medias.length < 20
                ? 20
                : state.medias.length,
      );
      state = state.copyWith(
        medias: [...state.medias, ...medias],
        loading: false,
      );
    } catch (error) {
      state = state.copyWith(error: error, loading: false);
    }
    _loading = false;
  }

  void mediaSelection(AppMedia media) {
    final selectedMedias = state.selectedMedias;
    if (selectedMedias.contains(media)) {
      state = state.copyWith(
        selectedMedias: selectedMedias.toList()..remove(media),
        error: null,
      );
    } else {
      state = state.copyWith(
        selectedMedias: [...selectedMedias, media],
        error: null,
      );
    }
  }

  Future<void> uploadMediaOnGoogleDrive() async {
    try {
      if (_authService.getUser == null) {
        await _authService.signInWithGoogle();
      }
      state =
          state.copyWith(uploadingMedias: state.selectedMedias, error: null);
      final folderId = await _googleDriveService.getBackupFolderId();

      for (final media in state.selectedMedias) {
        await _googleDriveService.uploadInGoogleDrive(
            media: media, folderID: folderId!);
      }
      state = state.copyWith(uploadingMedias: [], selectedMedias: []);
    } catch (error) {
      state = state.copyWith(error: error, uploadingMedias: []);
    }
  }
}

@freezed
class LocalMediasViewState with _$LocalMediasViewState {
  const factory LocalMediasViewState({
    @Default(false) bool loading,
    @Default([]) List<AppMedia> uploadingMedias,
    @Default([]) List<AppMedia> medias,
    @Default([]) List<AppMedia> selectedMedias,
    @Default(0) int mediaCount,
    @Default(false) hasLocalMediaAccess,
    Object? error,
  }) = _LocalMediasViewState;
}
