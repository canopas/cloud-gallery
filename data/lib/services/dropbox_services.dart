import '../apis/network/client.dart';
import '../errors/app_error.dart';
import '../models/dropbox_account/dropbox_account.dart';
import '../storage/app_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../apis/dropbox/dropbox_auth_endpoints.dart';
import '../storage/provider/preferences_provider.dart';

final dropboxServiceProvider = Provider<DropboxService>((ref) {
  return DropboxService(
    ref.read(dropboxAuthenticatedDioProvider),
    ref.read(AppPreferences.dropboxCurrentUserAccount.notifier),
  );
});

class DropboxService {
  final Dio _dropboxAuthenticatedDio;
  final PreferenceNotifier<DropboxAccount?> _dropboxAccountController;

  const DropboxService(
    this._dropboxAuthenticatedDio,
    this._dropboxAccountController,
  );

  Future<void> setCurrentUserAccount() async {
    try {
      final res = await _dropboxAuthenticatedDio
          .req(const DropboxGetUserAccountEndpoint());
      _dropboxAccountController.state = DropboxAccount.fromJson(res.data);
    } catch (e) {
      AppError.fromError(e);
    }
  }
}
