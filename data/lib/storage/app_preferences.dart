import 'package:data/models/dropbox_account/dropbox_account.dart';
import 'package:data/models/token/token.dart';
import 'package:data/storage/provider/preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppPreferences {
  static StateProvider<bool> isOnBoardComplete = createPrefProvider<bool>(
    prefKey: "is_onboard_complete",
    defaultValue: false,
  );

  static StateProvider<bool?> isDarkMode = createPrefProvider<bool?>(
    prefKey: "is_dark_mode",
    defaultValue: null,
  );

  static StateProvider<bool> notifications = createPrefProvider<bool>(
    prefKey: "show_notifications",
    defaultValue: true,
  );

  static StateProvider<bool> googleDriveAutoBackUp = createPrefProvider<bool>(
    prefKey: "google_drive_auto_backup",
    defaultValue: false,
  );

  static StateProvider<bool> dropboxAutoBackUp = createPrefProvider<bool>(
    prefKey: "dropbox_auto_backup",
    defaultValue: false,
  );

  static StateProvider<bool> signInHintShown = createPrefProvider<bool>(
    prefKey: "sign_in_hint_shown",
    defaultValue: false,
  );

  static StateProvider<DropboxToken?> dropboxToken =
      createEncodedPrefProvider<DropboxToken>(
    prefKey: "dropbox_token",
    toJson: (value) => value.toJson(),
    fromJson: (json) => DropboxToken.fromJson(json),
  );

  static StateProvider<DropboxAccount?> dropboxCurrentUserAccount =
      createEncodedPrefProvider<DropboxAccount>(
    prefKey: "dropbox_current_user_account",
    toJson: (value) => value.toJson(),
    fromJson: (json) => DropboxAccount.fromJson(json),
  );

  static StateProvider<String?> dropboxPKCECodeVerifier =
      createPrefProvider<String?>(
    prefKey: "dropbox_code_verifier",
    defaultValue: null,
  );
}
