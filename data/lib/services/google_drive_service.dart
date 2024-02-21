import 'dart:io';
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
  final GoogleSignIn _googleSignIn;

  const GoogleDriveService(this._googleSignIn);

  Future<String?> createFolder() async {
    try {
      if (_googleSignIn.currentUser != null) {
        final client = await _googleSignIn.authenticatedClient();
        final driveApi = drive.DriveApi(client!);
        final folder = drive.File(
          name: "Cloud Gallery Backup",
          mimeType: "application/vnd.google-apps.folder",
        );
        final googleDriveFolder = await driveApi.files.create(folder);
        return googleDriveFolder.id;
      } else {
        throw const UserGoogleSignInAccountNotFound();
      }
    } catch (error) {
      throw AppError.fromError(error);
    }
  }

  Future<void> uploadInGoogleDrive(
      {required String folderID, required File localFile}) async {
    try {
      if (_googleSignIn.currentUser != null) {
        final client = await _googleSignIn.authenticatedClient();
        final driveApi = drive.DriveApi(client!);
        final file = drive.File(
          name: localFile.path.split('/').last,
          parents: [folderID],
        );

        await driveApi.files.create(
          file,
          uploadMedia:
              drive.Media(localFile.openRead(), localFile.lengthSync()),
        );
      } else {
        throw const UserGoogleSignInAccountNotFound();
      }
    } catch (error) {
      throw AppError.fromError(error);
    }
  }
}
