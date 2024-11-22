import 'dart:io';
import 'package:collection/collection.dart';
import '../apis/dropbox/dropbox_content_endpoints.dart';
import '../apis/network/client.dart';
import '../domain/config.dart';
import '../errors/app_error.dart';
import '../models/dropbox/account/dropbox_account.dart';
import '../models/media/media.dart';
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

  @override
  Future<AppMedia> uploadMedia({
    required String folderId,
    required String path,
    String? mimeType,
    String? description,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
  }) async {
    final localFile = File(path);
    try {
      final res = await _dropboxAuthenticatedDio.req(
        DropboxUploadEndpoint(
          contentStream: localFile.openRead(),
          filePath:
              "/${FolderPath.backupFolderName}/${localFile.path.split('/').last}",
          onProgress: onProgress,
          cancellationToken: cancelToken,
        ),
      );
      if (res.statusCode == 200) {
        return AppMedia.fromDropboxJson(res.data);
      }
      throw AppError.fromError(res.statusMessage ?? '');
    } catch (error) {
      throw AppError.fromError(error);
    }
  }

  @override
  Future<void> downloadMedia({
    required String id,
    required String saveLocation,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
  }) async {
    try {
      await _dropboxAuthenticatedDio.downloadReq(
        DropboxDownloadEndpoint(
          filePath: "id:$id",
          storagePath: saveLocation,
          cancellationToken: cancelToken,
          onProgress: onProgress,
        ),
      );
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  @override
  Future<void> deleteMedia({
    required String id,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dropboxAuthenticatedDio.req(
        DropboxDeleteEndpoint(
          id: id,
          cancellationToken: cancelToken,
        ),
      );
      if (res.statusCode == 200) return;

      throw AppError.fromError(res.statusMessage ?? '');
    } catch (e) {
      throw AppError.fromError(e);
    }
  }
}
