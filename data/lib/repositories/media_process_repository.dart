import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../domain/config.dart';
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
          'media_id TEXT NOT NULL, '
          'folder_id TEXT NOT NULL, '
          'provider TEXT NOT NULL, '
          'path TEXT NOT NULL, '
          'status TEXT NOT NULL, '
          'upload_using_auto_backup INTEGER NOT NULL, '
          'notification_id INTEGER NOT NULL, '
          'response TEXT, '
          'mime_type TEXT, '
          'total INTEGER NOT NULL, '
          'chunk INTEGER NOT NULL'
          ')',
        );
        await db.execute(
          'CREATE TABLE ${LocalDatabaseConstants.downloadQueueTable} ('
          'id TEXT PRIMARY KEY, '
          'media_id TEXT NOT NULL, '
          'folder_id TEXT NOT NULL, '
          'provider TEXT NOT NULL, '
          'local_path TEXT NOT NULL, '
          'status TEXT NOT NULL, '
          'extension TEXT NOT NULL, '
          'notification_id INTEGER NOT NULL, '
          'response TEXT, '
          'total INTEGER NOT NULL, '
          'chunk INTEGER NOT NULL'
          ')',
        );
      },
      onOpen: (Database db) async {
        await updateQueue(db);
        runUploadAutoBackupQueue();
        runDownloadQueue();
      },
    );
  }

  void autoBackupInGoogleDrive() async {
    final backUpFolderId = await _googleDriveService.getBackUpFolderId();

    if (backUpFolderId == null) {
      throw BackUpFolderNotFound();
    }

    final res = await Future.wait([
      _localMediaService.getAllLocalMedia(),
      _googleDriveService.getAllMedias(folder: backUpFolderId),
    ]);

    final localMedias = res[0];
    final dgMedias = res[1];

    for (AppMedia localMedia in localMedias.toList()) {
      if (_uploadQueue
              .where((element) => element.media_id == localMedia.id)
              .isNotEmpty ||
          dgMedias
              .where((gdMedia) => gdMedia.path == localMedia.id)
              .isNotEmpty) {
        localMedias.removeWhere((media) => media.id == localMedia.id);
      }
    }

    for (AppMedia media in localMedias) {
      await database.insert(
        LocalDatabaseConstants.uploadQueueTable,
        UploadMediaProcess(
          id: UniqueKey().toString(),
          media_id: media.id,
          folder_id: backUpFolderId,
          provider: MediaProvider.googleDrive,
          notification_id: _generateUniqueUploadNotificationId(),
          path: media.path,
          upload_using_auto_backup: true,
          mime_type: media.mimeType,
        ).toJson(),
      );
    }
    await updateQueue(database);
    runUploadAutoBackupQueue();
  }

  Future<void> autoBackupInDropbox() async {
    final res = await Future.wait([
      _localMediaService.getAllLocalMedia(),
      _dropboxService.getAllMedias(folder: ProviderConstants.backupFolderPath),
    ]);

    final localMedias = res[0];
    final dropboxMedias = res[1];

    for (AppMedia localMedia in localMedias.toList()) {
      if (_uploadQueue
              .where((element) => element.media_id == localMedia.id)
              .isNotEmpty ||
          dropboxMedias
              .where((gdMedia) => gdMedia.path == localMedia.id)
              .isNotEmpty) {
        localMedias.removeWhere((media) => media.id == localMedia.id);
      }
    }

    for (AppMedia media in localMedias) {
      await database.insert(
        LocalDatabaseConstants.uploadQueueTable,
        UploadMediaProcess(
          id: UniqueKey().toString(),
          media_id: media.id,
          folder_id: ProviderConstants.backupFolderPath,
          provider: MediaProvider.dropbox,
          notification_id: _generateUniqueUploadNotificationId(),
          path: media.path,
          upload_using_auto_backup: true,
          mime_type: media.mimeType,
        ).toJson(),
      );
    }
    await updateQueue(database);
    runUploadAutoBackupQueue();
  }

  int _generateUniqueUploadNotificationId() {
    int baseId = Random().nextInt(9999999);
    while (_uploadQueue.any((element) => element.notification_id == baseId)) {
      baseId = Random().nextInt(9999999);
    }
    return baseId;
  }

  void uploadMedia({
    required List<AppMedia> medias,
    required String folderId,
    required MediaProvider provider,
  }) async {
    for (AppMedia media in medias) {
      await database.insert(
        LocalDatabaseConstants.uploadQueueTable,
        UploadMediaProcess(
          id: UniqueKey().toString(),
          media_id: media.id,
          folder_id: folderId,
          provider: provider,
          notification_id: _generateUniqueUploadNotificationId(),
          path: media.path,
          upload_using_auto_backup: false,
          mime_type: media.mimeType,
        ).toJson(),
      );
    }
    await updateQueue(database);
    runUploadQueue();
  }

  int _generateUniqueDownloadNotificationId() {
    int baseId = Random().nextInt(9999999);
    while (_downloadQueue.any((element) => element.notification_id == baseId)) {
      baseId = Random().nextInt(9999999);
    }
    return baseId;
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
          id: UniqueKey().toString(),
          media_id: media.id,
          folder_id: folderId,
          notification_id: _generateUniqueDownloadNotificationId(),
          provider: provider,
          extension: media.extension,
        ).toJson(),
      );
    }
    await updateQueue(database);
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

  Future<void> runUploadAutoBackupQueue() async {
    if (_uploadQueueIsRunning) return;
    _uploadQueueIsRunning = true;
    while (_uploadQueue.firstWhereOrNull(
          (element) =>
              element.status.isWaiting && element.upload_using_auto_backup,
        ) !=
        null) {
      final process = _uploadQueue.firstWhere(
        (element) =>
            element.status.isWaiting && element.upload_using_auto_backup,
      );
      if (process.provider == MediaProvider.googleDrive) {
        await _uploadInGoogleDrive(process);
      } else if (process.provider == MediaProvider.dropbox) {
        await _uploadInDropbox(process);
      } else {
        await _updateUploadQueue(
          process.copyWith(status: MediaQueueProcessStatus.failed),
        );
      }
    }
    _uploadQueueIsRunning = false;
  }

  Future<void> runUploadQueue() async {
    for (UploadMediaProcess process in _uploadQueue.where(
      (element) =>
          element.status.isWaiting && !element.upload_using_auto_backup,
    )) {
      if (process.provider == MediaProvider.googleDrive) {
        _uploadInGoogleDrive(process);
      } else if (process.provider == MediaProvider.dropbox) {
        _uploadInDropbox(process);
      } else {
        _updateUploadQueue(
          process.copyWith(status: MediaQueueProcessStatus.failed),
        );
      }
    }
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

  Future<void> _uploadInGoogleDrive(UploadMediaProcess uploadProcess) async {
    UploadMediaProcess process = uploadProcess;
    try {
      process = process.copyWith(status: MediaQueueProcessStatus.uploading);
      process = await _updateUploadQueue(process);

      final cancelToken = CancelToken();

      final res = await _googleDriveService.uploadMedia(
        folderId: process.folder_id,
        path: process.path,
        mimeType: process.mime_type,
        localRefId: process.media_id,
        onProgress: (chunk, total) async {
          if (process.status.isTerminated) {
            cancelToken.cancel();
          }
          process = process.copyWith(total: total, chunk: chunk);
          process = await _updateUploadQueue(process);
        },
        cancelToken: cancelToken,
      );
      process = process.copyWith(
        status: MediaQueueProcessStatus.completed,
        response: res,
      );
      process = await _updateUploadQueue(process);
    } catch (e) {
      if (e is RequestCancelledByUser) return;
      process = process.copyWith(status: MediaQueueProcessStatus.failed);
      process = await _updateUploadQueue(process);
      return;
    }
  }

  Future<void> _uploadInDropbox(UploadMediaProcess uploadProcess) async {
    UploadMediaProcess process = uploadProcess;
    try {
      process = process.copyWith(status: MediaQueueProcessStatus.uploading);
      process = await _updateUploadQueue(process);

      final cancelToken = CancelToken();

      await _dropboxService.uploadMedia(
        folderId: process.folder_id,
        path: process.path,
        mimeType: process.mime_type,
        localRefId: process.media_id,
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

  void terminateUploadProcess(String id) async {
    final process =
        _uploadQueue.firstWhereOrNull((element) => element.id == id);
    if (process == null ||
        (!process.status.isRunning && !process.status.isWaiting)) {
      return;
    }
    await _updateUploadQueue(
      process.copyWith(status: MediaQueueProcessStatus.terminated),
    );
  }

  void terminateDownloadProcess(String id) async {
    final process =
        _downloadQueue.firstWhereOrNull((element) => element.id == id);
    if (process == null ||
        process.status.isRunning ||
        process.status.isWaiting) {
      return;
    }
    await _updateDownloadQueue(
      process.copyWith(status: MediaQueueProcessStatus.terminated),
    );
  }

  Future<void> runDownloadQueue() async {
    for (final process
        in _downloadQueue.where((element) => element.status.isWaiting)) {
      if (process.provider == MediaProvider.googleDrive) {
        _downloadFromGoogleDrive(process);
      } else if (process.provider == MediaProvider.dropbox) {
        _downloadFromDropbox(process);
      } else {
        _updateDownloadQueue(
          process.copyWith(status: MediaQueueProcessStatus.failed),
        );
      }
    }
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
      tempFileLocation =
          "${tempDir.path}/${process.media_id}.${process.extension}";

      final cancelToken = CancelToken();

      await _googleDriveService.downloadMedia(
        id: process.media_id,
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
        return;
      }

      await _googleDriveService.updateAppProperties(
        id: process.media_id,
        localRefId: localMedia.id,
      );

      process = process.copyWith(
        status: MediaQueueProcessStatus.completed,
        response: localMedia,
      );
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
      tempFileLocation =
          "${tempDir.path}/${process.media_id}.${process.extension}";

      final cancelToken = CancelToken();

      await _dropboxService.downloadMedia(
        id: process.media_id,
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

      await _dropboxService.updateAppProperties(
        id: process.media_id,
        localRefId: localMedia!.id,
      );

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
