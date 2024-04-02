import 'dart:io';
import 'package:cloud_gallery/components/app_page.dart';
import 'package:cloud_gallery/components/error_view.dart';
import 'package:cloud_gallery/components/snack_bar.dart';
import 'package:cloud_gallery/domain/assets/assets_paths.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/domain/formatter/date_formatter.dart';
import 'package:cloud_gallery/ui/flow/media_preview/components/image_preview_screen.dart';
import 'package:cloud_gallery/ui/flow/media_preview/media_preview_view_model.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../../../components/app_dialog.dart';
import 'components/video_preview_screen.dart';

class MediaPreview extends ConsumerStatefulWidget {
  final List<AppMedia> medias;
  final String startingMediaId;

  const MediaPreview(
      {super.key, required this.medias, required this.startingMediaId});

  @override
  ConsumerState<MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends ConsumerState<MediaPreview> {
  late AutoDisposeStateNotifierProvider<MediaPreviewStateNotifier,
      MediaPreviewState> _provider;
  late PageController _pageController;
  late MediaPreviewStateNotifier notifier;

  @override
  void initState() {
    final currentIndex = widget.medias
        .indexWhere((element) => element.id == widget.startingMediaId);

    //initialize view notifier with initial state
    _provider = mediaPreviewStateNotifierProvider(
        MediaPreviewState(currentIndex: currentIndex, medias: widget.medias));
    notifier = ref.read(_provider.notifier);

    _pageController = PageController(initialPage: currentIndex);
    super.initState();
  }

  void _observeError() {
    ref.listen(
      _provider,
      (previous, next) {
        if (next.error != null) {
          showErrorSnackBar(context: context, error: next.error!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _observeError();
    final medias = ref.watch(_provider.select((state) => state.medias));
    return AppPage(
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: notifier.toggleManu,
            child: PageView.builder(
              onPageChanged: notifier.changeVisibleMediaIndex,
              controller: _pageController,
              itemCount: medias.length,
              itemBuilder: (context, index) =>
                  _preview(context: context, media: medias[index]),
            ),
          ),
          _actions(context: context),
        ],
      ),
    );
  }

  Widget _preview({required BuildContext context, required AppMedia media}) {
    if (media.type.isVideo) {
      return VideoPreview(media: media);
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
              ref.watch(_provider.select((state) => state.showManu));
          return AnimatedCrossFade(
            crossFadeState:
                showManu ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: AdaptiveAppBar(
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
            secondChild: const SizedBox(
              width: double.infinity,
            ),
            firstCurve: Curves.easeInOut,
            secondCurve: Curves.easeInOut,
            duration: const Duration(milliseconds: 200),
            reverseDuration: const Duration(milliseconds: 200),
          );
        },
      );

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
