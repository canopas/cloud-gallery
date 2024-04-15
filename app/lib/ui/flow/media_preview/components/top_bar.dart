import 'dart:io';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/ui/navigation/app_router.dart';
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

class PreviewTopBar extends StatelessWidget {
  final AutoDisposeStateNotifierProvider<MediaPreviewStateNotifier,
      MediaPreviewState> provider;

  const PreviewTopBar({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.read(provider.notifier);
      final media = ref
          .watch(provider.select((state) => state.medias[state.currentIndex]));
      final showManu = ref.watch(provider.select((state) => state.showActions));

      return CrossFadeAnimation(
        showChild: showManu,
        child: AdaptiveAppBar(
          iosTransitionBetweenRoutes: false,
          text:
              media.createdTime?.format(context, DateFormatType.relative) ?? '',
          actions: [
            ActionButton(
              onPressed: () {
                AppRouter.mediaMetaDataDetails(media: media).push(context);
              },
              icon: Icon(
                CupertinoIcons.info,
                color: context.colorScheme.textSecondary,
                size: 22,
              ),
            ),
            if(media.isGoogleDriveStored)
            ActionButton(
              onPressed: () {
                notifier.downloadMediaFromGoogleDrive(media: media);
              },
              icon: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  CupertinoIcons.cloud_download,
                  color: context.colorScheme.textSecondary,
                  size: 22,
                ),
              ),
            ),
            ActionButton(
              onPressed: () async {
                if (media.isCommonStored && media.driveMediaRefId != null) {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                        double.infinity,
                        kToolbarHeight + MediaQuery.of(context).padding.top,
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
                          _showDeleteFromDriveDialog(
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
                              Assets.images.icons.googleDrive,
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 16),
                            Text(context.l10n.common_delete_from_google_drive,
                                style: AppTextStyles.body2.copyWith(
                                  color: context.colorScheme.textPrimary,
                                )),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () async {
                          _showDeleteFromDeviceDialog(
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
                              context.l10n.common_delete_from_device,
                              style: AppTextStyles.body2.copyWith(
                                color: context.colorScheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (media.isGoogleDriveStored &&
                    media.driveMediaRefId != null) {
                  _showDeleteFromDriveDialog(
                      context: context,
                      onDelete: () {
                        notifier
                            .deleteMediaFromGoogleDrive(media.driveMediaRefId);
                        context.pop();
                      });
                } else if (media.isLocalStored) {
                  _showDeleteFromDeviceDialog(
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
            if (!Platform.isIOS && !Platform.isMacOS) const SizedBox(width: 8),
          ],
        ),
      );
    });
  }

  Future<void> _showDeleteFromDriveDialog(
      {required BuildContext context,
      required void Function() onDelete}) async {
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

  Future<void> _showDeleteFromDeviceDialog(
      {required BuildContext context,
      required void Function() onDelete}) async {
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
