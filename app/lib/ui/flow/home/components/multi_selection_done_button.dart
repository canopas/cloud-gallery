import 'package:cloud_gallery/components/app_dialog.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/ui/flow/home/home_screen_view_model.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style/extensions/context_extensions.dart';
import '../../../../components/action_sheet.dart';
import '../../../../components/app_sheet.dart';
import '../../../../domain/assets/assets_paths.dart';

class MultiSelectionDoneButton extends ConsumerWidget {
  const MultiSelectionDoneButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(homeViewStateNotifier.notifier);
    final selectedMedias = ref
        .watch(homeViewStateNotifier.select((state) => state.selectedMedias));

    final bool showDeleteFromDriveButton = selectedMedias
        .any((element) => element.sources.contains(AppMediaSource.googleDrive));
    final bool showDeleteFromDeviceButton = selectedMedias
        .any((element) => element.sources.contains(AppMediaSource.local));
    final bool showUploadToDriveButton = selectedMedias.any(
        (element) => !element.sources.contains(AppMediaSource.googleDrive));

    final bool showDownloadButton =
        selectedMedias.any((element) => element.isGoogleDriveStored);

    return FloatingActionButton(
      elevation: 3,
      backgroundColor: context.colorScheme.primary,
      onPressed: () {
        showAppSheet(
          context: context,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showUploadToDriveButton)
                AppSheetAction(
                  icon: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0, right: 8),
                        child: Icon(CupertinoIcons.cloud_upload,
                            color: context.colorScheme.textSecondary, size: 22),
                      ),
                      SvgPicture.asset(
                        Assets.images.icons.googleDrive,
                        width: 14,
                        height: 14,
                      ),
                    ],
                  ),
                  title: context.l10n.back_up_on_google_drive_text,
                  onPressed: () {
                    notifier.backUpMediaOnGoogleDrive();
                    context.pop();
                  },
                ),
              if (showDeleteFromDeviceButton)
                AppSheetAction(
                  icon: const Icon(
                    CupertinoIcons.delete,
                    size: 24,
                  ),
                  title: context.l10n.common_delete_from_device,
                  onPressed: () {
                    showAppAlertDialog(
                      context: context,
                      title: context.l10n.common_delete_from_device,
                      message: context
                          .l10n.delete_media_from_device_confirmation_message,
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
                            notifier.deleteMediasFromLocal();
                            context.pop();
                          },
                        ),
                      ],
                    );
                  },
                ),
              if (showDeleteFromDriveButton)
                AppSheetAction(
                  icon: const Icon(
                    CupertinoIcons.delete,
                    size: 24,
                  ),
                  title: context.l10n.common_delete_from_google_drive,
                  onPressed: () {
                    showAppAlertDialog(
                      context: context,
                      title: context.l10n.common_delete_from_google_drive,
                      message: context.l10n
                          .delete_media_from_google_drive_confirmation_message,
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
                            notifier.deleteMediasFromGoogleDrive();
                            context.pop();
                          },
                        ),
                      ],
                    );
                  },
                ),
              if (showDownloadButton)
                AppSheetAction(
                  icon: Icon(
                    CupertinoIcons.cloud_download,
                    size: 24,
                    color: context.colorScheme.textSecondary,
                  ),
                  title: context.l10n.download_from_google_drive_text,
                  onPressed: () {
                    showAppAlertDialog(
                      context: context,
                      title: context.l10n.download_from_google_drive_text,
                      message:
                          context.l10n.download_from_google_drive_alert_message,
                      actions: [
                        AppAlertAction(
                          title: context.l10n.common_cancel,
                          onPressed: () {
                            context.pop();
                          },
                        ),
                        AppAlertAction(
                          isDestructiveAction: true,
                          title: context.l10n.common_download,
                          onPressed: () {
                            context.pop();
                          },
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        );
      },
      child: Icon(
        CupertinoIcons.checkmark_alt,
        color: context.colorScheme.onPrimary,
      ),
    );
  }
}
