import 'dart:async';
import 'package:data/models/media_process/media_process.dart';
import 'package:data/repositories/media_process_repository.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/services/device_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:data/storage/provider/preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'accounts_screen_view_model.freezed.dart';

final accountsStateNotifierProvider =
    StateNotifierProvider.autoDispose<AccountsStateNotifier, AccountsState>(
  (ref) => AccountsStateNotifier(
    ref.read(deviceServiceProvider),
    ref.read(authServiceProvider),
    ref.read(AppPreferences.dropboxAutoBackUp.notifier),
    ref.read(AppPreferences.googleDriveAutoBackUp.notifier),
    ref.read(mediaProcessRepoProvider),
  ),
);

class AccountsStateNotifier extends StateNotifier<AccountsState> {
  final DeviceService _deviceService;
  final AuthService _authService;
  final PreferenceNotifier<bool?> _autoBackupInGoogleDriveController;
  final PreferenceNotifier<bool?> _autoBackupInDropboxController;
  final MediaProcessRepo _mediaProcessRepo;
  StreamSubscription? _googleAccountSubscription;

  AccountsStateNotifier(
    this._deviceService,
    this._authService,
    this._autoBackupInDropboxController,
    this._autoBackupInGoogleDriveController,
    this._mediaProcessRepo,
  ) : super(AccountsState(googleAccount: _authService.googleAccount));

  Future<void> init() async {
    _getAppVersion();
    _googleAccountSubscription =
        _authService.onGoogleAccountChange.listen((event) {
      updateUser(event);
    });
  }

  @override
  void dispose() {
    _googleAccountSubscription?.cancel();
    super.dispose();
  }

  void updateUser(GoogleSignInAccount? account) {
    state = state.copyWith(googleAccount: account);
  }

  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(error: null);
      await _authService.signInWithGoogle();
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> signOutWithGoogle() async {
    try {
      state = state.copyWith(error: null);
      await _authService.signOutWithGoogle();
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> signInWithDropbox() async {
    try {
      state = state.copyWith(error: null);
      await _authService.signInWithDropBox();
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> signOutWithDropbox() async {
    try {
      state = state.copyWith(error: null);
      await _authService.signOutWithDropBox();
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> toggleAutoBackupInGoogleDrive(bool value) async {
    _autoBackupInGoogleDriveController.state = value;

    if (value) {
      _mediaProcessRepo.autoBackupInGoogleDrive();
    } else {
      _mediaProcessRepo.stopAutoBackup(MediaProvider.googleDrive);
    }
  }

  Future<void> toggleAutoBackupInDropbox(bool value) async {
    _autoBackupInDropboxController.state = value;

    if (value) {
      _mediaProcessRepo.autoBackupInDropbox();
    } else {
      _mediaProcessRepo.stopAutoBackup(MediaProvider.dropbox);
    }
  }

  Future<void> _getAppVersion() async {
    final version = await _deviceService.version;
    state = state.copyWith(version: version);
  }
}

@freezed
class AccountsState with _$AccountsState {
  const factory AccountsState({
    String? version,
    Object? error,
    GoogleSignInAccount? googleAccount,
  }) = _AccountsState;
}
