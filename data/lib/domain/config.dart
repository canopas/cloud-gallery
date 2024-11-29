import 'package:flutter/foundation.dart';

class FeatureFlags {
  static const dropboxEnabled = kDebugMode;
}

class ProviderConstants {
  static const String backupFolderName = 'Cloud Gallery Backup';
  static const String backupFolderPath = '/Cloud Gallery Backup';
  static const String localRefIdKey = 'local_ref_id';
}
