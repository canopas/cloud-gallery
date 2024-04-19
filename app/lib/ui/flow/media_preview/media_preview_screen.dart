import 'dart:io';
import 'package:cloud_gallery/components/app_page.dart';
import 'package:cloud_gallery/components/error_view.dart';
import 'package:cloud_gallery/components/snack_bar.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/domain/extensions/widget_extensions.dart';
import 'package:cloud_gallery/ui/flow/media_preview/components/download_require_view.dart';
import 'package:cloud_gallery/ui/flow/media_preview/components/image_preview_screen.dart';
import 'package:cloud_gallery/ui/flow/media_preview/components/top_bar.dart';
import 'package:cloud_gallery/ui/flow/media_preview/components/video_player_components/video_actions.dart';
import 'package:cloud_gallery/ui/flow/media_preview/media_preview_view_model.dart';
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

  const MediaPreview(
      {super.key, required this.medias, required this.startFrom});

  @override
  ConsumerState<MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends ConsumerState<MediaPreview> {
  late AutoDisposeStateNotifierProvider<MediaPreviewStateNotifier,
      MediaPreviewState> _provider;
  late PageController _pageController;
  late MediaPreviewStateNotifier notifier;

  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    final currentIndex =
        widget.medias.indexWhere((element) => element.id == widget.startFrom);

    //initialize view notifier with initial state
    _provider = mediaPreviewStateNotifierProvider(
        MediaPreviewState(currentIndex: currentIndex, medias: widget.medias));
    notifier = ref.read(_provider.notifier);

    _pageController = PageController(initialPage: currentIndex, keepPage: true);

    if (widget.medias[currentIndex].type.isVideo &&
        widget.medias[currentIndex].sources.contains(AppMediaSource.local)) {
      runPostFrame(() => _initializeVideoControllerWithListener(
          path: widget.medias[currentIndex].path));
    } else if (widget.medias[currentIndex].type.isVideo &&
        widget.medias[currentIndex].isGoogleDriveStored) {}
    super.initState();
  }

  Future<void> _initializeVideoControllerWithListener(
      {required String path}) async {
    _videoPlayerController = VideoPlayerController.file(File(path));
    _videoPlayerController?.addListener(_observeVideoController);
    await _videoPlayerController?.initialize();
    notifier.updateVideoInitialized(
        _videoPlayerController?.value.isInitialized ?? false);
    await _videoPlayerController?.play();
  }

  _observeVideoController() {
    notifier.updateVideoInitialized(
        _videoPlayerController?.value.isInitialized ?? false);
    notifier.updateVideoBuffering(
        _videoPlayerController?.value.isBuffering ?? false);
    notifier.updateVideoPosition(
        _videoPlayerController?.value.position ?? Duration.zero);
    notifier.updateVideoMaxDuration(
        _videoPlayerController?.value.duration ?? Duration.zero);
    notifier
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
        notifier.updateVideoInitialized(false);
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

    final ({List<AppMedia> medias, bool showActions}) state =
        ref.watch(_provider.select((state) => (
              medias: state.medias,
              showActions: state.showActions,
            )));
    return DismissiblePage(
      backgroundColor: context.colorScheme.surface,
      onProgress: (progress) {
        if (progress > 0 && state.showActions) {
          notifier.toggleActionVisibility();
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
              onTap: notifier.toggleActionVisibility,
              child: PageView.builder(
                onPageChanged: notifier.changeVisibleMediaIndex,
                controller: _pageController,
                itemCount: state.medias.length,
                itemBuilder: (context, index) =>
                    _preview(context: context, media: state.medias[index]),
              ),
            ),
            PreviewTopBar(provider: _provider),
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
        child: Consumer(builder: (context, ref, child) {
          ({bool initialized, bool buffring}) state = ref.watch(
              _provider.select((state) => (
                    initialized: state.isVideoInitialized,
                    buffring: state.isVideoBuffering
                  )));

          if (!state.initialized || state.buffring) {
            return AppCircularProgressIndicator(
              color: context.colorScheme.onPrimary,
            );
          } else {
            return Hero(
              tag: media,
              child: AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController!),
              ),
            );
          }
        }),
      );
    } else if (media.type.isVideo && media.isGoogleDriveStored) {
      return _googleDriveVideoView(context: context, media: media);
    } else if (media.type.isImage) {
      return ImagePreview(media: media);
    } else {
      return ErrorView(
        title: context.l10n.unable_to_load_media_error,
        message: context.l10n.unable_to_load_media_message,
      );
    }
  }

  Widget _googleDriveVideoView(
      {required BuildContext context, required AppMedia media}) {
    return Consumer(
      builder: (context, ref, child) {
        final process = ref.watch(_provider.select((value) => value
            .downloadProcess
            .where((element) => element.id == media.id)
            .firstOrNull));
        return DownloadRequireView(
            media: media,
            downloadProcess: process,
            onDownload: () {
              notifier.downloadMediaFromGoogleDrive(media: media);
            });
      },
    );
  }

  Widget _videoActions(BuildContext context) => Consumer(
        builder: (context, ref, child) {
          final ({
            bool showActions,
            bool isPlaying,
            Duration position,
          }) state = ref.watch(_provider.select((state) => (
                showActions: state.showActions &&
                    state.medias[state.currentIndex].type.isVideo &&
                    state.isVideoInitialized,
                isPlaying: state.isVideoPlaying,
                position: state.videoPosition,
              )));

          return VideoActions(
            showActions: state.showActions,
            isPlaying: state.isPlaying,
            onBackward: () {
              notifier.updateVideoPosition(
                  state.position - const Duration(seconds: 10));
              _videoPlayerController
                  ?.seekTo(state.position - const Duration(seconds: 10));
            },
            onForward: () {
              notifier.updateVideoPosition(
                  state.position + const Duration(seconds: 10));
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

  Widget _videoDurationSlider(BuildContext context) =>
      Consumer(builder: (context, ref, child) {
        final ({
          bool showDurationSlider,
          Duration duration,
          Duration position
        }) state = ref.watch(_provider.select((state) => (
              showDurationSlider: state.showActions &&
                  state.medias[state.currentIndex].type.isVideo &&
                  state.isVideoInitialized,
              duration: state.videoMaxDuration,
              position: state.videoPosition
            )));
        return VideoDurationSlider(
          showSlider: state.showDurationSlider,
          duration: state.duration,
          position: state.position,
          onChangeEnd: (duration) {
            _videoPlayerController?.seekTo(duration);
          },
          onChanged: (duration) {
            notifier.updateVideoPosition(duration);
          },
        );
      });
}
