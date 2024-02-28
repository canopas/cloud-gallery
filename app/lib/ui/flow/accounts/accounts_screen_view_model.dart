import 'package:data/services/device_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounts_screen_view_model.freezed.dart';

final accountsStateNotifierProvider = Provider((ref) => AccountsStateNotifier(
      ref.read(deviceServiceProvider),
    ));

class AccountsStateNotifier extends StateNotifier<AccountsState> {
  final DeviceService _deviceService;

  AccountsStateNotifier(this._deviceService) : super(const AccountsState());

  Future<void> init() async {
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final version = await _deviceService.version;
    state = state.copyWith(version: version);
  }
}

@freezed
class AccountsState with _$AccountsState {
  const factory AccountsState({
    @Default(false) bool loading,
    @Default(null) String? version,
    @Default(null) Object? error,
  }) = _AccountsState;
}
