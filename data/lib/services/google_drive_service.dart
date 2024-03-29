import 'dart:io';
import 'package:data/models/media/media.dart';
import 'package:data/models/media_content/media_content.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import '../errors/app_error.dart';
import 'auth_service.dart';

final googleDriveServiceProvider = Provider<GoogleDriveService>(
  (ref) => GoogleDriveService(ref.read(googleSignInProvider)),
);

class GoogleDriveService {
  final String _backUpFolderName = "Cloud Gallery Backup";

  final GoogleSignIn _googleSignIn;

  const GoogleDriveService(this._googleSignIn);

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
        q: "name='$_backUpFolderName' and trashed=false and mimeType='application/vnd.google-apps.folder'",
      );

      if (response.files?.isNotEmpty ?? false) {
        return response.files?.first.id;
      } else {
        final folder = drive.File(
          name: _backUpFolderName,
          mimeType: 'application/vnd.google-apps.folder',
        );
        final googleDriveFolder = await driveApi.files.create(folder);
        return googleDriveFolder.id;
      }
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  Future<List<AppMedia>> getDriveMedias(
      {required String backUpFolderId}) async {
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

  Future<void> uploadInGoogleDrive(
      {required String folderID, required AppMedia media}) async {
    final localFile = File(media.path);
    try {
      final driveApi = await _getGoogleDriveAPI();

      final file = drive.File(
        name: media.name ?? localFile.path.split('/').last,
        description: media.path,
        parents: [folderID],
      );
      await driveApi.files.create(
        file,
        uploadMedia: drive.Media(localFile.openRead(), localFile.lengthSync()),
      );
    } catch (error) {
      if (error is drive.DetailedApiRequestError && error.status == 404) {
        throw const BackUpFolderNotFound();
      }
      throw AppError.fromError(error);
    }
  }

  Future<AppMediaContent> fetchMediaBytes(String mediaId) async {
    final api = await _getGoogleDriveAPI();
    final media = await api.files.get(mediaId,
        downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
    return AppMediaContent.fromGoogleDrive(media);
  }
}
