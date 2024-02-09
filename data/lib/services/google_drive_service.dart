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

  init(){
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        getDriveFiles();
      }
    });
  }

  Future<void> getDriveFiles() async {
    if (_googleSignIn.currentUser != null) {
      final client = await _googleSignIn.authenticatedClient();
      final driveApi = drive.DriveApi(client!);
      await driveApi.files.list();
    }
  }
}
