import 'package:data/storage/provider/preferences_provider.dart';

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

  static final canTakeAutoBackUpInGoogleDrive = createPrefProvider<bool>(
    prefKey: "google_drive_auto_backup",
    defaultValue: false,
  );

  static final googleDriveSignInHintShown = createPrefProvider<bool>(
    prefKey: "google_drive_sign_in_hint_shown",
    defaultValue: false,
  );

  static final googleDriveAutoBackUpHintShown = createPrefProvider<bool>(
    prefKey: "google_drive_sign_in_hint_shown",
    defaultValue: false,
  );
}
