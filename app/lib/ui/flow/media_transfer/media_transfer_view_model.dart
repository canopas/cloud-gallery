import 'package:data/models/app_process/app_process.dart';
import 'package:data/repositories/google_drive_process_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_transfer_view_model.freezed.dart';

final mediaTransferStateNotifierProvider = StateNotifierProvider.autoDispose<
    MediaTransferStateNotifier, MediaTransferState>(
  (ref) => MediaTransferStateNotifier(ref.read(googleDriveProcessRepoProvider)),
);

class MediaTransferStateNotifier extends StateNotifier<MediaTransferState> {
  final GoogleDriveProcessRepo _googleDriveProcessRepo;

  MediaTransferStateNotifier(this._googleDriveProcessRepo)
      : super(const MediaTransferState()) {
    _googleDriveProcessRepo.addListener(_listenGoogleDriveProcess);
  }

  void _listenGoogleDriveProcess() {
    state = state.copyWith(
      download: _googleDriveProcessRepo.downloadQueue.toList(),
      upload: _googleDriveProcessRepo.uploadQueue.toList(),
    );
  }

  void onPageChange(int value) {
    state = state.copyWith(page: value);
  }

  void onTerminateUploadProcess(String id) {
    _googleDriveProcessRepo.terminateUploadProcess(id);
  }

  void onTerminateDownloadProcess(String id) {
    _googleDriveProcessRepo.terminateDownloadProcess(id);
  }

  @override
  void dispose() {
    _googleDriveProcessRepo.removeListener(_listenGoogleDriveProcess);
    super.dispose();
  }
}

@freezed
class MediaTransferState with _$MediaTransferState {
  const factory MediaTransferState({
    Object? error,
    @Default([]) List<AppProcess> upload,
    @Default([]) List<AppProcess> download,
    @Default(0) int page,
  }) = _MediaTransferState;
}
