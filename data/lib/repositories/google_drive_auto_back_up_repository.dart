import 'dart:async';
import 'package:data/services/auth_service.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../storage/app_preferences.dart';

final autoBackUpRepoProvider = Provider<GoogleDriveAutoBackUpRepo>((ref) {
  final authService = ref.read(authServiceProvider);
  final repo = GoogleDriveAutoBackUpRepo(
    ref.read(googleDriveServiceProvider),
    ref.read(localMediaServiceProvider),
    authService,
    ref.read(AppPreferences.canTakeAutoBackUpInGoogleDrive),
    authService.googleAccount,
  );
  final subscription =
      ref.listen(AppPreferences.canTakeAutoBackUpInGoogleDrive, (_, next) {
    repo.updateGoogleDriveAutoBackUpStatus(value: next);
  });
  ref.onDispose(() {
    subscription.close();
    repo.dispose();
  });
  return repo;
});

class GoogleDriveAutoBackUpRepo {
  final GoogleDriveService _googleDriveService;
  final LocalMediaService _localMediaService;
  final AuthService _authService;
  GoogleSignInAccount? _googleAccount;
  StreamSubscription? _googleAccountSubscription;
  bool _googleDriveAutoBackUpStatus;

  GoogleDriveAutoBackUpRepo(
      this._googleDriveService,
      this._localMediaService,
      this._authService,
      this._googleDriveAutoBackUpStatus,
      this._googleAccount) {
    _googleAccountSubscription =
        _authService.onGoogleAccountChange.listen((googleAccount) {
      _googleAccount = googleAccount;
    });
  }

  Future<void> updateGoogleDriveAutoBackUpStatus({required bool value}) async {
    _googleDriveAutoBackUpStatus = value;
  }



  Future<void> autoBackUp() async {
    if (_googleAccount == null || !_googleDriveAutoBackUpStatus) {
      return;
    }
    final hasAccess = await _localMediaService.requestPermission();
    if (!hasAccess) return;
    final backUpFolderId = await _googleDriveService.getBackupFolderId();
    if (backUpFolderId == null) return;

    final mediaCount = await _localMediaService.getMediaCount();
    final localMedias =
        await _localMediaService.getLocalMedia(start: 0, end: mediaCount);
    print("localMedias: $localMedias");
    final googleDriveMedias = await _googleDriveService.getDriveMedias(
        backUpFolderId: backUpFolderId);
    final Set<String> googleDrivePaths =
        googleDriveMedias.map((media) => media.path).toSet();
    final uploadingMedias = localMedias
        .where((localMedia) => !googleDrivePaths.contains(localMedia.path))
        .toList();
    for (final media in uploadingMedias) {
      await _googleDriveService.uploadInGoogleDrive(
        media: media,
        folderID: backUpFolderId,
      );
    }
  }

  Future<void> dispose() async {
    _googleAccountSubscription?.cancel();
    _googleAccount = null;
  }
}
