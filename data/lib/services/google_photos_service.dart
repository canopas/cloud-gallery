import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/photoslibrary/v1.dart' as google_photos;

import '../errors/app_error.dart';
import 'auth_service.dart';

final googlePhotosServiceProvider = Provider<GooglePhotosService>(
  (ref) => GooglePhotosService(
    ref.read(googleSignInProvider),
  ),
);

class GooglePhotosService {
  final GoogleSignIn _googleSignIn;

  const GooglePhotosService(this._googleSignIn);

  Future<google_photos.PhotosLibraryApi> getGooglePhotosApi() async {
    if (_googleSignIn.currentUser == null) {
      throw const UserGoogleSignInAccountNotFound();
    }
    final client = await _googleSignIn.authenticatedClient();
    return google_photos.PhotosLibraryApi(client!);
  }
}
