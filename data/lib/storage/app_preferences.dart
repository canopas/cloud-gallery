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

  static StateProvider<bool> canTakeAutoBackUpInGoogleDrive =
      createPrefProvider<bool>(
    prefKey: "google_drive_auto_backup",
    defaultValue: false,
  );

  static StateProvider<bool> googleDriveSignInHintShown =
      createPrefProvider<bool>(
    prefKey: "google_drive_sign_in_hint_shown",
    defaultValue: false,
  );

  static StateProvider<bool> googleDriveAutoBackUpHintShown =
      createPrefProvider<bool>(
    prefKey: "google_drive_sign_in_hint_shown",
    defaultValue: false,
  );
}
