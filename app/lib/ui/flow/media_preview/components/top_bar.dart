import 'dart:io';
import '../../../../domain/extensions/context_extensions.dart';
import '../../../navigation/app_route.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style/animations/cross_fade_animation.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../../../../components/app_dialog.dart';
import '../../../../components/app_page.dart';
import '../../../../domain/assets/assets_paths.dart';
import '../../../../domain/formatter/date_formatter.dart';
import '../media_preview_view_model.dart';
import 'package:share_plus/share_plus.dart';

class PreviewTopBar extends StatelessWidget {
  final AutoDisposeStateNotifierProvider<MediaPreviewStateNotifier,
      MediaPreviewState> provider;
  final void Function() onAction;

  const PreviewTopBar({
    super.key,
    required this.provider,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final notifier = ref.read(provider.notifier);
        final media = ref.watch(
          provider.select((state) => state.medias[state.currentIndex]),
        );
        final showManu =
            ref.watch(provider.select((state) => state.showActions));

        return CrossFadeAnimation(
          showChild: showManu,
          child: AdaptiveAppBar(
            iosTransitionBetweenRoutes: false,
            text: media.createdTime?.format(context, DateFormatType.relative) ??
                '',
            actions: [
              ActionButton(
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromSize(
                      Rect.fromLTRB(context.mediaQuerySize.width, 50, 0, 0),
                      // Placeholder rect, will be overwritten
                      context.mediaQuerySize, // Size of the screen
                    ),
                    elevation: 1,
                    surfaceTintColor: context.colorScheme.surface,
                    color: context.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    items: [
                      PopupMenuItem(
                        onTap: () {
                          onAction();
                          MediaMetadataDetailsRoute($extra: media)
                              .push(context);
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
                      ),
                      if (media.isGoogleDriveStored)
                        PopupMenuItem(
                          onTap: () {
                            notifier.downloadMediaFromGoogleDrive(media: media);
                          },
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.cloud_download,
                                color: context.colorScheme.textSecondary,
                                size: 22,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                context.l10n.common_download,
                                style: AppTextStyles.body2.copyWith(
                                  color: context.colorScheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (media.isLocalStored)
                        PopupMenuItem(
                          onTap: () {
                            notifier.uploadMediaInGoogleDrive(media: media);
                          },
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.cloud_upload,
                                color: context.colorScheme.textSecondary,
                                size: 22,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                context.l10n.common_upload,
                                style: AppTextStyles.body2.copyWith(
                                  color: context.colorScheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (media.sources.contains(AppMediaSource.googleDrive))
                        PopupMenuItem(
                          onTap: () async {
                            _showDeleteFromDriveDialog(
                              context: context,
                              onDelete: () {
                                notifier.deleteMediaFromGoogleDrive(
                                  media.driveMediaRefId,
                                );
                                context.pop();
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 2,
                                      right: 2,
                                    ),
                                    child: Icon(
                                      CupertinoIcons.trash,
                                      color: context.colorScheme.textSecondary,
                                      size: 22,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    Assets.images.icons.googleDrive,
                                    width: 14,
                                    height: 14,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Text(
                                context.l10n.common_delete_from_google_drive,
                                style: AppTextStyles.body2.copyWith(
                                  color: context.colorScheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (media.sources.contains(AppMediaSource.local))
                        PopupMenuItem(
                          onTap: () async {
                            _showDeleteFromDeviceDialog(
                              context: context,
                              onDelete: () {
                                notifier.deleteMediaFromLocal(media.id);
                                context.pop();
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.trash,
                                color: context.colorScheme.textSecondary,
                                size: 22,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                (media.isLocalStored)
                                    ? context.l10n.common_delete
                                    : context.l10n.common_delete_from_device,
                                style: AppTextStyles.body2.copyWith(
                                  color: context.colorScheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (media.isLocalStored)
                        PopupMenuItem(
                          onTap: () async {
                            await Share.shareXFiles([XFile(media.path)]);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Platform.isIOS
                                    ? CupertinoIcons.share
                                    : Icons.share_rounded,
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
                        ),
                    ],
                  );
                },
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: context.colorScheme.textSecondary,
                  size: 22,
                ),
              ),
              if (!Platform.isIOS && !Platform.isMacOS)
                const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDeleteFromDriveDialog({
    required BuildContext context,
    required void Function() onDelete,
  }) async {
    await showAppAlertDialog(
      context: context,
      title: context.l10n.common_delete_from_google_drive,
      message: context.l10n.delete_media_from_google_drive_confirmation_message,
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
          onPressed: onDelete,
        ),
      ],
    );
  }

  Future<void> _showDeleteFromDeviceDialog({
    required BuildContext context,
    required void Function() onDelete,
  }) async {
    await showAppAlertDialog(
      context: context,
      title: context.l10n.common_delete_from_device,
      message: context.l10n.delete_media_from_device_confirmation_message,
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
          onPressed: onDelete,
        ),
      ],
    );
  }
}
