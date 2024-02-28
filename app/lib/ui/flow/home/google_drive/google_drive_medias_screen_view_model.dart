import 'package:data/models/media/media.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_drive_medias_screen_view_model.freezed.dart';

final googleDriveMediasStateNotifierProvider = StateNotifierProvider
    .autoDispose<GoogleDriveMediasStateNotifier, GoogleDriveMediasViewState>(
  (ref) => GoogleDriveMediasStateNotifier(
    ref.read(googleDriveServiceProvider),
    ref.read(authServiceProvider),
  ),
);

class GoogleDriveMediasStateNotifier
    extends StateNotifier<GoogleDriveMediasViewState> {
  final GoogleDriveService _googleDriveService;
  final AuthService _authService;

  String? _backupFolderId;

  GoogleDriveMediasStateNotifier(this._googleDriveService, this._authService)
      : super(GoogleDriveMediasViewState(
          isSignedIn: _authService.hasUserSigned,
        ));

  Future<void> init() async {
    if (_authService.hasUserSigned) {
      getGoogleDriveMedias();
    }
  }


  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(loading: true, error: null);
      await _authService.signInWithGoogle();
      state = state.copyWith(loading: false, isSignedIn: true);
      getGoogleDriveMedias();
    } catch (error) {
      state = state.copyWith(loading: false, error: error);
    }
  }

  Future<void> getGoogleDriveMedias() async {
    try {
      _backupFolderId ??= await _googleDriveService.getBackupFolderId();
      if (_backupFolderId != null) {
        state = state.copyWith(loading: true, error: null);
        final medias = await _googleDriveService.getDriveMedias(
            backUpFolderId: _backupFolderId!);
        state = state.copyWith(loading: false, medias: medias);
      }
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }
}

@freezed
class GoogleDriveMediasViewState with _$GoogleDriveMediasViewState {
  const factory GoogleDriveMediasViewState({
    @Default(false) bool loading,
    @Default([]) List<AppMedia> medias,
    required bool isSignedIn,
    Object? error,
  }) = _GoogleDriveMediasViewState;
}
