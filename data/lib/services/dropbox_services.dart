import 'dart:io';
import '../apis/dropbox/dropbox_content_endpoints.dart';
import '../apis/network/client.dart';
import '../domain/config.dart';
import '../errors/app_error.dart';
import '../models/dropbox/account/dropbox_account.dart';
import '../models/media/media.dart';
import '../models/media_content/media_content.dart';
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
    ref.read(AppPreferences.dropboxFileIdAppPropertyTemplateId.notifier),
  );
});

class DropboxService extends CloudProviderService {
  final Dio _dropboxAuthenticatedDio;
  final PreferenceNotifier<DropboxAccount?> _dropboxAccountController;
  final PreferenceNotifier<String?>
      _dropboxFileIdAppPropertyTemplateIdController;

  const DropboxService(
    this._dropboxAuthenticatedDio,
    this._dropboxAccountController,
    this._dropboxFileIdAppPropertyTemplateIdController,
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

  Future<void> setFileIdAppPropertyTemplate() async {
    try {
      final res = await _dropboxAuthenticatedDio
          .req(const DropboxGetAppPropertyTemplate());
      if (res.data['template_id'] != null &&
          res.data['template_id'] is List<String>) {
        _dropboxFileIdAppPropertyTemplateIdController.state =
            (res.data['template_id'] as List<String>).first;
      } else {
        final res = await _dropboxAuthenticatedDio
            .req(const DropboxCreateAppPropertyTemplate());
        _dropboxFileIdAppPropertyTemplateIdController.state =
            res.data['template_id'];
      }
    } catch (e) {
      AppError.fromError(e);
    }
  }

  @override
  Future<List<AppMedia>> getAllMedias({
    required String folder,
  }) async {
    try {
      if (_dropboxFileIdAppPropertyTemplateIdController.state == null) {
        await setFileIdAppPropertyTemplate();
      }
      bool hasMore = true;
      String? nextPageToken;
      final List<AppMedia> medias = [];

      while (hasMore) {
        final response = await _dropboxAuthenticatedDio.req(
          nextPageToken == null
              ? DropboxListFolderEndpoint(
                  folderPath: folder,
                  limit: 2000,
                  appPropertyTemplateId:
                      _dropboxFileIdAppPropertyTemplateIdController.state!,
                )
              : DropboxListFolderContinueEndpoint(cursor: nextPageToken),
        );
        if (response.statusCode == 200) {
          hasMore = response.data['has_more'] == true;
          nextPageToken = response.data['cursor'];
          medias.addAll(
            (response.data['entries'] as List)
                .where((element) => element['.tag'] == 'file')
                .map((e) => AppMedia.fromDropboxJson(e))
                .toList(),
          );
        } else {
          throw AppError.fromError(response.statusMessage ?? '');
        }
      }

      return medias;
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  @override
  Future<GetPaginatedMediasResponse> getPaginatedMedias({
    required String folder,
    String? nextPageToken,
    int pageSize = 30,
  }) async {
    if (_dropboxFileIdAppPropertyTemplateIdController.state == null) {
      await setFileIdAppPropertyTemplate();
    }
    try {
      final response = await _dropboxAuthenticatedDio.req(
        nextPageToken == null
            ? DropboxListFolderEndpoint(
                folderPath: folder,
                limit: pageSize,
                appPropertyTemplateId:
                    _dropboxFileIdAppPropertyTemplateIdController.state!,
              )
            : DropboxListFolderContinueEndpoint(cursor: nextPageToken),
      );
      if (response.statusCode == 200) {
        final files = (response.data['entries'] as List).where(
          (element) => element['.tag'] == 'file',
        );

        return GetPaginatedMediasResponse(
          medias: files.map((e) => AppMedia.fromDropboxJson(e)).toList(),
          nextPageToken: response.data['has_more'] == true
              ? response.data['cursor']
              : null,
        );
      }
      throw AppError.fromError(response.statusMessage ?? '');
    } catch (e) {
      throw AppError.fromError(e);
    }
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
    String? localRefId,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
  }) async {
    if (_dropboxFileIdAppPropertyTemplateIdController.state == null) {
      await setFileIdAppPropertyTemplate();
    }
    final localFile = File(path);
    try {
      final res = await _dropboxAuthenticatedDio.req(
        DropboxUploadEndpoint(
          appPropertyTemplateId:
              _dropboxFileIdAppPropertyTemplateIdController.state!,
          localRefId: localRefId,
          content: AppMediaContent(
            stream: localFile.openRead(),
            length: localFile.lengthSync(),
            contentType: 'application/octet-stream',
          ),
          filePath:
              "/${ProviderConstants.backupFolderName}/${localFile.path.split('/').last}",
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
          filePath: id,
          storagePath: saveLocation,
          cancellationToken: cancelToken,
          onProgress: onProgress,
        ),
      );
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  Future<void> updateAppProperties({
    required String id,
    required String localRefId,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dropboxAuthenticatedDio.req(
        DropboxUpdateAppPropertyEndpoint(
          id: id,
          cancellationToken: cancelToken,
          appPropertyTemplateId:
              _dropboxFileIdAppPropertyTemplateIdController.state!,
          localRefId: localRefId,
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

class DropboxMediaListResponse {
  final List<AppMedia> medias;
  final String? cursor;

  const DropboxMediaListResponse({
    required this.medias,
    required this.cursor,
  });
}
