import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as google_drive;

final googleSignInProvider = Provider(
  (ref) => GoogleSignIn(
    scopes: [google_drive.DriveApi.driveScope],
  ),
);

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.read(googleSignInProvider)),
);

class AuthService {
  final GoogleSignIn _googleSignIn;

  AuthService(this._googleSignIn) {
    _googleSignIn.signInSilently(suppressErrors: true);
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        await googleSignInAccount.authentication;
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<void> signOutWithGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      rethrow;
    }
  }

  bool get hasUserSigned => _googleSignIn.currentUser != null;

  GoogleSignInAccount? get user => _googleSignIn.currentUser;
}
