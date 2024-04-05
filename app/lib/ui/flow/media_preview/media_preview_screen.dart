import 'dart:io';
import 'package:cloud_gallery/components/app_page.dart';
import 'package:cloud_gallery/components/error_view.dart';
import 'package:cloud_gallery/components/snack_bar.dart';
import 'package:cloud_gallery/domain/assets/assets_paths.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/domain/extensions/widget_extensions.dart';
import 'package:cloud_gallery/domain/formatter/date_formatter.dart';
import 'package:cloud_gallery/ui/flow/media_preview/components/image_preview_screen.dart';
import 'package:cloud_gallery/ui/flow/media_preview/components/video_player_components/video_actions.dart';
import 'package:cloud_gallery/ui/flow/media_preview/media_preview_view_model.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:style/text/app_text_style.dart';
import 'package:video_player/video_player.dart';
import '../../../components/app_dialog.dart';
import 'package:style/animations/cross_fade_animation.dart';
import 'components/video_player_components/video_duration_slider.dart';

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
    final medias = ref.watch(_provider.select((state) => state.medias));

    return AppPage(
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: notifier.toggleActionVisibility,
            child: PageView.builder(
              onPageChanged: notifier.changeVisibleMediaIndex,
              controller: _pageController,
              itemCount: medias.length,
              itemBuilder: (context, index) =>
                  _preview(context: context, media: medias[index]),
            ),
          ),
          _actions(context: context),
          _videoActions(context),
          _videoDurationSlider(context),
        ],
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
            return AspectRatio(
              aspectRatio: _videoPlayerController!.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController!),
            );
          }
        }),
      );
    } else if (media.type.isVideo && media.isGoogleDriveStored) {
      return Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              height: double.infinity,
              width: double.infinity,
              media.thumbnailLink!,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black38,
              child: ErrorView(
                foregroundColor: context.colorScheme.onPrimary,
                icon: Icon(CupertinoIcons.cloud_download,
                    size: 68, color: context.colorScheme.onPrimary),
                title: "Download Required",
                message:
                    "To watch the video, simply download it first. Tap the download button to begin.",
                action: ErrorViewAction(title: "Download", onPressed: () {}),
              ),
            ),
          ],
        ),
      );
    } else if (media.type.isImage) {
      return ImagePreview(media: media);
    } else {
      return ErrorView(
        title: context.l10n.unable_to_load_media_error,
        message: context.l10n.unable_to_load_media_message,
      );
    }
  }

  Widget _actions({required BuildContext context}) => Consumer(
        builder: (context, ref, child) {
          final media = ref.watch(
              _provider.select((state) => state.medias[state.currentIndex]));
          final showManu =
              ref.watch(_provider.select((state) => state.showActions));
          return CrossFadeAnimation(
            showChild: showManu,
            child: AdaptiveAppBar(
              text:
                  media.createdTime?.format(context, DateFormatType.relative) ??
                      '',
              actions: [
                ActionButton(
                  onPressed: () {
                    ///TODO: media details
                  },
                  icon: Icon(
                    CupertinoIcons.info,
                    color: context.colorScheme.textSecondary,
                    size: 22,
                  ),
                ),
                ActionButton(
                  onPressed: () async {
                    if (media.isCommonStored && media.driveMediaRefId != null) {
                      showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                              double.infinity,
                              kToolbarHeight +
                                  MediaQuery.of(context).padding.top,
                              0,
                              0),
                          surfaceTintColor: context.colorScheme.surface,
                          color: context.colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          items: <PopupMenuEntry>[
                            PopupMenuItem(
                              onTap: () async {
                                await showDeleteAlert(
                                    context: context,
                                    onDelete: () {
                                      notifier.deleteMediaFromGoogleDrive(
                                          media.driveMediaRefId);
                                      context.pop();
                                    });
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    Assets.images.icons.googlePhotos,
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 16),
                                  Text("Delete from Google Drive",
                                      style: AppTextStyles.body2.copyWith(
                                        color: context.colorScheme.textPrimary,
                                      )),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () async {
                                await showDeleteAlert(
                                    context: context,
                                    onDelete: () {
                                      notifier.deleteMediaFromLocal(media.id);
                                      context.pop();
                                    });
                              },
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.trash,
                                      color: context.colorScheme.textSecondary,
                                      size: 22),
                                  const SizedBox(width: 16),
                                  Text(
                                    "Delete from Device",
                                    style: AppTextStyles.body2.copyWith(
                                      color: context.colorScheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                    } else if (media.isGoogleDriveStored &&
                        media.driveMediaRefId != null) {
                      await showDeleteAlert(
                          context: context,
                          onDelete: () {
                            notifier.deleteMediaFromGoogleDrive(
                                media.driveMediaRefId);
                            context.pop();
                          });
                    } else if (media.isLocalStored) {
                      await showDeleteAlert(
                          context: context,
                          onDelete: () {
                            notifier.deleteMediaFromLocal(media.id);
                            context.pop();
                          });
                    }
                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      CupertinoIcons.delete,
                      color: context.colorScheme.textSecondary,
                      size: 22,
                    ),
                  ),
                ),
                if (!Platform.isIOS && !Platform.isMacOS)
                  const SizedBox(width: 8),
              ],
            ),
          );
        },
      );

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
          onChanged: (duration) {
            notifier.updateVideoPosition(duration);
            _videoPlayerController?.seekTo(duration);
          },
        );
      });

  Future<void> showDeleteAlert(
      {required BuildContext context, required VoidCallback onDelete}) async {
    await showAppAlertDialog(
      context: context,
      title: "Delete",
      message:
          "Are you sure you want to delete this media? It will be permanently removed.",
      actions: [
        AppAlertAction(
          title: "Cancel",
          onPressed: () {
            context.pop();
          },
        ),
        AppAlertAction(
          isDestructiveAction: true,
          title: "Delete",
          onPressed: onDelete,
        ),
      ],
    );
  }
}
