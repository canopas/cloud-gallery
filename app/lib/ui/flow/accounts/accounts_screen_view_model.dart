import 'package:data/services/auth_service.dart';
import 'package:data/services/device_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'accounts_screen_view_model.freezed.dart';

final accountsStateNotifierProvider =
    StateNotifierProvider.autoDispose<AccountsStateNotifier, AccountsState>(
  (ref) => AccountsStateNotifier(
    ref.read(deviceServiceProvider),
    ref.read(authServiceProvider),
  ),
);

class AccountsStateNotifier extends StateNotifier<AccountsState> {
  final DeviceService _deviceService;
  final AuthService _authService;

  AccountsStateNotifier(
    this._deviceService,
    this._authService,
  ) : super(AccountsState(googleAccount: _authService.user));

  Future<void> init() async {
    _getAppVersion();
  }

  Future<void> signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
      state = state.copyWith(googleAccount: _authService.user);
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> signOutWithGoogle() async {
    try {
      await _authService.signOutWithGoogle();
      state = state.copyWith(googleAccount: _authService.user);
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> _getAppVersion() async {
    final version = await _deviceService.version;
    state = state.copyWith(version: version);
  }

  void setAutoBackUp(bool value) {
    state = state.copyWith(autoBackUp: value);
  }
}

@freezed
class AccountsState with _$AccountsState {
  const factory AccountsState({
    String? version,
    Object? error,
    GoogleSignInAccount? googleAccount,
    @Default(false) bool autoBackUp,
  }) = _AccountsState;
}
