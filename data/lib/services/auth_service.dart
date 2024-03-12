import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as google_drive;

final googleUserAccountProvider = StateProvider<GoogleSignInAccount?>((ref) {
  final googleSignIn = ref.read(googleSignInProvider);
  googleSignIn.signInSilently(suppressErrors: true);
  final subscription = googleSignIn.onCurrentUserChanged.listen((account) {
    ref.controller.state = account;
  });
  ref.onDispose(() async {
    await subscription.cancel();
  });
  return googleSignIn.currentUser;
});

final googleSignInProvider = Provider(
  (ref) => GoogleSignIn(
    scopes: [google_drive.DriveApi.driveScope],
  ),
);

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(
    ref.read(googleSignInProvider),
  ),
);

class AuthService {
  final GoogleSignIn _googleSignIn;

  AuthService(this._googleSignIn) {
    signInSilently();
  }

  Future<void> signInSilently() async {
    try {
      await _googleSignIn.signInSilently(suppressErrors: true);
    } catch (_) {
      rethrow;
    }
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

  bool get signedInWithGoogle => _googleSignIn.currentUser != null;

  GoogleSignInAccount? get googleAccount => _googleSignIn.currentUser;

  Stream<GoogleSignInAccount?> get onGoogleAccountChange =>
      _googleSignIn.onCurrentUserChanged;
}
