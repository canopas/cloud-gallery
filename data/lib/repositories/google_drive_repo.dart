import 'dart:async';
import 'package:data/extensions/iterable_extension.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/media/media.dart';

final googleDriveRepoProvider = Provider<GoogleDriveRepo>((ref) {
  return GoogleDriveRepo(ref.read(googleDriveServiceProvider));
});

class GoogleDriveRepo {
  final GoogleDriveService _googleDriveService;

  final StreamController<List<AppMediaProcess>> _mediaProcessController =
      StreamController<List<AppMediaProcess>>.broadcast();

  Set<AppMediaProcess> _mediaProcessValue = {};

  void _updateMediaProcess(Iterable<AppMediaProcess> process) {
    _mediaProcessValue = process.toSet();
    _mediaProcessController.add(mediaProcessValue);
  }

  Stream<List<AppMediaProcess>> get mediaProcessStream =>
      _mediaProcessController.stream;

  List<AppMediaProcess> get mediaProcessValue => _mediaProcessValue.toList();

  GoogleDriveRepo(this._googleDriveService);

  Future<void> uploadMediasInGoogleDrive(
      {required List<AppMedia> medias, required String backUpFolderId}) async {
    _updateMediaProcess([..._mediaProcessValue.toList(),
      ...medias.map((media) => AppMediaProcess(
          mediaId: media.id, status: AppMediaProcessStatus.waiting))]);

    for (final media in medias) {
      //Skip process if queue does not contain mediaId
      if (!_mediaProcessValue.map((e) => e.mediaId).contains(media.id)) {
        continue;
      }

      try {
        _updateMediaProcess(_mediaProcessValue.updateWhere(
          where: (process) => process.mediaId == media.id,
          update: (element) =>
              element.copyWith(status: AppMediaProcessStatus.uploading),
        ));

        final uploadedMedia = await _googleDriveService.uploadInGoogleDrive(
          media: media,
          folderID: backUpFolderId,
        );

        _updateMediaProcess(
          _mediaProcessValue.updateWhere(
            where: (process) => process.mediaId == media.id,
            update: (element) => element.copyWith(
              status: AppMediaProcessStatus.uploadingSuccess,
              response: uploadedMedia,
            ),
          ),
        );
      } catch (error) {
        _updateMediaProcess(_mediaProcessValue.updateWhere(
            where: (process) => process.mediaId == media.id,
            update: (element) => element.copyWith(
                status: AppMediaProcessStatus.uploadingFailed)));
      }
    }
    // Remove failed processes to upload process
    final mediaIds = medias.map((e) => e.id);
    _updateMediaProcess(_mediaProcessValue.toList()
      ..removeWhere((process) => mediaIds.contains(process.mediaId)));
  }

  void deleteMediasInGoogleDrive({required List<String> mediaIds}) async {
    _updateMediaProcess([
      ..._mediaProcessValue.toList(),
      ...mediaIds.map((id) =>
          AppMediaProcess(mediaId: id, status: AppMediaProcessStatus.waiting))

    ]);

    for (final mediaId in mediaIds) {
      //Skip process if queue does not contain mediaId
      if (!_mediaProcessValue.map((e) => e.mediaId).contains(mediaId)) {
        continue;
      }
      try {
        _updateMediaProcess(
          _mediaProcessValue.updateWhere(
            where: (process) => process.mediaId == mediaId,
            update: (element) =>
                element.copyWith(status: AppMediaProcessStatus.deleting),
          ),
        );

        await _googleDriveService.deleteMedia(mediaId);

        _updateMediaProcess(_mediaProcessValue.updateWhere(
            where: (process) => process.mediaId == mediaId,
            update: (element) =>
                element.copyWith(status: AppMediaProcessStatus.successDelete)));
      } catch (error) {
        _updateMediaProcess(_mediaProcessValue.updateWhere(
            where: (process) => process.mediaId == mediaId,
            update: (element) =>
                element.copyWith(status: AppMediaProcessStatus.failedDelete)));
      }
    }
    // Remove failed processes to upload process
    _updateMediaProcess(_mediaProcessValue.toList()
      ..removeWhere((process) => mediaIds.contains(process.mediaId)));
  }

  void terminateAllProcess() {
    _mediaProcessValue.clear();
    _mediaProcessController.add(_mediaProcessValue.toList());
  }

  void terminateSingleProcess(String id) {
    _mediaProcessValue.removeWhere((element) => element.mediaId == id);
    _mediaProcessController.add(_mediaProcessValue.toList());
  }

  void dispose() {
    _mediaProcessValue.clear();
    _mediaProcessController.close();
  }
}
