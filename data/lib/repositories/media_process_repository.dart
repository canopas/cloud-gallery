import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../domain/config.dart';
import '../domain/formatters/byte_formatter.dart';
import '../errors/app_error.dart';
import '../handlers/notification_handler.dart';
import '../models/media/media.dart';
import '../models/media/media_extension.dart';
import '../models/media_process/media_process.dart';
import '../services/dropbox_services.dart';
import '../services/google_drive_service.dart';
import '../services/local_media_service.dart';
import '../storage/app_preferences.dart';

final mediaProcessRepoProvider = Provider<MediaProcessRepo>((ref) {
  final repo = MediaProcessRepo(
    ref.read(googleDriveServiceProvider),
    ref.read(dropboxServiceProvider),
    ref.read(localMediaServiceProvider),
    ref.read(notificationHandlerProvider),
    ref.read(AppPreferences.notifications),
  );
  final subscription = ref.listen(
    AppPreferences.notifications,
    (previous, next) {
      repo.updateShowNotification(next);
    },
  );
  ref.onDispose(() {
    subscription.close();
    repo.dispose();
  });

  return repo;
});

class ProcessNotificationConstants {
  static const String uploadProcessGroupIdentifier =
      'cloud_gallery_upload_process';
  static const String downloadProcessGroupIdentifier =
      'cloud_gallery_download_process';
}

class DeleteMediaEvent {
  final String id;
  final AppMediaSource source;

  DeleteMediaEvent({
    required this.id,
    required this.source,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeleteMediaEvent &&
        other.id == id &&
        other.source == source;
  }

  @override
  int get hashCode => Object.hash(id, source);
}

class MediaProcessRepo extends ChangeNotifier {
  final GoogleDriveService _googleDriveService;
  final DropboxService _dropboxService;
  final LocalMediaService _localMediaService;
  final NotificationHandler _notificationHandler;
  bool _showNotification;

  late Database database;

  List<UploadMediaProcess> _uploadQueue = [];
  List<DownloadMediaProcess> _downloadQueue = [];

  List<UploadMediaProcess> get uploadQueue => _uploadQueue;

  List<DownloadMediaProcess> get downloadQueue => _downloadQueue;

  Map<String, DeleteMediaEvent> deleteMediaEvent = {};

  void notifyDeleteMedia(List<DeleteMediaEvent> events) {
    deleteMediaEvent = Map.fromEntries(
      events.map((e) => MapEntry(e.id, e)),
    );
    notifyListeners();
    deleteMediaEvent = {};
  }

  MediaProcessRepo(
    this._googleDriveService,
    this._dropboxService,
    this._localMediaService,
    this._notificationHandler,
    this._showNotification,
  ) {
    initializeLocalDatabase();
  }

  void updateShowNotification(bool showNotification) {
    _showNotification = showNotification;

    if (!showNotification) {
      _notificationHandler.cancelAllNotification();
    }
  }

  // DATABASE COMMON OPERATIONS ------------------------------------------------

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
          'notification_id INTEGER NOT NULL, '
          'name TEXT NOT NULL, '
          'thumbnail TEXT, '
          'provider TEXT NOT NULL, '
          'status TEXT NOT NULL, '
          'extension TEXT NOT NULL, '
          'response TEXT, '
          'total INTEGER NOT NULL, '
          'chunk INTEGER NOT NULL'
          ')',
        );
      },
      onOpen: (Database db) async {
        await updateQueue(db);
        runAutoBackupQueue();
      },
    );
  }

  @override
  Future<void> dispose() async {
    for (var element in _uploadQueue.where(
      (element) => element.status.isRunning,
    )) {
      updateDownloadProcessStatus(
        status: MediaQueueProcessStatus.failed,
        id: element.id,
      );
    }

    for (var element in _downloadQueue.where(
      (element) => element.status.isRunning,
    )) {
      updateDownloadProcessStatus(
        status: MediaQueueProcessStatus.failed,
        id: element.id,
      );
    }
    await database.close();
    super.dispose();
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

  // AUTO BACKUP OPERATIONS ----------------------------------------------------

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
              .where(
                (element) =>
                    element.media_id == localMedia.id &&
                    element.status.isRunning,
              )
              .isNotEmpty ||
          dgMedias.where((gdMedia) => gdMedia.id == localMedia.id).isNotEmpty) {
        localMedias.removeWhere((media) => media.id == localMedia.id);
      }
    }

    for (AppMedia media in localMedias) {
      await database.insert(
        LocalDatabaseConstants.uploadQueueTable,
        UploadMediaProcess(
          id: _generateUniqueIdV4(),
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
    runAutoBackupQueue();
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
              .where(
                (element) =>
                    element.media_id == localMedia.id &&
                    element.status.isRunning,
              )
              .isNotEmpty ||
          dropboxMedias
              .where((gdMedia) => gdMedia.id == localMedia.id)
              .isNotEmpty) {
        localMedias.removeWhere((media) => media.id == localMedia.id);
      }
    }

    for (AppMedia media in localMedias) {
      await database.insert(
        LocalDatabaseConstants.uploadQueueTable,
        UploadMediaProcess(
          id: _generateUniqueIdV4(),
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
    runAutoBackupQueue();
  }

  Future<void> stopAutoBackup(MediaProvider provider) async {
    final processes = _uploadQueue
        .where(
          (element) =>
              element.upload_using_auto_backup &&
              element.provider == provider &&
              element.status.isWaiting,
        )
        .map((e) => e.id)
        .toList();

    if (processes.isNotEmpty) {
      await database.delete(
        LocalDatabaseConstants.uploadQueueTable,
        where: 'id IN (${List.filled(processes.length, '?').join(',')})',
        whereArgs: processes,
      );
    }

    await updateQueue(database);
  }

  bool _autoBackupQueueIsRunning = false;

  Future<void> runAutoBackupQueue() async {
    if (_autoBackupQueueIsRunning) return;
    _autoBackupQueueIsRunning = true;
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
        await updateUploadProcessStatus(
          status: MediaQueueProcessStatus.failed,
          id: process.id,
        );
      }
    }
    _autoBackupQueueIsRunning = false;
  }

  // UPLOAD QUEUE DATABASE OPERATIONS ------------------------------------------

  int _generateUniqueUploadNotificationId() {
    int baseId = math.Random.secure().nextInt(9999999);
    while (_uploadQueue.any((element) => element.notification_id == baseId)) {
      baseId = math.Random().nextInt(9999999);
    }
    return baseId;
  }

  ///Generate Cryptographically secure unique ID in UUIDv4 format
  ///https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_(random)
  String _generateUniqueIdV4() {
    final random = math.Random
        .secure(); // Cryptographically secure random number generator

    String generateHex(int length) {
      return List.generate(length, (_) => random.nextInt(16).toRadixString(16))
          .join();
    }

    // Generate UUID-like ID with shorter length
    return '${generateHex(8)}-${generateHex(4)}-4${generateHex(3)}-${(8 + random.nextInt(4)).toRadixString(16)}${generateHex(3)}-${generateHex(8)}';
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
          id: _generateUniqueIdV4(),
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

  Future<void> updateUploadProcessStatus({
    required MediaQueueProcessStatus status,
    required String id,
    AppMedia? response,
  }) async {
    await database.rawUpdate(
      "UPDATE ${LocalDatabaseConstants.uploadQueueTable} SET status = ?, response = ? WHERE id = ?",
      [status.value, LocalDatabaseAppMediaConverter().toJson(response), id],
    );
    await updateQueue(database);
  }

  Future<void> clearUploadProcessResponse({
    required String id,
  }) async {
    await database.rawUpdate(
      "UPDATE ${LocalDatabaseConstants.uploadQueueTable} SET response = ? WHERE id = ?",
      [null, id],
    );
    await updateQueue(database);
  }

  Future<void> updateUploadProcessProgress({
    required String id,
    required int chunk,
    required int total,
  }) async {
    await database.rawUpdate(
      "UPDATE ${LocalDatabaseConstants.uploadQueueTable} SET chunk = ?, total = ? WHERE id = ?",
      [chunk, total, id],
    );
    await updateQueue(database);
  }

  Future<void> terminateUploadProcess(String id) async {
    await database.rawUpdate(
      "UPDATE ${LocalDatabaseConstants.uploadQueueTable} SET status = ? WHERE id = ? AND (status = ? OR status = ?)",
      [
        MediaQueueProcessStatus.terminated.value,
        id,
        MediaQueueProcessStatus.uploading.value,
        MediaQueueProcessStatus.waiting.value,
      ],
    );
    await updateQueue(database);
  }

  Future<void> removeAllWaitingUploadsOfProvider(MediaProvider provider) async {
    await database.rawDelete(
      "DELETE FROM ${LocalDatabaseConstants.uploadQueueTable} WHERE provider = ? AND status = ?",
      [MediaProvider.googleDrive.value, MediaQueueProcessStatus.waiting.value],
    );
    await updateQueue(database);
  }

  Future<void> removeItemFromUploadQueue(String id) async {
    await database.rawDelete(
      "DELETE FROM ${LocalDatabaseConstants.uploadQueueTable} WHERE id = ?",
      [id],
    );
    await updateQueue(database);
  }

  // UPLOAD QUEUE OPERATIONS ---------------------------------------------------

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
        updateUploadProcessStatus(
          status: MediaQueueProcessStatus.failed,
          id: process.id,
        );
      }
    }
  }

  Future<void> _uploadInGoogleDrive(UploadMediaProcess uploadProcess) async {
    UploadMediaProcess process = uploadProcess;
    Timer? updateDatabaseDebounce;

    Future<void> showNotification(
      String message, {
      int? chunk,
      int total = 100,
    }) async {
      if (!_showNotification) return;
      _notificationHandler.showNotification(
        silent: true,
        id: process.notification_id,
        name: process.path.split('/').last,
        description: message,
        groupKey: ProcessNotificationConstants.uploadProcessGroupIdentifier,
        progress: chunk,
        maxProgress: total,
        category: chunk != null ? AndroidNotificationCategory.progress : null,
      );
    }

    try {
      showNotification('Uploading to Google Drive');

      await updateUploadProcessStatus(
        status: MediaQueueProcessStatus.uploading,
        id: process.id,
      );

      final cancelToken = CancelToken();

      final res = await _googleDriveService.uploadMedia(
        folderId: process.folder_id,
        path: process.path,
        mimeType: process.mime_type,
        localRefId: process.media_id,
        onProgress: (chunk, total) async {
          process =
              _uploadQueue.firstWhere((element) => element.id == process.id);
          if (process.status.isTerminated) {
            cancelToken.cancel();
          }

          if (updateDatabaseDebounce == null ||
              !updateDatabaseDebounce!.isActive) {
            updateDatabaseDebounce = Timer(Duration(milliseconds: 300), () {});

            if (!process.status.isTerminated) {
              showNotification(
                '${chunk.formatBytes} / ${total.formatBytes} - ${total <= 0 ? 0 : (chunk / total * 100).round()}%',
                chunk: chunk,
                total: total,
              );
            }

            await updateUploadProcessProgress(
              id: process.id,
              chunk: chunk,
              total: total,
            );
          }
        },
        cancelToken: cancelToken,
      );

      showNotification('Uploaded to Google Drive successfully');

      await updateUploadProcessStatus(
        status: MediaQueueProcessStatus.completed,
        response: res,
        id: process.id,
      );

      await clearUploadProcessResponse(id: process.id);
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        showNotification('Upload to Google Drive cancelled');
        return;
      }

      showNotification('Failed to upload to Google Drive');

      await updateDownloadProcessStatus(
        status: MediaQueueProcessStatus.failed,
        id: process.id,
      );
    }
  }

  Future<void> _uploadInDropbox(UploadMediaProcess uploadProcess) async {
    UploadMediaProcess process = uploadProcess;
    Timer? updateDatabaseDebounce;

    Future showNotification(
      String message, {
      int? chunk,
      int total = 100,
    }) async {
      if (!_showNotification) return;
      _notificationHandler.showNotification(
        silent: true,
        id: process.notification_id,
        name: process.path.split('/').last,
        description: message,
        groupKey: ProcessNotificationConstants.uploadProcessGroupIdentifier,
        progress: chunk,
        maxProgress: total,
        category: chunk != null ? AndroidNotificationCategory.progress : null,
      );
    }

    try {
      showNotification('Uploading to Dropbox');

      await updateUploadProcessStatus(
        status: MediaQueueProcessStatus.uploading,
        id: process.id,
      );

      final cancelToken = CancelToken();

      final res = await _dropboxService.uploadMedia(
        folderId: process.folder_id,
        path: process.path,
        mimeType: process.mime_type,
        localRefId: process.media_id,
        onProgress: (chunk, total) async {
          process =
              _uploadQueue.firstWhere((element) => element.id == process.id);
          if (process.status.isTerminated) {
            cancelToken.cancel();
          }
          if (updateDatabaseDebounce == null ||
              !updateDatabaseDebounce!.isActive) {
            updateDatabaseDebounce = Timer(Duration(milliseconds: 300), () {});

            if (!process.status.isTerminated) {
              showNotification(
                '${chunk.formatBytes} / ${total.formatBytes} - ${total <= 0 ? 0 : (chunk / total * 100).round()}%',
                chunk: chunk,
                total: total,
              );
            }

            await updateUploadProcessProgress(
              id: process.id,
              chunk: chunk,
              total: total,
            );
          }
        },
        cancelToken: cancelToken,
      );

      showNotification('Uploaded to Dropbox successfully');

      await updateUploadProcessStatus(
        status: MediaQueueProcessStatus.completed,
        response: res,
        id: process.id,
      );

      await clearUploadProcessResponse(id: process.id);
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        showNotification('Upload to Dropbox cancelled');
        return;
      }

      showNotification('Failed to upload to Dropbox');

      await updateUploadProcessStatus(
        status: MediaQueueProcessStatus.failed,
        id: process.id,
      );
      return;
    }
  }

  // DOWNLOAD QUEUE DATABASE OPERATIONS ----------------------------------------

  int _generateUniqueDownloadNotificationId() {
    int baseId = math.Random().nextInt(9999999);
    while (_downloadQueue.any((element) => element.notification_id == baseId)) {
      baseId = math.Random().nextInt(9999999);
    }
    return baseId;
  }

  void downloadMedia({
    required List<AppMedia> medias,
    required String folderId,
    required MediaProvider provider,
  }) async {
    for (AppMedia media in medias) {
      final id = provider == MediaProvider.googleDrive
          ? media.driveMediaRefId
          : media.dropboxMediaRefId;
      await database.insert(
        LocalDatabaseConstants.downloadQueueTable,
        DownloadMediaProcess(
          name: media.path.split('/').last.trim().isEmpty
              ? media.id
              : media.path.split('/').last,
          id: _generateUniqueIdV4(),
          media_id: id ?? media.id,
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

  Future<void> updateDownloadProcessStatus({
    required MediaQueueProcessStatus status,
    required String id,
    AppMedia? response,
  }) async {
    await database.rawUpdate(
      "UPDATE ${LocalDatabaseConstants.downloadQueueTable} SET status = ?, response = ? WHERE id = ?",
      [status.value, LocalDatabaseAppMediaConverter().toJson(response), id],
    );
    await updateQueue(database);
  }

  Future<void> clearDownloadProcessResponse({
    required String id,
  }) async {
    await database.rawUpdate(
      "UPDATE ${LocalDatabaseConstants.downloadQueueTable} SET response = ? WHERE id = ?",
      [null, id],
    );
    await updateQueue(database);
  }

  Future<void> updateDownloadProcessProgress({
    required String id,
    required int received,
    required int total,
  }) async {
    await database.rawUpdate(
      "UPDATE ${LocalDatabaseConstants.downloadQueueTable} SET chunk = ?, total = ? WHERE id = ?",
      [received, total, id],
    );
    await updateQueue(database);
  }

  Future<void> terminateDownloadProcess(String id) async {
    await database.rawUpdate(
      "UPDATE ${LocalDatabaseConstants.downloadQueueTable} SET status = ? WHERE id = ? AND (status = ? OR status = ?)",
      [
        MediaQueueProcessStatus.terminated.value,
        id,
        MediaQueueProcessStatus.downloading.value,
        MediaQueueProcessStatus.waiting.value,
      ],
    );
    await updateQueue(database);
  }

  Future<void> removeItemFromDownloadQueue(String id) async {
    await database.rawDelete(
      "DELETE FROM ${LocalDatabaseConstants.downloadQueueTable} WHERE id = ?",
      [id],
    );
    await updateQueue(database);
  }

  // DOWNLOAD QUEUE OPERATIONS -------------------------------------------------

  Future<void> runDownloadQueue() async {
    for (final process
        in _downloadQueue.where((element) => element.status.isWaiting)) {
      if (process.provider == MediaProvider.googleDrive) {
        _downloadFromGoogleDrive(process);
      } else if (process.provider == MediaProvider.dropbox) {
        _downloadFromDropbox(process);
      } else {
        updateDownloadProcessStatus(
          status: MediaQueueProcessStatus.failed,
          id: process.id,
        );
      }
    }
  }

  Future<void> _downloadFromGoogleDrive(
    DownloadMediaProcess downloadProcess,
  ) async {
    DownloadMediaProcess process = downloadProcess;
    String? tempFileLocation;
    Timer? updateDatabaseDebounce;

    Future<void> showNotification(
      String message, {
      int? chunk,
      int total = 100,
    }) async {
      if (!_showNotification) return;
      _notificationHandler.showNotification(
        silent: true,
        id: process.notification_id,
        name: process.media_id,
        description: message,
        groupKey: ProcessNotificationConstants.downloadProcessGroupIdentifier,
        progress: chunk,
        maxProgress: total,
        category: chunk != null ? AndroidNotificationCategory.progress : null,
      );
    }

    try {
      showNotification('Downloading from Google Drive');

      await updateDownloadProcessStatus(
        status: MediaQueueProcessStatus.downloading,
        id: process.id,
      );

      final tempDir = await getTemporaryDirectory();
      tempFileLocation =
          "${tempDir.path}/${process.media_id}.${process.extension}";

      final cancelToken = CancelToken();

      await _googleDriveService.downloadMedia(
        id: process.media_id,
        saveLocation: tempFileLocation,
        onProgress: (received, total) async {
          process =
              _downloadQueue.firstWhere((element) => element.id == process.id);
          if (process.status.isTerminated) {
            cancelToken.cancel();
          }

          if (updateDatabaseDebounce == null ||
              !updateDatabaseDebounce!.isActive) {
            updateDatabaseDebounce = Timer(Duration(milliseconds: 300), () {});

            if (!process.status.isTerminated) {
              showNotification(
                '${received.formatBytes} / ${total.formatBytes} - ${total <= 0 ? 0 : (received / total * 100).round()}%',
                chunk: received,
                total: total,
              );
            }

            await updateDownloadProcessProgress(
              id: process.id,
              received: received,
              total: total,
            );
          }
        },
        cancelToken: cancelToken,
      );

      final localMedia = await _localMediaService.saveInGallery(
        saveFromLocation: tempFileLocation,
        type: AppMediaType.fromLocation(location: tempFileLocation),
      );

      if (localMedia == null) {
        showNotification('Failed to save media in gallery');

        await updateDownloadProcessStatus(
          status: MediaQueueProcessStatus.failed,
          id: process.id,
        );
        return;
      }

      await _googleDriveService.updateAppProperties(
        id: process.media_id,
        localRefId: localMedia.id,
      );

      showNotification('Downloaded from Google Drive successfully');

      await updateDownloadProcessStatus(
        status: MediaQueueProcessStatus.completed,
        response: localMedia,
        id: process.id,
      );

      await clearDownloadProcessResponse(id: process.id);
    } catch (error) {
      if (error is DioException && error.type == DioExceptionType.cancel) {
        showNotification('Download from Google Drive cancelled');
        return;
      }

      showNotification('Failed to download from Google Drive');

      await updateDownloadProcessStatus(
        status: MediaQueueProcessStatus.failed,
        id: process.id,
      );
    } finally {
      if (tempFileLocation != null && await File(tempFileLocation).exists()) {
        await File(tempFileLocation).delete();
      }
    }
  }

  Future<void> _downloadFromDropbox(
    DownloadMediaProcess downloadProcess,
  ) async {
    DownloadMediaProcess process = downloadProcess;
    String? tempFileLocation;
    Timer? updateDatabaseDebounce;

    Future<void> showNotification(
      String message, {
      int? chunk,
      int total = 100,
    }) async {
      if (!_showNotification) return;
      _notificationHandler.showNotification(
        silent: true,
        id: process.notification_id,
        name: process.media_id,
        description: message,
        groupKey: ProcessNotificationConstants.downloadProcessGroupIdentifier,
        progress: chunk,
        maxProgress: total,
        category: chunk != null ? AndroidNotificationCategory.progress : null,
      );
    }

    try {
      showNotification('Downloading from Dropbox');

      await updateDownloadProcessStatus(
        status: MediaQueueProcessStatus.downloading,
        id: process.id,
      );

      final tempDir = await getTemporaryDirectory();
      tempFileLocation =
          "${tempDir.path}/${process.media_id}.${process.extension}";

      final cancelToken = CancelToken();

      await _dropboxService.downloadMedia(
        id: process.media_id,
        saveLocation: tempFileLocation,
        onProgress: (received, total) async {
          process =
              _downloadQueue.firstWhere((element) => element.id == process.id);
          if (process.status.isTerminated) {
            cancelToken.cancel();
          }

          if (updateDatabaseDebounce == null ||
              !updateDatabaseDebounce!.isActive) {
            updateDatabaseDebounce = Timer(Duration(milliseconds: 300), () {});

            if (!process.status.isTerminated) {
              showNotification(
                '${received.formatBytes} / ${total.formatBytes} - ${total <= 0 ? 0 : (received / total * 100).round()}%',
                chunk: received,
                total: total,
              );
            }

            await updateDownloadProcessProgress(
              id: process.id,
              received: received,
              total: total,
            );
          }
        },
        cancelToken: cancelToken,
      );

      final localMedia = await _localMediaService.saveInGallery(
        saveFromLocation: tempFileLocation,
        type: AppMediaType.fromLocation(location: tempFileLocation),
      );

      if (localMedia == null) {
        showNotification('Failed to save media in gallery');

        await updateDownloadProcessStatus(
          status: MediaQueueProcessStatus.failed,
          id: process.id,
        );
      }

      await _dropboxService.updateAppProperties(
        id: process.media_id,
        localRefId: localMedia!.id,
      );

      showNotification('Downloaded from Dropbox successfully');

      await updateDownloadProcessStatus(
        status: MediaQueueProcessStatus.completed,
        response: localMedia,
        id: process.id,
      );

      await clearDownloadProcessResponse(id: process.id);
    } catch (error) {
      if (error is DioException && error.type == DioExceptionType.cancel) {
        showNotification('Download from Dropbox cancelled');
        return;
      }

      showNotification('Failed to download from Dropbox');

      await updateDownloadProcessStatus(
        status: MediaQueueProcessStatus.failed,
        id: process.id,
      );
    } finally {
      if (tempFileLocation != null && await File(tempFileLocation).exists()) {
        await File(tempFileLocation).delete();
      }
    }
  }
}
