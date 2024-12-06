import 'dart:io';
import 'package:data/storage/app_preferences.dart';
import '../../../components/app_page.dart';
import '../../../components/error_view.dart';
import '../../../components/snack_bar.dart';
import '../../../domain/extensions/context_extensions.dart';
import '../../../domain/extensions/widget_extensions.dart';
import 'components/download_require_view.dart';
import 'components/image_preview_screen.dart';
import 'components/top_bar.dart';
import 'components/video_player_components/video_actions.dart';
import 'media_preview_view_model.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:video_player/video_player.dart';
import 'components/video_player_components/video_duration_slider.dart';
import 'package:style/animations/dismissible_page.dart';

class MediaPreview extends ConsumerStatefulWidget {
  final List<AppMedia> medias;
  final String startFrom;

  const MediaPreview({
    super.key,
    required this.medias,
    required this.startFrom,
  });

  @override
  ConsumerState<MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends ConsumerState<MediaPreview> {
  late AutoDisposeStateNotifierProvider<MediaPreviewStateNotifier,
      MediaPreviewState> _provider;
  late PageController _pageController;
  late MediaPreviewStateNotifier _notifier;

  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    final currentIndex =
        widget.medias.indexWhere((element) => element.id == widget.startFrom);

    _provider = mediaPreviewStateNotifierProvider(
      (startIndex: currentIndex, medias: widget.medias),
    );
    _notifier = ref.read(_provider.notifier);

    _pageController = PageController(initialPage: currentIndex, keepPage: true);

    if (widget.medias[currentIndex].type.isVideo &&
        widget.medias[currentIndex].sources.contains(AppMediaSource.local)) {
      runPostFrame(
        () => _initializeVideoControllerWithListener(
          path: widget.medias[currentIndex].path,
        ),
      );
    }
    super.initState();
  }

  Future<void> _initializeVideoControllerWithListener({
    required String path,
  }) async {
    _videoPlayerController = VideoPlayerController.file(File(path));
    _videoPlayerController?.addListener(_observeVideoController);
    await _videoPlayerController?.initialize();
    _notifier.updateVideoInitialized(
      _videoPlayerController?.value.isInitialized ?? false,
    );
    await _videoPlayerController?.play();
  }

  void _observeVideoController() {
    _notifier.updateVideoInitialized(
      _videoPlayerController?.value.isInitialized ?? false,
    );
    _notifier.updateVideoBuffering(
      _videoPlayerController?.value.isBuffering ?? false,
    );
    _notifier.updateVideoPosition(
      _videoPlayerController?.value.position ?? Duration.zero,
    );
    _notifier.updateVideoMaxDuration(
      _videoPlayerController?.value.duration ?? Duration.zero,
    );
    _notifier
        .updateVideoPlaying(_videoPlayerController?.value.isPlaying ?? false);
  }

  void _observeError() {
    ref.listen(
      _provider.select((value) => value.error),
      (previous, next) {
        if (next != null) {
          showErrorSnackBar(context: context, error: next);
        }
      },
    );
  }

  void _updateVideoControllerOnMediaChange() {
    ref.listen(_provider.select((value) => value.medias[value.currentIndex]),
        (previous, next) {
      if (_videoPlayerController != null) {
        _videoPlayerController?.removeListener(_observeVideoController);
        _notifier.updateVideoInitialized(false);
        _videoPlayerController?.dispose();
        _videoPlayerController = null;
      }
      if (next.type.isVideo && next.sources.contains(AppMediaSource.local)) {
        _initializeVideoControllerWithListener(path: next.path);
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(_observeVideoController);
    _videoPlayerController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _observeError();
    _updateVideoControllerOnMediaChange();

    final ({List<AppMedia> medias, bool showActions}) state = ref.watch(
      _provider.select(
        (state) => (
          medias: state.medias,
          showActions: state.showActions,
        ),
      ),
    );
    return DismissiblePage(
      backgroundColor: context.colorScheme.surface,
      onProgress: (progress) {
        if (progress > 0 && state.showActions) {
          _notifier.toggleActionVisibility();
        }
      },
      onDismiss: () {
        context.pop();
      },
      child: (progress) => AppPage(
        backgroundColor:
            progress == 0 ? context.colorScheme.surface : Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _notifier.toggleActionVisibility,
              child: PageView.builder(
                onPageChanged: _notifier.changeVisibleMediaIndex,
                controller: _pageController,
                itemCount: state.medias.length,
                itemBuilder: (context, index) =>
                    _preview(context: context, media: state.medias[index]),
              ),
            ),
            PreviewTopBar(
              provider: _provider,
              onAction: () {
                if (_videoPlayerController != null &&
                    (_videoPlayerController?.value.isInitialized ?? false)) {
                  _videoPlayerController?.pause();
                }
              },
            ),
            _videoActions(context),
            _videoDurationSlider(context),
          ],
        ),
      ),
    );
  }

  Widget _preview({required BuildContext context, required AppMedia media}) {
    if (media.type.isVideo && media.sources.contains(AppMediaSource.local)) {
      return Center(
        child: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(
              _provider.select(
                (state) => (
                  initialized: state.isVideoInitialized,
                  buffring: state.isVideoBuffering
                ),
              ),
            );

            if (!state.initialized) {
              return AppCircularProgressIndicator(
                color: context.colorScheme.onPrimary,
              );
            }
            return Hero(
              tag: media,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController!),
                  ),
                  if (state.buffring)
                    AppCircularProgressIndicator(
                      color: context.colorScheme.onPrimary,
                    ),
                ],
              ),
            );
          },
        ),
      );
    } else if (media.type.isVideo &&
        (media.isGoogleDriveStored || media.isDropboxStored)) {
      return _cloudVideoView(context: context, media: media);
    } else if (media.type.isImage) {
      return ImagePreview(media: media);
    } else {
      return ErrorView(
        title: context.l10n.unable_to_load_media_error,
        message: context.l10n.unable_to_load_media_message,
      );
    }
  }

  Widget _cloudVideoView({
    required BuildContext context,
    required AppMedia media,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        final process = ref.watch(
          _provider.select(
            (value) =>
                media.driveMediaRefId != null && media.isGoogleDriveStored
                    ? value.downloadMediaProcesses[media.driveMediaRefId]
                    : media.dropboxMediaRefId != null
                        ? value.downloadMediaProcesses[media.dropboxMediaRefId]
                        : null,
          ),
        );
        return DownloadRequireView(
          dropboxAccessToken:
              ref.read(AppPreferences.dropboxToken)?.access_token,
          media: media,
          downloadProcess: process,
          onDownload: () {
            if (media.isGoogleDriveStored) {
              _notifier.downloadFromGoogleDrive(media: media);
            } else if (media.isDropboxStored) {
              _notifier.downloadFromDropbox(media: media);
            }
          },
        );
      },
    );
  }

  Widget _videoActions(BuildContext context) => Consumer(
        builder: (context, ref, child) {
          final ({
            bool showActions,
            bool isPlaying,
            Duration position,
          }) state = ref.watch(
            _provider.select(
              (state) => (
                showActions: state.showActions &&
                    state.medias[state.currentIndex].type.isVideo &&
                    state.isVideoInitialized,
                isPlaying: state.isVideoPlaying,
                position: state.videoPosition,
              ),
            ),
          );

          return VideoActions(
            showActions: state.showActions,
            isPlaying: state.isPlaying,
            onBackward: () {
              _videoPlayerController
                  ?.seekTo(state.position - const Duration(seconds: 10));
            },
            onForward: () {
              _videoPlayerController
                  ?.seekTo(state.position + const Duration(seconds: 10));
            },
            onPlayPause: () {
              if (state.isPlaying) {
                _videoPlayerController?.pause();
              } else {
                _videoPlayerController?.play();
              }
            },
          );
        },
      );

  Widget _videoDurationSlider(BuildContext context) => Consumer(
        builder: (context, ref, child) {
          final ({
            bool showDurationSlider,
            Duration duration,
            Duration position
          }) state = ref.watch(
            _provider.select(
              (state) => (
                showDurationSlider: state.showActions &&
                    state.medias[state.currentIndex].type.isVideo &&
                    state.isVideoInitialized,
                duration: state.videoMaxDuration,
                position: state.videoPosition
              ),
            ),
          );
          return VideoDurationSlider(
            showSlider: state.showDurationSlider,
            duration: state.duration,
            position: state.position,
            onChangeEnd: (duration) {
              _videoPlayerController?.seekTo(duration);
            },
            onChanged: (duration) {
              _notifier.updateVideoPosition(duration);
            },
          );
        },
      );
}
