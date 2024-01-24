import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/photoslibrary/v1.dart' as google_photos;

import 'auth_service.dart';

final googlePhotosServiceProvider = Provider<GooglePhotosService>(
  (ref) => GooglePhotosService(
    ref.read(googleSignInProvider),
  ),
);

class GooglePhotosService {
  final GoogleSignIn _googleSignIn;

  const GooglePhotosService(this._googleSignIn);

  Future<void> createAlbum() async {
    if (_googleSignIn.currentUser == null) return;
    final client = await _googleSignIn.authenticatedClient();
    final photosLibraryApi = google_photos.PhotosLibraryApi(client!);
    final album = google_photos.Album(
      title: "Cloud Gallery",
      isWriteable: true,
    );
    await photosLibraryApi.albums
        .create(google_photos.CreateAlbumRequest(album: album));

    ///TODO: Steps after create albums
  }

}
