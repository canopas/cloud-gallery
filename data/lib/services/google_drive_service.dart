import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'auth_service.dart';

final googleDriveServiceProvider = Provider<GoogleDriveService>(
  (ref) => GoogleDriveService(ref.read(googleSignInProvider)),
);

class GoogleDriveService {
  final GoogleSignIn _googleSignIn;

  const GoogleDriveService(this._googleSignIn);

  Future<void> getDriveFiles() async {
    print("Getting drive files..");
    if (_googleSignIn.currentUser != null) {
      print("currentUser: ${_googleSignIn.currentUser}");
      final client = await _googleSignIn.authenticatedClient();
      print("client: $client");
      print("client is null: ${client == null}");
      final driveApi = drive.DriveApi(client!);
      try {
        final files = await driveApi.files.list();
        print(files.toJson());
      } catch (e) {
        print("Error: $e");
      }
    } else {
      print("currentUser: null");
    }
  }
}
