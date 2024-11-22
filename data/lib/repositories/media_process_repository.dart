import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../errors/app_error.dart';
import '../models/media/media.dart';
import '../models/media/media_extension.dart';
import '../models/media_process/media_process.dart';
import '../services/dropbox_services.dart';
import '../services/google_drive_service.dart';
import '../services/local_media_service.dart';

final mediaProcessRepoProvider = Provider<MediaProcessRepo>((ref) {
  return MediaProcessRepo(
    ref.read(googleDriveServiceProvider),
    ref.read(dropboxServiceProvider),
    ref.read(localMediaServiceProvider),
  );
});

class LocalDatabaseConstants {
  static const String databaseName = 'cloud-gallery.db';
  static const String uploadQueueTable = 'UploadQueue';
  static const String downloadQueueTable = 'DownloadQueue';
}

class MediaProcessRepo extends ChangeNotifier {
  final GoogleDriveService _googleDriveService;
  final DropboxService _dropboxService;
  final LocalMediaService _localMediaService;

  late Database database;

  List<UploadMediaProcess> _uploadQueue = [];
  List<DownloadMediaProcess> _downloadQueue = [];

  List<UploadMediaProcess> get uploadQueue => _uploadQueue;

  List<DownloadMediaProcess> get downloadQueue => _downloadQueue;

  bool _uploadQueueIsRunning = false;
  bool _downloadQueueIsRunning = false;

  MediaProcessRepo(
    this._googleDriveService,
    this._dropboxService,
    this._localMediaService,
  ) {
    initializeLocalDatabase();
  }

  Future<void> initializeLocalDatabase() async {
    database = await openDatabase(
      LocalDatabaseConstants.databaseName,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE ${LocalDatabaseConstants.uploadQueueTable} ('
          'id TEXT PRIMARY KEY, '
          'folder_id TEXT NOT NULL, '
          'provider TEXT NOT NULL, '
          'path TEXT NOT NULL, '
          'status TEXT NOT NULL, '
          'upload_using_auto_backup INTEGER NOT NULL, '
          'mime_type TEXT, '
          'total INTEGER NOT NULL, '
          'chunk INTEGER NOT NULL'
          ')',
        );
        await db.execute(
          'CREATE TABLE ${LocalDatabaseConstants.downloadQueueTable} ('
          'id TEXT PRIMARY KEY, '
          'folder_id TEXT NOT NULL, '
          'provider TEXT NOT NULL, '
          'local_path TEXT NOT NULL, '
          'status TEXT NOT NULL, '
          'extension TEXT NOT NULL, '
          'total INTEGER NOT NULL, '
          'chunk INTEGER NOT NULL'
          ')',
        );
      },
      onOpen: updateQueue,
    );
  }

  void autoBackupInGoogleDrive() async {
    final backUpFolderId = await _googleDriveService.getBackUpFolderId();

    if (backUpFolderId == null) {
      throw BackUpFolderNotFound();
    }

    final res = await Future.wait([
      _localMediaService.getAllLocalMedia(),
      _googleDriveService.getDriveMedias(
        backUpFolderId: backUpFolderId,
      ),
    ]);

    final localMedias = res[0];
    final dgMedias = res[1];

    for (AppMedia localMedia in localMedias.toList()) {
      if (_uploadQueue
              .where((element) => element.id == localMedia.id)
              .isNotEmpty ||
          dgMedias
              .where((gdMedia) => gdMedia.path == localMedia.id)
              .isNotEmpty) {
        localMedias.removeWhere((media) => media.id == localMedia.id);
      }
    }

    uploadMedia(
      medias: localMedias,
      folderId: backUpFolderId,
      provider: MediaProvider.googleDrive,
      uploadUsingAutoBackup: true,
    );
  }

  void autoBackupInDropbox() async {
    final backUpFolderId = await _googleDriveService.getBackUpFolderId();

    if (backUpFolderId == null) {
      throw BackUpFolderNotFound();
    }

    final res = await Future.wait([
      _localMediaService.getAllLocalMedia(),
      _googleDriveService.getDriveMedias(
        backUpFolderId: backUpFolderId,
      ),
    ]);

    final localMedias = res[0];
    final dgMedias = res[1];

    for (AppMedia localMedia in localMedias.toList()) {
      if (_uploadQueue
          .where((element) => element.id == localMedia.id)
          .isNotEmpty ||
          dgMedias
              .where((gdMedia) => gdMedia.path == localMedia.id)
              .isNotEmpty) {
        localMedias.removeWhere((media) => media.id == localMedia.id);
      }
    }

    uploadMedia(
      medias: localMedias,
      folderId: backUpFolderId,
      provider: MediaProvider.googleDrive,
      uploadUsingAutoBackup: true,
    );
  }

  void uploadMedia({
    required List<AppMedia> medias,
    required String folderId,
    required MediaProvider provider,
    bool uploadUsingAutoBackup = false,
  }) async {
    for (AppMedia media in medias) {
      await database.insert(
        LocalDatabaseConstants.uploadQueueTable,
        UploadMediaProcess(
          id: media.id,
          folder_id: folderId,
          provider: provider,
          path: media.path,
          upload_using_auto_backup: uploadUsingAutoBackup,
          mime_type: media.mimeType,
        ).toJson(),
      );
    }

    updateQueue(database);
    runUploadQueue();
  }

  void downloadMedia({
    required List<AppMedia> medias,
    required String folderId,
    required MediaProvider provider,
  }) async {
    for (AppMedia media in medias) {
      await database.insert(
        LocalDatabaseConstants.downloadQueueTable,
        DownloadMediaProcess(
          id: media.id,
          folder_id: folderId,
          provider: provider,
          extension: media.extension,
        ).toJson(),
      );
    }
    updateQueue(database);
    runDownloadQueue();
  }

  Future<void> updateQueue(Database db) async {
    final res = await Future.wait([
      db.query(LocalDatabaseConstants.uploadQueueTable),
      db.query(LocalDatabaseConstants.downloadQueueTable),
    ]);

    _uploadQueue = res[0].map((e) => UploadMediaProcess.fromJson(e)).toList();
    _downloadQueue =
        res[1].map((e) => DownloadMediaProcess.fromJson(e)).toList();

    notifyListeners();
  }

  Future<void> runUploadQueue() async {
    if (_uploadQueueIsRunning) return;
    _uploadQueueIsRunning = true;
    while (_uploadQueue.firstOrNull != null) {
      if (_uploadQueue.first.provider == MediaProvider.googleDrive) {
        _uploadInGoogleDrive(_uploadQueue.first);
      } else if (_uploadQueue.first.provider == MediaProvider.dropbox) {
        _uploadInDropbox(_uploadQueue.first);
      } else {
        _updateUploadQueue(
          _uploadQueue.first.copyWith(status: MediaQueueProcessStatus.failed),
        );
      }
    }
    _uploadQueueIsRunning = false;
  }

  Future<UploadMediaProcess> _updateUploadQueue(
    UploadMediaProcess process,
  ) async {
    await database.update(
      LocalDatabaseConstants.uploadQueueTable,
      process.toJson(),
      where: 'id = ?',
      whereArgs: [process.id],
    );
    await updateQueue(database);
    return _uploadQueue.firstWhere((element) => element.id == process.id);
  }

  void _uploadInGoogleDrive(UploadMediaProcess uploadProcess) async {
    UploadMediaProcess process = uploadProcess;
    try {
      process = process.copyWith(status: MediaQueueProcessStatus.uploading);
      process = await _updateUploadQueue(process);

      final cancelToken = CancelToken();

      await _googleDriveService.uploadMedia(
        folderId: process.folder_id,
        path: process.path,
        mimeType: process.mime_type,
        description: process.id,
        onProgress: (chunk, total) async {
          if (process.status.isTerminated) {
            cancelToken.cancel();
          }
          process = process.copyWith(total: total, chunk: chunk);
          process = await _updateUploadQueue(process);
        },
        cancelToken: cancelToken,
      );
      process = process.copyWith(status: MediaQueueProcessStatus.completed);
      process = await _updateUploadQueue(process);
    } catch (e) {
      if (e is RequestCancelledByUser) return;
      process = process.copyWith(status: MediaQueueProcessStatus.failed);
      process = await _updateUploadQueue(process);
      return;
    }
  }

  void _uploadInDropbox(UploadMediaProcess uploadProcess) async {
    UploadMediaProcess process = uploadProcess;
    try {
      process = process.copyWith(status: MediaQueueProcessStatus.uploading);
      process = await _updateUploadQueue(process);

      final cancelToken = CancelToken();

      await _dropboxService.uploadMedia(
        folderId: process.folder_id,
        path: process.path,
        mimeType: process.mime_type,
        description: process.id,
        onProgress: (chunk, total) async {
          if (process.status.isTerminated) {
            cancelToken.cancel();
          }
          process = process.copyWith(total: total, chunk: chunk);
          process = await _updateUploadQueue(process);
        },
        cancelToken: cancelToken,
      );
      process = process.copyWith(status: MediaQueueProcessStatus.completed);
      process = await _updateUploadQueue(process);
    } catch (e) {
      if (e is RequestCancelledByUser) return;
      process = process.copyWith(status: MediaQueueProcessStatus.failed);
      process = await _updateUploadQueue(process);
      return;
    }
  }

  Future<void> runDownloadQueue() async {
    if (_downloadQueueIsRunning) return;
    _downloadQueueIsRunning = true;
    while (_downloadQueue.firstOrNull != null) {
      if (_downloadQueue.first.provider == MediaProvider.googleDrive) {
        _downloadFromGoogleDrive(_downloadQueue.first);
      } else if (_downloadQueue.first.provider == MediaProvider.dropbox) {
        _downloadFromDropbox(_downloadQueue.first);
      } else {
        await _updateDownloadQueue(
          _downloadQueue.first.copyWith(status: MediaQueueProcessStatus.failed),
        );
      }
    }
    _downloadQueueIsRunning = false;
  }

  Future<DownloadMediaProcess> _updateDownloadQueue(
    DownloadMediaProcess process,
  ) async {
    await database.update(
      LocalDatabaseConstants.downloadQueueTable,
      process.toJson(),
      where: 'id = ?',
      whereArgs: [process.id],
    );
    await updateQueue(database);
    return _downloadQueue.firstWhere((element) => element.id == process.id);
  }

  Future<void> _downloadFromGoogleDrive(
    DownloadMediaProcess downloadProcess,
  ) async {
    DownloadMediaProcess process = downloadProcess;
    String? tempFileLocation;
    try {
      process = process.copyWith(status: MediaQueueProcessStatus.downloading);
      process = await _updateDownloadQueue(process);

      final tempDir = await getTemporaryDirectory();
      tempFileLocation = "${tempDir.path}/${process.id}.${process.extension}";

      final cancelToken = CancelToken();

      await _googleDriveService.downloadMedia(
        id: process.id,
        saveLocation: tempFileLocation,
        onProgress: (received, total) async {
          if (process.status.isTerminated) {
            cancelToken.cancel();
          }
          process = process.copyWith(total: total, chunk: received);
          process = await _updateDownloadQueue(process);
        },
        cancelToken: cancelToken,
      );

      final localMedia = await _localMediaService.saveInGallery(
        saveFromLocation: tempFileLocation,
        type: AppMediaType.fromLocation(location: tempFileLocation),
      );

      if (localMedia == null) {
        process = process.copyWith(status: MediaQueueProcessStatus.failed);
        process = await _updateDownloadQueue(process);
      }

      //TODO: update local ref in media

      process = process.copyWith(status: MediaQueueProcessStatus.completed);
      process = await _updateDownloadQueue(process);
    } catch (error) {
      if (error is RequestCancelledByUser) {
        return;
      }
      process = process.copyWith(status: MediaQueueProcessStatus.failed);
      process = await _updateDownloadQueue(process);
    } finally {
      if (tempFileLocation != null) {
        await File(tempFileLocation).delete();
      }
    }
  }

  Future<void> _downloadFromDropbox(
    DownloadMediaProcess downloadProcess,
  ) async {
    DownloadMediaProcess process = downloadProcess;
    String? tempFileLocation;
    try {
      process = process.copyWith(status: MediaQueueProcessStatus.downloading);
      process = await _updateDownloadQueue(process);

      final tempDir = await getTemporaryDirectory();
      tempFileLocation = "${tempDir.path}/${process.id}.${process.extension}";

      final cancelToken = CancelToken();

      await _dropboxService.downloadMedia(
        id: process.id,
        saveLocation: tempFileLocation,
        onProgress: (received, total) async {
          if (process.status.isTerminated) {
            cancelToken.cancel();
          }
          process = process.copyWith(total: total, chunk: received);
          process = await _updateDownloadQueue(process);
        },
        cancelToken: cancelToken,
      );

      final localMedia = await _localMediaService.saveInGallery(
        saveFromLocation: tempFileLocation,
        type: AppMediaType.fromLocation(location: tempFileLocation),
      );

      if (localMedia == null) {
        process = process.copyWith(status: MediaQueueProcessStatus.failed);
        process = await _updateDownloadQueue(process);
      }

      //TODO: update local ref in media

      process = process.copyWith(status: MediaQueueProcessStatus.completed);
      process = await _updateDownloadQueue(process);
    } catch (error) {
      if (error is RequestCancelledByUser) {
        return;
      }
      process = process.copyWith(status: MediaQueueProcessStatus.failed);
      process = await _updateDownloadQueue(process);
    } finally {
      if (tempFileLocation != null) {
        await File(tempFileLocation).delete();
      }
    }
  }
}
