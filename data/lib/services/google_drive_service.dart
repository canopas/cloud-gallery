import 'dart:async';
import 'dart:io';
import '../apis/google_drive/google_drive_endpoint.dart';
import '../apis/network/client.dart';
import '../domain/config.dart';
import '../models/media/media.dart';
import '../models/media_content/media_content.dart';
import 'package:dio/dio.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import '../errors/app_error.dart';
import 'auth_service.dart';
import 'cloud_provider_service.dart';

final googleDriveServiceProvider = Provider<GoogleDriveService>(
  (ref) => GoogleDriveService(
    ref.read(googleSignInProvider),
    ref.read(googleAuthenticatedDioProvider),
  ),
);

class GoogleDriveService extends CloudProviderService {
  final Dio _client;
  final GoogleSignIn _googleSignIn;

  GoogleDriveService(this._googleSignIn, this._client);

  Future<drive.DriveApi> _getGoogleDriveAPI() async {
    if (_googleSignIn.currentUser == null) {
      throw const UserGoogleSignInAccountNotFound();
    }
    final client = await _googleSignIn.authenticatedClient();
    final api = drive.DriveApi(client!);
    client.close();
    return api;
  }

  Future<List<AppMedia>> getDriveMedias({
    required String backUpFolderId,
  }) async {
    try {
      final driveApi = await _getGoogleDriveAPI();

      final response = await driveApi.files.list(
        q: "'$backUpFolderId' in parents and trashed=false",
        $fields:
            "files(id, name, description, mimeType, thumbnailLink, webContentLink, createdTime, modifiedTime, size, imageMediaMetadata, videoMediaMetadata)",
      );

      return (response.files ?? [])
          .map(
            (e) => AppMedia.fromGoogleDriveFile(e),
          )
          .toList();
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  Future<AppMedia> updateMediaDescription(String id, String description) async {
    try {
      final driveApi = await _getGoogleDriveAPI();
      final file = drive.File(description: description);
      final updatedFile = await driveApi.files.update(file, id);
      return AppMedia.fromGoogleDriveFile(updatedFile);
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
      final driveApi = await _getGoogleDriveAPI();
      await driveApi.files.delete(id);
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  @override
  Future<String?> getBackUpFolderId() async {
    try {
      final driveApi = await _getGoogleDriveAPI();

      final response = await driveApi.files.list(
        q: "name='${FolderPath.backupFolderName}' and trashed=false and mimeType='application/vnd.google-apps.folder'",
      );

      if (response.files?.isNotEmpty ?? false) {
        return response.files?.first.id;
      } else {
        final folder = drive.File(
          name: FolderPath.backupFolderName,
          mimeType: 'application/vnd.google-apps.folder',
        );
        final googleDriveFolder = await driveApi.files.create(folder);
        return googleDriveFolder.id;
      }
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  @override
  Future<String?> createFolder(String folderName) async {
    try {
      final driveApi = await _getGoogleDriveAPI();

      final folder = drive.File(
        name: folderName,
        mimeType: 'application/vnd.google-apps.folder',
      );
      final googleDriveFolder = await driveApi.files.create(folder);
      return googleDriveFolder.id;
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  @override
  Future<AppMedia> uploadMedia({
    required String folderId,
    required String path,
    String? description,
    String? mimeType,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
  }) async {
    final localFile = File(path);
    try {
      final file = drive.File(
        name: localFile.path.split('/').last,
        mimeType: mimeType,
        description: description,
        parents: [folderId],
      );

      final res = await _client.req(
        UploadGoogleDriveFile(
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

      return AppMedia.fromGoogleDriveFile(drive.File.fromJson(res.data));
    } catch (error) {
      if (error is AppError && error.statusCode == 404) {
        throw const BackUpFolderNotFound();
      }
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
      await _client.downloadReq(
        DownloadGoogleDriveFileContent(
          id: id,
          cancellationToken: cancelToken,
          saveLocation: saveLocation,
          onProgress: onProgress,
        ),
      );
    } catch (e) {
      throw AppError.fromError(e);
    }
  }
}
