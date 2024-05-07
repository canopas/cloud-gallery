import 'package:data/apis/network/client.dart';
import 'package:data/errors/app_error.dart';
import 'package:data/models/dropbox_account/dropbox_account.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../apis/dropbox/dropbox_auth_endpoints.dart';

final dropboxServiceProvider = Provider<DropboxService>((ref) {
  return DropboxService(
    ref.read(dropboxAuthenticatedDioProvider),
    ref.read(AppPreferences.dropboxCurrentUserAccount.notifier),
  );
});

class DropboxService {
  final Dio _dropboxAuthenticatedDio;
  final StateController<DropboxAccount?> _dropboxAccountController;

  const DropboxService(
      this._dropboxAuthenticatedDio, this._dropboxAccountController);

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
