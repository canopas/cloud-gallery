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
import '../handlers/unique_id_generator.dart';
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
    ref.read(uniqueIdGeneratorProvider),
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
  final UniqueIdGenerator _uniqueIdGenerator;
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
    this._uniqueIdGenerator,
  ) {
    _initializeLocalDatabase();
  }

  void updateShowNotification(bool showNotification) {
    _showNotification = showNotification;

    if (!showNotification) {
      _notificationHandler.cancelAllNotification();
    }
  }

  // DATABASE COMMON OPERATIONS ------------------------------------------------

  Future<void> _initializeLocalDatabase() async {
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
          'upload_session_id TEXT, '
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
    //Fetch Media from local storage and Google Drive
    final backUpFolderId = await _googleDriveService.getBackUpFolderId();

    if (backUpFolderId == null) {
      throw BackUpFolderNotFound();
    }

    final res = await Future.wait([
      _localMediaService.getAllLocalMedia(),
      _googleDriveService.getAllMedias(folder: backUpFolderId),
    ]);

    final localMedias = res[0];
    final gdMedias = res[1];

    // Remove media that are already in the upload queue or already in Google Drive
    for (AppMedia localMedia in localMedias.toList()) {
      if (_uploadQueue
              .where(
                (element) =>
                    element.media_id == localMedia.id &&
                    (element.status.isRunning ||
                        element.status.isPaused ||
                        element.status.isWaiting),
              )
              .isNotEmpty ||
          gdMedias.where((gdMedia) => gdMedia.id == localMedia.id).isNotEmpty) {
        localMedias.removeWhere((media) => media.id == localMedia.id);
      }
    }

    // Add media to the upload queue
    final batch = database.batch();
    for (AppMedia media in localMedias) {
      batch.insert(
        LocalDatabaseConstants.uploadQueueTable,
        UploadMediaProcess(
          id: _uniqueIdGenerator.v4(),
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
    await batch.commit(noResult: true);

    // Update the queue and run the auto backup queue
    await updateQueue(database);
    runAutoBackupQueue();
  }

  Future<void> autoBackupInDropbox() async {
    // Fetch Media from local storage and Dropbox
    final res = await Future.wait([
      _localMediaService.getAllLocalMedia(),
      _dropboxService.getAllMedias(folder: ProviderConstants.backupFolderPath),
    ]);

    final localMedias = res[0];
    final dropboxMedias = res[1];

    // Remove media that are already in the upload queue or already in Dropbox
    for (AppMedia localMedia in localMedias.toList()) {
      if (_uploadQueue
              .where(
                (element) =>
                    element.media_id == localMedia.id &&
                    (element.status.isRunning ||
                        element.status.isPaused ||
                        element.status.isWaiting),
              )
              .isNotEmpty ||
          dropboxMedias
              .where((gdMedia) => gdMedia.id == localMedia.id)
              .isNotEmpty) {
        localMedias.removeWhere((media) => media.id == localMedia.id);
      }
    }

    // Add media to the upload queue
    final batch = database.batch();
    for (AppMedia media in localMedias) {
      batch.insert(
        LocalDatabaseConstants.uploadQueueTable,
        UploadMediaProcess(
          id: _uniqueIdGenerator.v4(),
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
    await batch.commit(noResult: true);

    // Update the queue and run the auto backup queue
    await updateQueue(database);
    runAutoBackupQueue();
  }

  /// Remove all the auto backup processes from the upload queue for the given provider
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

  /// Start uploading the media from the auto backup queue
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

  void uploadMedia({
    required List<AppMedia> medias,
    required String folderId,
    required MediaProvider provider,
  }) async {
    final batch = database.batch();
    for (AppMedia media in medias) {
      batch.insert(
        LocalDatabaseConstants.uploadQueueTable,
        UploadMediaProcess(
          id: _uniqueIdGenerator.v4(),
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
    await batch.commit(noResult: true);
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

  Future<void> updateUploadSessionId({
    required String id,
    required String uploadSessionId,
  }) async {
    await database.rawUpdate(
      "UPDATE ${LocalDatabaseConstants.uploadQueueTable} SET upload_session_id = ? WHERE id = ?",
      [uploadSessionId, id],
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
      "UPDATE ${LocalDatabaseConstants.uploadQueueTable} SET status = ? WHERE id = ? AND (status = ? OR status = ? OR status = ?)",
      [
        MediaQueueProcessStatus.terminated.value,
        id,
        MediaQueueProcessStatus.uploading.value,
        MediaQueueProcessStatus.waiting.value,
        MediaQueueProcessStatus.paused.value,
      ],
    );
    await updateQueue(database);
  }

  Future<void> pauseUploadProcess(String id) async {
    await database.rawUpdate(
      "UPDATE ${LocalDatabaseConstants.uploadQueueTable} SET status = ? WHERE id = ? AND (status = ? OR status = ?)",
      [
        MediaQueueProcessStatus.paused.value,
        id,
        MediaQueueProcessStatus.uploading.value,
        MediaQueueProcessStatus.waiting.value,
      ],
    );
    await updateQueue(database);
  }

  Future<void> resumeUploadProcess(String id) async {
    final process = _uploadQueue.firstWhere(
      (element) => element.id == id,
    );
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

      // Start the upload session if it is not started yet and get the upload session id
      final uploadSessionId = process.upload_session_id ??
          await _googleDriveService.startUploadSession(
            path: process.path,
            localRefId: process.media_id,
            mimeType: process.mime_type,
            folderId: process.folder_id,
          );

      await updateUploadSessionId(
        id: process.id,
        uploadSessionId: uploadSessionId,
      );

      // Upload the media in chunks
      AppMedia? response;
      int chunk = process.chunk;
      final total = await File(process.path).length();

      while (chunk < total) {
        process = _uploadQueue.firstWhere((e) => e.id == process.id);

        // Check if the process is terminated or paused and break the loop if it is
        if (process.status.isTerminated) {
          showNotification('Upload to Google Drive Cancelled');
          break;
        } else if (process.status.isPaused) {
          showNotification('Upload to Google Drive Paused');
          break;
        }

        // Calculate the end byte of the chunk to be uploaded
        final end = (chunk + ApiConfigs.uploadRequestByteSize).clamp(0, total);

        final res = await _googleDriveService.appendUploadSession(
          startByte: chunk,
          endByte: end,
          uploadId: uploadSessionId,
          path: process.path,
        );

        // Update the chunk and total bytes uploaded
        chunk = end;

        showNotification(
          '${chunk.formatBytes} / ${total.formatBytes} - ${total <= 0 ? 0 : (chunk / total * 100).round()}%',
          chunk: chunk,
          total: total,
        );

        await updateUploadProcessProgress(
          id: process.id,
          chunk: chunk,
          total: total,
        );

        if (res != null) response = res;
      }
      // If the chunk is equal to the total bytes, then sey the process as completed
      if (chunk >= total) {
        await updateUploadProcessStatus(
          status: MediaQueueProcessStatus.completed,
          response: response,
          id: process.id,
        );
        showNotification('Uploaded to Google Drive successfully');
        await clearUploadProcessResponse(id: process.id);
      }
    } catch (e) {
      showNotification('Failed to upload to Google Drive');

      await updateDownloadProcessStatus(
        status: MediaQueueProcessStatus.failed,
        id: process.id,
      );
    }
  }

  Future<void> _uploadInDropbox(UploadMediaProcess uploadProcess) async {
    UploadMediaProcess process = uploadProcess;

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

      AppMedia? response;
      int chunk = process.chunk;
      final total = await File(process.path).length();

      // Upload the media in chunks
      while (chunk < total) {
        process =
            _uploadQueue.firstWhere((element) => element.id == process.id);

        // Check if the process is terminated or paused and break the loop if it is
        if (process.status.isTerminated) {
          showNotification('Upload to Dropbox Cancelled');
          break;
        } else if (process.status.isPaused) {
          showNotification('Upload to Dropbox Paused');
          break;
        }

        final end = (chunk + ApiConfigs.uploadRequestByteSize).clamp(0, total);

        if (end >= total && process.upload_session_id != null) {
          // If the end byte is equal to the total bytes and the upload session id is not null then finish the upload session
          response = await _dropboxService.finishUploadSession(
            sessionId: process.upload_session_id!,
            startByte: chunk,
            endByte: end,
            path: process.path,
            localRefId: process.media_id,
          );
        } else if (process.upload_session_id != null) {
          // If the upload session id is not null then append the chunk to the upload session
          await _dropboxService.appendUploadSession(
            path: process.path,
            endByte: end,
            startByte: chunk,
            sessionId: process.upload_session_id!,
          );
        } else {
          // If the upload session id is null and the chunk is not equal to 0 then start the upload session from the beginning
          if (chunk != 0) {
            await updateUploadProcessProgress(
              id: process.id,
              chunk: 0,
              total: total,
            );
            process = _uploadQueue.firstWhere((e) => e.id == process.id);
            _uploadInDropbox(process);
            return;
          }

          // If the upload session id is null then start the upload session and update the upload session id
          final uploadSessionId = await _dropboxService.startUploadSession(
            path: process.path,
            endByte: end,
            startByte: chunk,
          );

          await updateUploadSessionId(
            id: process.id,
            uploadSessionId: uploadSessionId,
          );
        }

        // Update the chunk and total bytes uploaded
        chunk = end;

        await updateUploadProcessProgress(
          id: process.id,
          chunk: chunk,
          total: total,
        );

        showNotification(
          '${chunk.formatBytes} / ${total.formatBytes} - ${total <= 0 ? 0 : (chunk / total * 100).round()}%',
          chunk: chunk,
          total: total,
        );
      }

      // If the chunk is equal to the total bytes, then sey the process as completed
      if (chunk >= total) {
        await updateUploadProcessStatus(
          status: MediaQueueProcessStatus.completed,
          response: response,
          id: process.id,
        );
        showNotification('Uploaded to Dropbox successfully');
        await clearUploadProcessResponse(id: process.id);
      }
    } catch (e) {
      showNotification('Failed to upload to Dropbox');

      await updateUploadProcessStatus(
        status: MediaQueueProcessStatus.failed,
        id: process.id,
      );
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
    final batch = database.batch();
    for (AppMedia media in medias) {
      final id = provider == MediaProvider.googleDrive
          ? media.driveMediaRefId
          : media.dropboxMediaRefId;
      batch.insert(
        LocalDatabaseConstants.downloadQueueTable,
        DownloadMediaProcess(
          name: media.path.split('/').last.trim().isEmpty
              ? media.id
              : media.path.split('/').last,
          id: _uniqueIdGenerator.v4(),
          media_id: id ?? media.id,
          folder_id: folderId,
          notification_id: _generateUniqueDownloadNotificationId(),
          provider: provider,
          extension: media.extension,
        ).toJson(),
      );
    }
    await batch.commit(noResult: true);
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
