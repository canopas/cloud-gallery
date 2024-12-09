import '../models/dropbox/account/dropbox_account.dart';
import '../models/dropbox/token/dropbox_token.dart';
import 'provider/preferences_provider.dart';

class AppPreferences {
  static final isOnBoardComplete = createPrefProvider<bool>(
    prefKey: "is_onboard_complete",
    defaultValue: false,
  );

  static final isDarkMode = createPrefProvider<bool?>(
    prefKey: "is_dark_mode",
    defaultValue: null,
  );

  static final notifications = createPrefProvider<bool>(
    prefKey: "show_notifications",
    defaultValue: true,
  );

  static final googleDriveAutoBackUp = createPrefProvider<bool>(
    prefKey: "google_drive_auto_backup",
    defaultValue: false,
  );

  static final dropboxAutoBackUp = createPrefProvider<bool>(
    prefKey: "dropbox_auto_backup",
    defaultValue: false,
  );

  static final signInHintShown = createPrefProvider<bool>(
    prefKey: "sign_in_hint_shown",
    defaultValue: false,
  );

  static final dropboxToken = createEncodedPrefProvider<DropboxToken>(
    prefKey: "dropbox_token",
    toJson: (value) => value.toJson(),
    fromJson: (json) => DropboxToken.fromJson(json),
  );

  static final dropboxCurrentUserAccount =
      createEncodedPrefProvider<DropboxAccount>(
    prefKey: "dropbox_current_user_account",
    toJson: (value) => value.toJson(),
    fromJson: (json) => DropboxAccount.fromJson(json),
  );

  static final dropboxFileIdAppPropertyTemplateId = createPrefProvider<String?>(
    prefKey: "dropbox_file_id_app_property_template_id",
    defaultValue: null,
  );

  static final dropboxPKCECodeVerifier = createPrefProvider<String?>(
    prefKey: "dropbox_code_verifier",
    defaultValue: null,
  );
}
