import '../../../domain/extensions/media_list_extension.dart';
import 'package:data/models/app_process/app_process.dart';
import 'package:data/models/media/media.dart';
import 'package:data/repositories/google_drive_process_repo.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_preview_view_model.freezed.dart';

final mediaPreviewStateNotifierProvider = StateNotifierProvider.family
    .autoDispose<MediaPreviewStateNotifier, MediaPreviewState,
        MediaPreviewState>(
  (ref, initial) => MediaPreviewStateNotifier(
    ref.read(localMediaServiceProvider),
    ref.read(googleDriveServiceProvider),
    ref.read(googleDriveProcessRepoProvider),
    initial,
  ),
);

class MediaPreviewStateNotifier extends StateNotifier<MediaPreviewState> {
  final LocalMediaService _localMediaService;
  final GoogleDriveService _googleDriveService;
  final GoogleDriveProcessRepo _googleDriveProcessRepo;

  MediaPreviewStateNotifier(
    this._localMediaService,
    this._googleDriveService,
    this._googleDriveProcessRepo,
    MediaPreviewState initialState,
  ) : super(initialState) {
    _googleDriveProcessRepo.addListener(_listenGoogleDriveProcessUpdates);
  }

  void _listenGoogleDriveProcessUpdates() {
    final successUploads = _googleDriveProcessRepo.uploadQueue
        .where((element) => element.status.isSuccess);

    final successDeletes = _googleDriveProcessRepo.deleteQueue
        .where((element) => element.status.isSuccess)
        .map((e) => e.id);

    final successDownloads = _googleDriveProcessRepo.downloadQueue
        .where((element) => element.status.isSuccess);

    if (successUploads.isNotEmpty) {
      state = state.copyWith(
        medias: state.medias.toList()
          ..addGoogleDriveRefInMedias(
            process: successUploads.toList(),
          ),
      );
    }

    if (successDeletes.isNotEmpty) {
      state = state.copyWith(
        medias: state.medias.toList()
          ..removeGoogleDriveRefFromMedias(
            removeFromIds: successDeletes.toList(),
          ),
      );
    }
    if (successDownloads.isNotEmpty) {
      state = state.copyWith(
        medias: state.medias.toList()
          ..replaceMediaRefInMedias(
            process: successDownloads.toList(),
          ),
      );
    }

    state = state.copyWith(
      uploadProcess: _googleDriveProcessRepo.uploadQueue,
      downloadProcess: _googleDriveProcessRepo.downloadQueue,
      deleteProcess: _googleDriveProcessRepo.deleteQueue,
    );
  }

  void changeVisibleMediaIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void toggleActionVisibility() {
    state = state.copyWith(showActions: !state.showActions);
  }

  Future<void> deleteMediaFromLocal(String id) async {
    try {
      await _localMediaService.deleteMedias([id]);
      state = state.copyWith(
        medias: state.medias.where((element) => element.id != id).toList(),
      );
    } catch (error) {
      state = state.copyWith(error: error);
    }
  }

  Future<void> deleteMediaFromGoogleDrive(String? id) async {
    try {
      await _googleDriveService.deleteMedia(id: id!);
    } catch (error) {
      state = state.copyWith(error: error);
    }
  }

  Future<void> downloadMediaFromGoogleDrive({required AppMedia media}) async {
    _googleDriveProcessRepo.downloadMediasFromGoogleDrive(medias: [media]);
  }

  Future<void> uploadMediaInGoogleDrive({required AppMedia media}) async {
    _googleDriveProcessRepo.uploadMedia([media]);
  }

  void updateVideoPosition(Duration position) {
    if (state.videoPosition == position) return;
    state = state.copyWith(videoPosition: position);
  }

  void updateVideoPlaying(bool isPlaying) {
    if (state.isVideoPlaying == isPlaying) return;
    state = state.copyWith(isVideoPlaying: isPlaying);
  }

  void updateVideoBuffering(bool isBuffering) {
    if (state.isVideoBuffering == isBuffering) return;
    state = state.copyWith(isVideoBuffering: isBuffering);
  }

  void updateVideoInitialized(bool isInitialized) {
    if (state.isVideoInitialized == isInitialized) return;
    state = state.copyWith(isVideoInitialized: isInitialized);
  }

  void updateVideoMaxDuration(Duration maxDuration) {
    if (state.videoMaxDuration == maxDuration) return;
    state = state.copyWith(videoMaxDuration: maxDuration);
  }

  @override
  void dispose() {
    _googleDriveProcessRepo.removeListener(_listenGoogleDriveProcessUpdates);
    super.dispose();
  }
}

@freezed
class MediaPreviewState with _$MediaPreviewState {
  const factory MediaPreviewState({
    Object? error,
    @Default([]) List<AppMedia> medias,
    @Default(0) int currentIndex,
    @Default(true) bool showActions,
    @Default(false) bool isVideoInitialized,
    @Default(false) bool isVideoBuffering,
    @Default(Duration.zero) Duration videoPosition,
    @Default(Duration.zero) Duration videoMaxDuration,
    @Default(false) bool isVideoPlaying,
    @Default([]) List<AppProcess> uploadProcess,
    @Default([]) List<AppProcess> downloadProcess,
    @Default([]) List<AppProcess> deleteProcess,
  }) = _MediaPreviewState;
}
