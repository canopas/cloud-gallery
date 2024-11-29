import 'dart:io';
import 'package:data/models/media/media_extension.dart';
import '../../../../components/app_dialog.dart';
import '../../../../domain/extensions/context_extensions.dart';
import '../home_screen_view_model.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:style/extensions/context_extensions.dart';
import '../../../../components/action_sheet.dart';
import '../../../../components/app_sheet.dart';
import '../../../../domain/assets/assets_paths.dart';

class MultiSelectionDoneButton extends ConsumerWidget {
  const MultiSelectionDoneButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMedias = ref
        .watch(homeViewStateNotifier.select((state) => state.selectedMedias));

    return FloatingActionButton(
      elevation: 3,
      backgroundColor: context.colorScheme.primary,
      onPressed: () {
        showAppSheet(
          context: context,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedMedias.values.any(
                (element) =>
                    !element.sources.contains(AppMediaSource.googleDrive),
              ))
                _uploadFromGoogleDriveAction(context, ref),
              if (selectedMedias.values
                  .any((element) => element.isGoogleDriveStored))
                _downloadFromGoogleDriveAction(context, ref),
              if (selectedMedias.values.any(
                (element) =>
                    element.sources.contains(AppMediaSource.googleDrive),
              ))
                _deleteMediaFromGoogleDriveAction(context, ref),
              if (selectedMedias.values.any(
                (element) => !element.sources.contains(AppMediaSource.dropbox),
              ))
                _uploadFromDropboxAction(context, ref),
              if (selectedMedias.values
                  .any((element) => element.isDropboxStored))
                _downloadFromDropboxAction(context, ref),
              if (selectedMedias.values.any(
                (element) => element.sources.contains(AppMediaSource.dropbox),
              ))
                _deleteMediaFromDropboxAction(context, ref),
              if (selectedMedias.values.any(
                (element) => element.sources.contains(AppMediaSource.local),
              ))
                _deleteFromDevice(context, ref),
              if (selectedMedias.values.any((element) => element.isLocalStored))
                _shareAction(context, selectedMedias),
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

  Widget _uploadFromGoogleDriveAction(BuildContext context, WidgetRef ref) {
    return AppSheetAction(
      icon: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0, right: 8),
            child: Icon(
              CupertinoIcons.cloud_upload,
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
      title: "Upload to Google Drive",
      onPressed: () {
        ref.read(homeViewStateNotifier.notifier).uploadToGoogleDrive();
        context.pop();
      },
    );
  }

  Widget _downloadFromGoogleDriveAction(BuildContext context, WidgetRef ref) {
    return AppSheetAction(
      icon: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0, right: 8),
            child: Icon(
              CupertinoIcons.cloud_download,
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
      title: context.l10n.download_from_google_drive_text,
      onPressed: () async {
        context.pop();
        showAppAlertDialog(
          context: context,
          title: context.l10n.download_from_google_drive_text,
          message: context.l10n.download_from_google_drive_alert_message,
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
                ref
                    .read(homeViewStateNotifier.notifier)
                    .downloadFromGoogleDrive();
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _deleteMediaFromGoogleDriveAction(
    BuildContext context,
    WidgetRef ref,
  ) {
    return AppSheetAction(
      icon: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2, right: 2),
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
      title: context.l10n.common_delete_from_google_drive,
      onPressed: () {
        context.pop();
        showAppAlertDialog(
          context: context,
          title: context.l10n.common_delete_from_google_drive,
          message:
              context.l10n.delete_media_from_google_drive_confirmation_message,
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
                ref
                    .read(homeViewStateNotifier.notifier)
                    .deleteGoogleDriveMedias();
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _uploadFromDropboxAction(BuildContext context, WidgetRef ref) {
    return AppSheetAction(
      icon: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0, right: 8),
            child: Icon(
              CupertinoIcons.cloud_upload,
              color: context.colorScheme.textSecondary,
              size: 22,
            ),
          ),
          SvgPicture.asset(
            Assets.images.icons.dropbox,
            width: 14,
            height: 14,
          ),
        ],
      ),
      title: "Upload to Dropbox",
      onPressed: () {
        ref.read(homeViewStateNotifier.notifier).uploadToDropbox();
        context.pop();
      },
    );
  }

  Widget _downloadFromDropboxAction(BuildContext context, WidgetRef ref) {
    return AppSheetAction(
      icon: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0, right: 8),
            child: Icon(
              CupertinoIcons.cloud_download,
              color: context.colorScheme.textSecondary,
              size: 22,
            ),
          ),
          SvgPicture.asset(
            Assets.images.icons.dropbox,
            width: 14,
            height: 14,
          ),
        ],
      ),
      title: "Download from Dropbox",
      onPressed: () async {
        context.pop();
        showAppAlertDialog(
          context: context,
          title: "Download from Dropbox",
          message:
              "Are you sure you want to download the selected media from Dropbox?",
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
                ref.read(homeViewStateNotifier.notifier).downloadFromDropbox();
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _deleteMediaFromDropboxAction(BuildContext context, WidgetRef ref) {
    return AppSheetAction(
      icon: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2, right: 2),
            child: Icon(
              CupertinoIcons.trash,
              color: context.colorScheme.textSecondary,
              size: 22,
            ),
          ),
          SvgPicture.asset(
            Assets.images.icons.dropbox,
            width: 14,
            height: 14,
          ),
        ],
      ),
      title: "Delete from Dropbox",
      onPressed: () {
        context.pop();
        showAppAlertDialog(
          context: context,
          title: "Delete from Dropbox",
          message:
              "Are you sure you want to delete the selected media from Dropbox?",
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
                ref.read(homeViewStateNotifier.notifier).deleteDropboxMedias();
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _deleteFromDevice(BuildContext context, WidgetRef ref) {
    return AppSheetAction(
      icon: const Icon(
        CupertinoIcons.delete,
        size: 24,
      ),
      title: context.l10n.common_delete_from_device,
      onPressed: () {
        showAppAlertDialog(
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
              onPressed: () {
                ref.read(homeViewStateNotifier.notifier).deleteLocalMedias();
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _shareAction(
    BuildContext context,
    Map<String, AppMedia> selectedMedias,
  ) {
    return AppSheetAction(
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.share : Icons.share_rounded,
        color: context.colorScheme.textSecondary,
        size: 24,
      ),
      title: context.l10n.common_share,
      onPressed: () {
        Share.shareXFiles(
          selectedMedias.values
              .where((element) => element.isLocalStored)
              .map((e) => XFile(e.path))
              .toList(),
        );
        context.pop();
      },
    );
  }
}
