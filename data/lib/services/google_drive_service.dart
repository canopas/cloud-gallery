import 'dart:async';
import 'dart:io';
import '../apis/google_drive/google_drive_endpoint.dart';
import '../apis/network/client.dart';
import '../domain/config.dart';
import '../models/media/media.dart';
import '../models/media_content/media_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import '../errors/app_error.dart';
import 'base/cloud_provider_service.dart';

final googleDriveServiceProvider = Provider<GoogleDriveService>(
  (ref) => GoogleDriveService(
    ref.read(googleAuthenticatedDioProvider),
  ),
);

class GoogleDriveService extends CloudProviderService {
  final Dio _client;

  GoogleDriveService(this._client);

  @override
  Future<List<AppMedia>> getAllMedias({
    required String folder,
  }) async {
    bool hasMore = true;
    String? pageToken;
    final List<AppMedia> medias = [];

    while (hasMore) {
      final res = await _client.req(
        GoogleDriveListEndpoint(
          q: "'$folder' in parents and trashed=false",
          pageSize: 1000,
          pageToken: pageToken,
        ),
      );

      if (res.statusCode == 200) {
        final body = drive.FileList.fromJson(res.data);
        hasMore = body.nextPageToken != null;
        pageToken = body.nextPageToken;
        medias.addAll(
          body.files
                  ?.map(
                    (e) => AppMedia.fromGoogleDriveFile(e),
                  )
                  .toList() ??
              <AppMedia>[],
        );
      } else {
        throw SomethingWentWrongError(
          statusCode: res.statusCode,
          message: res.statusMessage,
        );
      }
    }

    return medias;
  }

  @override
  Future<GetPaginatedMediasResponse> getPaginatedMedias({
    required String folder,
    String? nextPageToken,
    int pageSize = 30,
  }) async {
    final res = await _client.req(
      GoogleDriveListEndpoint(
        q: "'$folder' in parents and trashed=false",
        pageSize: pageSize,
        pageToken: nextPageToken,
      ),
    );

    if (res.statusCode == 200) {
      final body = drive.FileList.fromJson(res.data);
      return GetPaginatedMediasResponse(
        nextPageToken: body.nextPageToken,
        medias: body.files
                ?.map(
                  (e) => AppMedia.fromGoogleDriveFile(e),
                )
                .toList() ??
            <AppMedia>[],
      );
    }

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  @override
  Future<void> deleteMedia({
    required String id,
    CancelToken? cancelToken,
  }) async {
    final res = await _client.req(GoogleDriveDeleteEndpoint(id: id));

    if (res.statusCode == 200 || res.statusCode == 204) return;

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  Future<String?> getBackUpFolderId() async {
    final res = await _client.req(
      GoogleDriveListEndpoint(
        q: "name='${ProviderConstants.backupFolderName}' and trashed=false and mimeType='application/vnd.google-apps.folder'",
        pageSize: 1,
      ),
    );

    if (res.statusCode == 200) {
      final body = drive.FileList.fromJson(res.data);
      if (body.files?.isNotEmpty ?? false) {
        return body.files?.first.id;
      } else {
        final createRes = await _client.req(
          GoogleDriveCreateFolderEndpoint(
            name: ProviderConstants.backupFolderName,
          ),
        );

        if (createRes.statusCode == 200) {
          return drive.File.fromJson(createRes.data).id;
        }

        throw SomethingWentWrongError(
          statusCode: createRes.statusCode,
          message: createRes.statusMessage,
        );
      }
    }

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  @override
  Future<String?> createFolder(String folderName) async {
    final res = await _client.req(
      GoogleDriveCreateFolderEndpoint(name: folderName),
    );

    if (res.statusCode == 200) {
      return drive.File.fromJson(res.data).id;
    }

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  @override
  Future<AppMedia> uploadMedia({
    required String folderId,
    required String path,
    String? localRefId,
    String? mimeType,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
  }) async {
    final localFile = File(path);
    final file = drive.File(
      name: localFile.path.split('/').last,
      mimeType: mimeType,
      appProperties: {
        ProviderConstants.localRefIdKey: localRefId,
      },
      parents: [folderId],
    );

    final res = await _client.req(
      GoogleDriveUploadEndpoint(
        request: file,
        content: AppMediaContent(
          stream: localFile.openRead(),
          length: localFile.lengthSync(),
          contentType: 'application/octet-stream',
        ),
        onProgress: onProgress,
        cancellationToken: cancelToken,
      ),
    );

    if (res.statusCode == 200) {
      return AppMedia.fromGoogleDriveFile(drive.File.fromJson(res.data));
    }

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  @override
  Future<void> downloadMedia({
    required String id,
    required String saveLocation,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
  }) async {
    final res = await _client.downloadReq(
      GoogleDriveDownloadEndpoint(
        id: id,
        cancellationToken: cancelToken,
        saveLocation: saveLocation,
        onProgress: onProgress,
      ),
    );

    if (res.statusCode == 200) return;

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  Future<void> updateAppProperties({
    required String id,
    required String localRefId,
    CancelToken? cancelToken,
  }) async {
    final res = await _client.req(
      GoogleDriveUpdateAppPropertiesEndpoint(
        id: id,
        localFileId: localRefId,
      ),
    );

    if (res.statusCode == 200) return;

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }
}
