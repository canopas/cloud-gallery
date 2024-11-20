import 'package:collection/collection.dart';
import '../apis/dropbox/dropbox_content_endpoints.dart';
import '../apis/network/client.dart';
import '../domain/config.dart';
import '../errors/app_error.dart';
import '../models/dropbox_account/dropbox_account.dart';
import '../storage/app_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../apis/dropbox/dropbox_auth_endpoints.dart';
import '../storage/provider/preferences_provider.dart';
import 'cloud_provider_service.dart';

final dropboxServiceProvider = Provider<DropboxService>((ref) {
  return DropboxService(
    ref.read(dropboxAuthenticatedDioProvider),
    ref.read(AppPreferences.dropboxCurrentUserAccount.notifier),
  );
});

class DropboxService extends CloudProviderService {
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

  @override
  Future<String?> getBackUpFolderId() async {
    final response = await _dropboxAuthenticatedDio.req(
      DropboxListFolderEndpoint(folderPath: ''),
    );
    if (response.statusCode == 200) {
      final folderExists = (response.data['entries'] as List).firstWhereOrNull(
        (element) =>
            element['.tag'] == 'folder' &&
            element['name'] == FolderPath.backupFolderName,
      );
      if (folderExists == null) {
        return createFolder(FolderPath.backupFolderName);
      }
      return folderExists['id'];
    }
    throw AppError.fromError(response.statusMessage ?? '');
  }

  @override
  Future<String> createFolder(String folderName) async {
    final response = await _dropboxAuthenticatedDio.req(
      DropboxCreateFolderEndpoint(name: folderName),
    );

    if (response.statusCode == 200) {
      return response.data['metadata']['id'];
    }

    throw AppError.fromError(response.statusMessage ?? '');
  }
}
