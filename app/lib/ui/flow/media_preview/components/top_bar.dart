import 'dart:io';
import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:style/theme/theme.dart';
import '../../../../domain/extensions/context_extensions.dart';
import '../../../../gen/assets.gen.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style/animations/cross_fade_animation.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../../../../components/app_dialog.dart';
import '../../../../domain/formatter/date_formatter.dart';
import '../../media_metadata_details/media_metadata_details.dart';
import '../media_preview_view_model.dart';
import 'package:share_plus/share_plus.dart';

class PreviewTopBar extends ConsumerStatefulWidget {
  final AutoDisposeStateNotifierProvider<MediaPreviewStateNotifier,
      MediaPreviewState> provider;
  final void Function() onAction;

  const PreviewTopBar({
    super.key,
    required this.provider,
    required this.onAction,
  });

  @override
  ConsumerState<PreviewTopBar> createState() => _PreviewTopBarState();
}

class _PreviewTopBarState extends ConsumerState<PreviewTopBar> {
  late MediaPreviewStateNotifier _notifier;

  @override
  void initState() {
    _notifier = ref.read(widget.provider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      widget.provider.select(
        (state) => (
          media: state.medias.elementAtOrNull(state.currentIndex),
          showAction: state.showActions,
          googleAccount: state.googleAccount,
          dropboxAccount: state.dropboxAccount,
        ),
      ),
    );
    final media = state.media;

    return CrossFadeAnimation(
      showChild: state.showAction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      appColorSchemeDark.surface.withValues(alpha: 0.8),
                      appColorSchemeDark.surface.withValues(alpha: 0.2),
                    ],
                  ),
                ),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: appColorSchemeDark.textPrimary,
                  title: Text(
                    media?.createdTime
                            ?.format(context, DateFormatType.relative) ??
                        '',
                  ),
                  actions: media == null
                      ? null
                      : [
                          ActionButton(
                            onPressed: () {
                              showMenu(
                                context: context,
                                position: RelativeRect.fromSize(
                                  Rect.fromLTRB(
                                    context.mediaQuerySize.width,
                                    50,
                                    0,
                                    0,
                                  ),
                                  context.mediaQuerySize, // Size of the screen
                                ),
                                elevation: 1,
                                surfaceTintColor: context.colorScheme.surface,
                                color: context.colorScheme.surface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                items: [
                                  infoAction(context, media),
                                  if (!media.sources.contains(
                                        AppMediaSource.googleDrive,
                                      ) &&
                                      media.sources
                                          .contains(AppMediaSource.local) &&
                                      state.googleAccount != null)
                                    _uploadToGoogleDriveAction(context, media),
                                  if (media.sources.contains(
                                        AppMediaSource.googleDrive,
                                      ) &&
                                      !media.sources
                                          .contains(AppMediaSource.local) &&
                                      state.googleAccount != null)
                                    _downloadFromGoogleDriveAction(
                                      context,
                                      media,
                                    ),
                                  if (media.sources.contains(
                                        AppMediaSource.googleDrive,
                                      ) &&
                                      state.googleAccount != null)
                                    _deleteFromGoogleDriveAction(
                                      context,
                                      media,
                                    ),
                                  if (!media.sources
                                          .contains(AppMediaSource.dropbox) &&
                                      media.sources
                                          .contains(AppMediaSource.local) &&
                                      state.dropboxAccount != null)
                                    _uploadToDropboxAction(context, media),
                                  if (media.sources
                                          .contains(AppMediaSource.dropbox) &&
                                      !media.sources
                                          .contains(AppMediaSource.local) &&
                                      state.dropboxAccount != null)
                                    _downloadFromDropboxAction(context, media),
                                  if (media.sources
                                          .contains(AppMediaSource.dropbox) &&
                                      state.dropboxAccount != null)
                                    _deleteFromDropboxAction(context, media),
                                  if (media.sources
                                      .contains(AppMediaSource.local))
                                    _deleteFromDeviceAction(context, media),
                                  if (media.sources
                                      .contains(AppMediaSource.local))
                                    _shareAction(context, media),
                                ],
                              );
                            },
                            icon: Icon(
                              Icons.more_vert_rounded,
                              color: appColorSchemeDark.textPrimary,
                              size: 22,
                            ),
                          ),
                        ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem infoAction(BuildContext context, AppMedia media) {
    return PopupMenuItem(
      onTap: () {
        widget.onAction();
        MediaMetadataDetailsScreen.show(context, media);
      },
      child: Row(
        children: [
          Icon(
            CupertinoIcons.info,
            color: context.colorScheme.textSecondary,
            size: 22,
          ),
          const SizedBox(width: 16),
          Text(
            context.l10n.common_info,
            style: AppTextStyles.body2.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem _uploadToGoogleDriveAction(
    BuildContext context,
    AppMedia media,
  ) {
    return PopupMenuItem(
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0, right: 8),
                child: Icon(
                  CupertinoIcons.cloud_upload,
                  color: context.colorScheme.textSecondary,
                  size: 20,
                ),
              ),
              SvgPicture.asset(
                Assets.images.icGoogleDrive,
                width: 14,
                height: 14,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Text(
            context.l10n.upload_to_google_drive_title,
            style: AppTextStyles.body2.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          ),
        ],
      ),
      onTap: () {
        showAppAlertDialog(
          context: context,
          title: context.l10n.upload_to_google_drive_title,
          message: context.l10n.upload_to_google_drive_confirmation_message,
          actions: [
            AppAlertAction(
              title: context.l10n.common_cancel,
              onPressed: () {
                context.pop();
              },
            ),
            AppAlertAction(
              title: context.l10n.common_upload,
              onPressed: () {
                _notifier.uploadMediaInGoogleDrive(media: media);
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  PopupMenuItem _downloadFromGoogleDriveAction(
    BuildContext context,
    AppMedia media,
  ) {
    return PopupMenuItem(
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0, right: 8),
                child: Icon(
                  CupertinoIcons.cloud_download,
                  color: context.colorScheme.textSecondary,
                  size: 20,
                ),
              ),
              SvgPicture.asset(
                Assets.images.icGoogleDrive,
                width: 14,
                height: 14,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Text(
            context.l10n.download_from_google_drive_title,
            style: AppTextStyles.body2.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          ),
        ],
      ),
      onTap: () {
        showAppAlertDialog(
          context: context,
          title: context.l10n.download_from_google_drive_title,
          message: context.l10n.download_from_google_drive_confirmation_message,
          actions: [
            AppAlertAction(
              title: context.l10n.common_cancel,
              onPressed: () {
                context.pop();
              },
            ),
            AppAlertAction(
              title: context.l10n.common_download,
              onPressed: () {
                _notifier.downloadFromGoogleDrive(media: media);
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  PopupMenuItem _deleteFromGoogleDriveAction(
    BuildContext context,
    AppMedia media,
  ) {
    return PopupMenuItem(
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2, right: 2),
                child: Icon(
                  CupertinoIcons.trash,
                  color: context.colorScheme.textSecondary,
                  size: 20,
                ),
              ),
              SvgPicture.asset(
                Assets.images.icGoogleDrive,
                width: 14,
                height: 14,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Text(
            context.l10n.delete_from_google_drive_title,
            style: AppTextStyles.body2.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          ),
        ],
      ),
      onTap: () {
        showAppAlertDialog(
          context: context,
          title: context.l10n.delete_from_google_drive_title,
          message: context.l10n.delete_from_google_drive_confirmation_message,
          actions: [
            AppAlertAction(
              title: context.l10n.common_cancel,
              onPressed: () {
                context.pop();
              },
            ),
            AppAlertAction(
              isDestructiveAction: true,
              title: context.l10n.common_delete,
              onPressed: () {
                _notifier.deleteMediaFromGoogleDrive(media.driveMediaRefId!);
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  PopupMenuItem _uploadToDropboxAction(
    BuildContext context,
    AppMedia media,
  ) {
    return PopupMenuItem(
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0, right: 8),
                child: Icon(
                  CupertinoIcons.cloud_upload,
                  color: context.colorScheme.textSecondary,
                  size: 20,
                ),
              ),
              SvgPicture.asset(
                Assets.images.icDropbox,
                width: 14,
                height: 14,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Text(
            context.l10n.upload_to_dropbox_title,
            style: AppTextStyles.body2.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          ),
        ],
      ),
      onTap: () {
        showAppAlertDialog(
          context: context,
          title: context.l10n.upload_to_dropbox_title,
          message: context.l10n.upload_to_dropbox_confirmation_message,
          actions: [
            AppAlertAction(
              title: context.l10n.common_cancel,
              onPressed: () {
                context.pop();
              },
            ),
            AppAlertAction(
              title: context.l10n.common_upload,
              onPressed: () {
                _notifier.uploadMediaInDropbox(media: media);
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  PopupMenuItem _downloadFromDropboxAction(
    BuildContext context,
    AppMedia media,
  ) {
    return PopupMenuItem(
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0, right: 8),
                child: Icon(
                  CupertinoIcons.cloud_download,
                  color: context.colorScheme.textSecondary,
                  size: 20,
                ),
              ),
              SvgPicture.asset(
                Assets.images.icDropbox,
                width: 14,
                height: 14,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Text(
            context.l10n.download_from_dropbox_title,
            style: AppTextStyles.body2.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          ),
        ],
      ),
      onTap: () {
        showAppAlertDialog(
          context: context,
          title: context.l10n.download_from_dropbox_title,
          message: context.l10n.download_from_dropbox_confirmation_message,
          actions: [
            AppAlertAction(
              title: context.l10n.common_cancel,
              onPressed: () {
                context.pop();
              },
            ),
            AppAlertAction(
              title: context.l10n.common_download,
              onPressed: () {
                _notifier.downloadFromDropbox(media: media);
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  PopupMenuItem _deleteFromDropboxAction(
    BuildContext context,
    AppMedia media,
  ) {
    return PopupMenuItem(
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2, right: 2),
                child: Icon(
                  CupertinoIcons.trash,
                  color: context.colorScheme.textSecondary,
                  size: 20,
                ),
              ),
              SvgPicture.asset(
                Assets.images.icDropbox,
                width: 14,
                height: 14,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Text(
            context.l10n.delete_from_dropbox_title,
            style: AppTextStyles.body2.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          ),
        ],
      ),
      onTap: () {
        showAppAlertDialog(
          context: context,
          title: context.l10n.delete_from_dropbox_title,
          message: context.l10n.delete_from_dropbox_confirmation_message,
          actions: [
            AppAlertAction(
              title: context.l10n.common_cancel,
              onPressed: () {
                context.pop();
              },
            ),
            AppAlertAction(
              isDestructiveAction: true,
              title: context.l10n.common_delete,
              onPressed: () {
                _notifier.deleteMediaFromDropbox(media.dropboxMediaRefId!);
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  PopupMenuItem _deleteFromDeviceAction(
    BuildContext context,
    AppMedia media,
  ) {
    return PopupMenuItem(
      child: Row(
        children: [
          Icon(
            CupertinoIcons.delete,
            color: context.colorScheme.textSecondary,
            size: 22,
          ),
          const SizedBox(width: 16),
          Text(
            context.l10n.delete_from_device_title,
            style: AppTextStyles.body2.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          ),
        ],
      ),
      onTap: () {
        showAppAlertDialog(
          context: context,
          title: context.l10n.delete_from_device_title,
          message: context.l10n.delete_from_device_confirmation_message,
          actions: [
            AppAlertAction(
              title: context.l10n.common_cancel,
              onPressed: () {
                context.pop();
              },
            ),
            AppAlertAction(
              isDestructiveAction: true,
              title: context.l10n.common_delete,
              onPressed: () {
                _notifier.deleteMediaFromLocal(media.id);
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  PopupMenuItem _shareAction(BuildContext context, AppMedia media) {
    return PopupMenuItem(
      onTap: () async {
        await Share.shareXFiles([XFile(media.path)]);
      },
      child: Row(
        children: [
          Icon(
            Platform.isIOS ? CupertinoIcons.share : Icons.share_rounded,
            color: context.colorScheme.textSecondary,
            size: 22,
          ),
          const SizedBox(width: 16),
          Text(
            context.l10n.common_share,
            style: AppTextStyles.body2.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
