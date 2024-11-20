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

final googleDriveServiceProvider = Provider<GoogleDriveService>(
  (ref) => GoogleDriveService(
    ref.read(googleSignInProvider),
    ref.read(googleAuthenticatedDioProvider),
  ),
);

class GoogleDriveService {
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

  Future<String?> getBackupFolderId() async {
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

  Future<void> deleteMedia(String id) async {
    try {
      final driveApi = await _getGoogleDriveAPI();
      await driveApi.files.delete(id);
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  Future<AppMedia> uploadInGoogleDrive({
    required String folderID,
    required AppMedia media,
    CancelToken? cancelToken,
    void Function(int chunk, int total)? onProgress,
  }) async {
    final localFile = File(media.path);
    try {
      final file = drive.File(
        name: media.name ?? localFile.path.split('/').last,
        mimeType: media.mimeType,
        description: media.id,
        parents: [folderID],
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

  Future<void> downloadFromGoogleDrive({
    required String id,
    required String saveLocation,
    void Function(int chunk, int total)? onProgress,
    CancelToken? cancelToken,
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
