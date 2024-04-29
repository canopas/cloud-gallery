import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:data/extensions/iterable_extension.dart';
import 'package:data/models/app_process/app_process.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../errors/app_error.dart';
import '../models/media/media.dart';

final googleDriveProcessRepoProvider = Provider<GoogleDriveProcessRepo>((ref) {
  return GoogleDriveProcessRepo(
    ref.read(googleDriveServiceProvider),
    ref.read(localMediaServiceProvider),
  );
});

class GoogleDriveProcessRepo extends ChangeNotifier {
  final GoogleDriveService _googleDriveService;
  final LocalMediaService _localMediaService;

  final List<AppProcess> _uploadQueue = [];
  final List<AppProcess> _deleteQueue = [];
  final List<AppProcess> _downloadQueue = [];

  bool _uploadQueueRunning = false;
  bool _deleteQueueRunning = false;
  bool _downloadQueueRunning = false;

  List<AppProcess> get uploadQueue => _uploadQueue;

  List<AppProcess> get deleteQueue => _deleteQueue;

  List<AppProcess> get downloadQueue => _downloadQueue;

  String? _backUpFolderID;

  GoogleDriveProcessRepo(this._googleDriveService, this._localMediaService);

  void setBackUpFolderId(String? backUpFolderId) async {
    _backUpFolderID = backUpFolderId;
  }

  void uploadMediasInGoogleDrive({required List<AppMedia> medias, bool isFromAutoBackup = false}) {
    _uploadQueue.addAll(medias.map((media) => AppProcess(
        isFromAutoBackup: isFromAutoBackup,
        id: media.id, media: media, status: AppProcessStatus.waiting)));
    notifyListeners();
    if (!_uploadQueueRunning) _startUploadQueueLoop();
  }

  Future<void> _startUploadQueueLoop() async {
    _uploadQueueRunning = true;
    while (_uploadQueue.firstOrNull != null) {
      await _uploadInGoogleDrive(_uploadQueue[0]);
      _uploadQueue.removeAt(0);
      notifyListeners();
    }
    _uploadQueueRunning = false;
  }

  Future<void> _uploadInGoogleDrive(AppProcess process) async {
    try {
      _uploadQueue.updateWhere(
        where: (element) => element.id == process.id,
        update: (element) =>
            element.copyWith(status: AppProcessStatus.uploading),
      );
      notifyListeners();

      _backUpFolderID ??= await _googleDriveService.getBackupFolderId();

      final cancelToken = CancelToken();

      final res = await _googleDriveService.uploadInGoogleDrive(
        folderID: _backUpFolderID!,
        media: process.media,
        onProgress: (chunk, total) {
          if (_uploadQueue
                  .firstWhereOrNull((element) => element.id == process.id)
                  ?.status
                  .isTerminated ??
              true) {
            cancelToken.cancel();
          }
          _uploadQueue.updateWhere(
            where: (element) => element.id == process.id,
            update: (element) => element.copyWith(
                progress: AppProcessProgress(total: total, chunk: chunk)),
          );
          notifyListeners();
        },
        cancelToken: cancelToken,
      );
      _uploadQueue.updateWhere(
        where: (element) => element.id == process.id,
        update: (element) => element.copyWith(
          status: AppProcessStatus.success,
          response: res,
        ),
      );
    } catch (error) {
      if (error is RequestCancelledByUser) {
        return;
      } else if (error is BackUpFolderNotFound) {
        _backUpFolderID = await _googleDriveService.getBackupFolderId();
        _uploadInGoogleDrive(process);
        return;
      }
      _uploadQueue.updateWhere(
        where: (element) => element.id == process.id,
        update: (element) => element.copyWith(status: AppProcessStatus.failed),
      );
    } finally {
      notifyListeners();
    }
  }

  void deleteMediasFromGoogleDrive({required List<AppMedia> medias}) {
    _deleteQueue.addAll(medias.map((media) => AppProcess(
        id: media.id, media: media, status: AppProcessStatus.waiting)));
    notifyListeners();
    if (!_deleteQueueRunning) _startDeleteQueueLoop();
  }

  Future<void> _startDeleteQueueLoop() async {
    _deleteQueueRunning = true;
    while (_deleteQueue.firstOrNull != null) {
      await _deleteFromGoogleDrive(_deleteQueue[0]);
      _deleteQueue.removeAt(0);
      notifyListeners();
    }
    _deleteQueueRunning = false;
  }

  Future<void> _deleteFromGoogleDrive(AppProcess process) async {
    try {
      _deleteQueue.updateWhere(
        where: (element) => element.id == process.id,
        update: (element) =>
            element.copyWith(status: AppProcessStatus.deleting),
      );
      notifyListeners();
      await _googleDriveService.deleteMedia(process.media.driveMediaRefId!);
      _deleteQueue.updateWhere(
        where: (element) => element.id == process.id,
        update: (element) => element.copyWith(status: AppProcessStatus.success),
      );
    } catch (error) {
      _deleteQueue.updateWhere(
        where: (element) => element.id == process.id,
        update: (element) => element.copyWith(status: AppProcessStatus.failed),
      );
    } finally {
      notifyListeners();
    }
  }

  void downloadMediasFromGoogleDrive({required List<AppMedia> medias}) {
    _downloadQueue.addAll(medias.map((media) => AppProcess(
        id: media.id, media: media, status: AppProcessStatus.waiting)));
    notifyListeners();
    if (!_downloadQueueRunning) _startDownloadQueueLoop();
  }

  Future<void> _startDownloadQueueLoop() async {
    _downloadQueueRunning = true;
    while (_downloadQueue.firstOrNull != null) {
      await _downloadFromGoogleDrive(_downloadQueue[0]);
      _downloadQueue.removeAt(0);
      notifyListeners();
    }
    _downloadQueueRunning = false;
  }

  Future<void> _downloadFromGoogleDrive(AppProcess process) async {
    String? tempFileLocation;
    try {
      _downloadQueue.updateWhere(
        where: (element) => element.id == process.id,
        update: (element) =>
            element.copyWith(status: AppProcessStatus.downloading),
      );
      notifyListeners();

      final tempDir = await getTemporaryDirectory();
      tempFileLocation =
          "${tempDir.path}/${process.media.id}.${process.media.extension}";

      final cancelToken = CancelToken();

      await _googleDriveService.downloadFromGoogleDrive(
        id: process.media.driveMediaRefId!,
        saveLocation: tempFileLocation,
        onProgress: (received, total) {
          if (_downloadQueue
                  .firstWhereOrNull((element) => element.id == process.id)
                  ?.status
                  .isTerminated ??
              true) {
            cancelToken.cancel();
          }
          _downloadQueue.updateWhere(
            where: (element) => element.id == process.id,
            update: (element) => element.copyWith(
                progress: AppProcessProgress(total: total, chunk: received)),
          );
          notifyListeners();
        },
        cancelToken: cancelToken,
      );

      final localMedia = await _localMediaService.saveInGallery(
        saveFromLocation: tempFileLocation,
        type: process.media.type,
      );

      if (localMedia == null) {
        throw const UnableToSaveFileInGallery();
      }

      final updatedMedia = await _googleDriveService.updateMediaDescription(
        process.media.id,
        localMedia.id,
      );

      _downloadQueue.updateWhere(
        where: (element) => element.id == process.id,
        update: (element) => element.copyWith(
            status: AppProcessStatus.success,
            response: localMedia.mergeGoogleDriveMedia(updatedMedia)),
      );
    } catch (error) {
      if (error is RequestCancelledByUser) {
        return;
      }
      _downloadQueue.updateWhere(
        where: (element) => element.id == process.id,
        update: (element) => element.copyWith(status: AppProcessStatus.failed),
      );
    } finally {
      notifyListeners();
      if (tempFileLocation != null) {
        await File(tempFileLocation).delete();
      }
    }
  }

  void clearAllQueue() {
    _uploadQueue.clear();
    _deleteQueue.clear();
    _downloadQueue.clear();
    notifyListeners();
  }

  void terminateUploadProcess(String id) {
    _uploadQueue.updateWhere(
        where: (element) => element.id == id,
        update: (element) =>
            element.copyWith(status: AppProcessStatus.terminated));
    notifyListeners();
  }

  void terminateAllAutoBackupProcess() {
    _uploadQueue.updateWhere(
        where: (element) => element.isFromAutoBackup && element.status.isWaiting,
        update: (element) => element.copyWith(status: AppProcessStatus.terminated));
    notifyListeners();
  }

  void terminateDeleteProcess(String id) {
    _deleteQueue.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void terminateDownloadProcess(String id) {
    _downloadQueue.updateWhere(
        where: (element) => element.id == id,
        update: (element) =>
            element.copyWith(status: AppProcessStatus.terminated));
    notifyListeners();
  }
}
