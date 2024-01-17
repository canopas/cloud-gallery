import 'package:data/services/auth_service.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_screen_view_model.freezed.dart';

final mainScreenViewNotifierProvider = StateNotifierProvider.autoDispose<
    MainScreenViewNotifier, MainScreenViewState>(
  (ref) => MainScreenViewNotifier(
    ref.watch(authServiceProvider),
    ref.read(googleDriveServiceProvider)
  ),
);

class MainScreenViewNotifier extends StateNotifier<MainScreenViewState> {
  MainScreenViewNotifier(
    this._authService,
      this._googleDriveService,
  ) : super(const MainScreenViewState());

  final AuthService _authService;
  final GoogleDriveService _googleDriveService;

  Future<void> getFiles() async {
    try {
      await _authService.signInWithGoogle();
      await _googleDriveService.getDriveFiles();
    } catch (error) {
      state = state.copyWith(error: error);
    }
  }
}

@freezed
class MainScreenViewState with _$MainScreenViewState {
  const factory MainScreenViewState({
    Object? error,
  }) = _MainScreenViewState;
}
