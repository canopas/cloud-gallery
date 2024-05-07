import 'dart:async';
import 'package:data/apis/network/client.dart';
import 'package:data/apis/network/oauth2.dart';
import 'package:data/errors/app_error.dart';
import 'package:data/models/dropbox_account/dropbox_account.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as google_drive;
import 'package:url_launcher/url_launcher.dart';
import '../apis/dropbox/dropbox_auth_endpoints.dart';
import '../apis/network/secrets.dart';
import '../apis/network/urls.dart';
import '../models/token/token.dart';

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
    ref.read(rawDioProvider),
    ref.read(oauth2Provider),
    ref.read(AppPreferences.dropboxToken.notifier),
    ref.read(AppPreferences.dropboxPKCECodeVerifier.notifier),
    ref.read(AppPreferences.dropboxCurrentUserAccount.notifier),
    ref.read(AppPreferences.googleDriveAutoBackUp.notifier),
    ref.read(AppPreferences.dropboxAutoBackUp.notifier),
  ),
);

class AuthService {
  final GoogleSignIn _googleSignIn;
  final Oauth2 _oauth2;
  final Dio _dio;
  final StateController<DropboxToken?> _dropboxTokenController;
  final StateController<DropboxAccount?> _dropboxAccountController;
  final StateController<String?> _dropboxCodeVerifierPrefProvider;
  final StateController<bool> _googleDriveAutoBackUpController;
  final StateController<bool> _dropboxAutoBackUpController;

  AuthService(
    this._googleSignIn,
    this._dio,
    this._oauth2,
    this._dropboxTokenController,
    this._dropboxCodeVerifierPrefProvider,
    this._dropboxAccountController,
    this._googleDriveAutoBackUpController,
    this._dropboxAutoBackUpController,
  ) {
    signInSilently();
  }

  Future<void> signInSilently() async {
    try {
      await _googleSignIn.signInSilently(suppressErrors: true);
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        await googleSignInAccount.authentication;
      }
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  Future<void> signOutWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      _googleDriveAutoBackUpController.state = false;
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  /// Launches the URL in the browser for OAuth 2 authentication with Dropbox.
  /// Retrieves the access token using the Proof of Key Code Exchange (PKCE) flow.
  Future<void> signInWithDropBox() async {
    try {
      final codeVerifier = _oauth2.generateCodeVerifier;
      _dropboxCodeVerifierPrefProvider.state = codeVerifier;
      final authorizationUrl = _oauth2.getAuthorizationUrl(
        clientId: AppSecretes.dropBoxAppKey,
        authorizationEndpoint:
            Uri.parse('${BaseURL.dropboxOAuth2Web}/authorize'),
        additionalParameters: {'token_access_type': 'offline'},
        redirectUri: RedirectURL.auth,
        codeVerifier: codeVerifier,
      );
      await launchUrl(authorizationUrl);
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  Future<void> setDropboxTokenFromCode({required String code}) async {
    try {
      if (_dropboxCodeVerifierPrefProvider.state == null) {
        throw const SomethingWentWrongError(
            message: "Dropbox code verifier is missing");
      }
      final res = await _dio.req(
        DropboxTokenEndpoint(
          code: code,
          codeVerifier: _dropboxCodeVerifierPrefProvider.state!,
          clientId: AppSecretes.dropBoxAppKey,
          redirectUrl: RedirectURL.auth,
          clientSecret: AppSecretes.dropBoxAppSecret,
        ),
      );
      if (res.data != null) {
        _dropboxTokenController.state = DropboxToken.fromJson(res.data);
        _dropboxCodeVerifierPrefProvider.state = null;
      }
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  Future<void> signOutWithDropBox() async {
    _dropboxTokenController.state = null;
    _dropboxAccountController.state = null;
    _dropboxAutoBackUpController.state = false;
  }

  Future<void> refreshDropboxToken() async {
    try {
      if (_dropboxTokenController.state != null) {
        final res = await _dio.req(
          DropboxRefreshTokenEndpoint(
            refreshToken: _dropboxTokenController.state!.refresh_token,
            clientId: AppSecretes.dropBoxAppKey,
            clientSecret: AppSecretes.dropBoxAppSecret,
          ),
        );
        final newToken = DropboxToken.fromJson(res.data);
        _dropboxTokenController.state = _dropboxTokenController.state!.copyWith(
            access_token: newToken.access_token,
            expires_in: newToken.expires_in,
            token_type: newToken.token_type);
      } else {
        throw const AuthSessionExpiredError();
      }
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  bool get signedInWithGoogle => _googleSignIn.currentUser != null;

  GoogleSignInAccount? get googleAccount => _googleSignIn.currentUser;

  Stream<GoogleSignInAccount?> get onGoogleAccountChange =>
      _googleSignIn.onCurrentUserChanged;
}
