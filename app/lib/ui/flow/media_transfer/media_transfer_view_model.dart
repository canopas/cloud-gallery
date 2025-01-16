import 'package:data/models/media_process/media_process.dart';
import 'package:data/repositories/media_process_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_transfer_view_model.freezed.dart';

final mediaTransferStateNotifierProvider = StateNotifierProvider.autoDispose<
    MediaTransferStateNotifier, MediaTransferState>(
  (ref) => MediaTransferStateNotifier(ref.read(mediaProcessRepoProvider)),
);

class MediaTransferStateNotifier extends StateNotifier<MediaTransferState> {
  final MediaProcessRepo _mediaProcessRepo;

  MediaTransferStateNotifier(this._mediaProcessRepo)
      : super(const MediaTransferState()) {
    _listenMediaProcess();
    _mediaProcessRepo.addListener(_listenMediaProcess);
  }

  void _listenMediaProcess() {
    state = state.copyWith(
      downloadProcesses: _mediaProcessRepo.downloadQueue.toList(),
      uploadProcesses: _mediaProcessRepo.uploadQueue.toList(),
    );
  }

  void onPageChange(int value) {
    state = state.copyWith(page: value);
  }

  void onTerminateUploadProcess(String id) {
    _mediaProcessRepo.terminateUploadProcess(id);
  }

  void onRemoveUploadProcess(String id) {
    _mediaProcessRepo.removeItemFromUploadQueue(id);
  }

  void onPauseUploadProcess(String id) {
    _mediaProcessRepo.pauseUploadProcess(id);
  }

  void onResumeUploadProcess(String id) {
    _mediaProcessRepo.resumeUploadProcess(id);
  }

  void onRemoveDownloadProcess(String id) {
    _mediaProcessRepo.removeItemFromDownloadQueue(id);
  }

  void onTerminateDownloadProcess(String id) {
    _mediaProcessRepo.terminateDownloadProcess(id);
  }

  @override
  void dispose() {
    _mediaProcessRepo.removeListener(_listenMediaProcess);
    super.dispose();
  }
}

@freezed
class MediaTransferState with _$MediaTransferState {
  const factory MediaTransferState({
    Object? error,
    @Default([]) List<UploadMediaProcess> uploadProcesses,
    @Default([]) List<DownloadMediaProcess> downloadProcesses,
    @Default(0) int page,
  }) = _MediaTransferState;
}
