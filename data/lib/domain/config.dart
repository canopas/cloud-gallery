class ProviderConstants {
  static const String albumFileName = 'Album.json';
  static const String backupFolderName = 'Cloud Gallery Backup';
  static const String backupFolderPath = '/Cloud Gallery Backup';
  static const String localRefIdKey = 'local_ref_id';
  static const String dropboxAppTemplateName =
      'Cloud Gallery Local File Information';
}

class LocalDatabaseConstants {
  static const String databaseName = 'cloud-gallery.db';
  static const String albumDatabaseName = 'cloud-gallery-album.db';
  static const String uploadQueueTable = 'UploadQueue';
  static const String downloadQueueTable = 'DownloadQueue';
  static const String albumsTable = 'Albums';
  static const String cleanUpTable = 'CleanUp';
}

class FeatureFlag {
  static final googleDriveSupport = true;
}
