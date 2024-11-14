import 'dart:async';
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
    ref.read(AppPreferences.canTakeAutoBackUpInGoogleDrive.notifier),
  ),
);

class AccountsStateNotifier extends StateNotifier<AccountsState> {
  final DeviceService _deviceService;
  final AuthService _authService;
  StreamSubscription? _googleAccountSubscription;
  PreferenceNotifier<bool> canTakeAutoBackUpInGoogleDrive;

  AccountsStateNotifier(
    this._deviceService,
    this._authService,
    this.canTakeAutoBackUpInGoogleDrive,
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
      await _authService.signInWithGoogle();
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> signOutWithGoogle() async {
    try {
      await _authService.signOutWithGoogle();
      canTakeAutoBackUpInGoogleDrive.state = false;
    } catch (e) {
      state = state.copyWith(error: e);
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
