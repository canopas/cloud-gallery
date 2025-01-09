import 'dart:io';
import 'package:data/models/media/media_extension.dart';
import '../../../../components/app_dialog.dart';
import '../../../../components/selection_menu.dart';
import '../../../../domain/extensions/context_extensions.dart';
import '../../../../gen/assets.gen.dart';
import '../home_screen_view_model.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:style/extensions/context_extensions.dart';

class HomeSelectionMenu extends ConsumerWidget {
  const HomeSelectionMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      homeViewStateNotifier.select(
        (state) => (
          selectedMedias: state.selectedMedias,
          googleAccount: state.googleAccount,
          dropboxAccount: state.dropboxAccount
        ),
      ),
    );

    return SelectionMenu(
      useSystemPadding: false,
      items: [
        _clearSelectionAction(context, ref),
        if (state.selectedMedias.values.any(
          (element) =>
              !element.sources.contains(AppMediaSource.googleDrive) &&
              element.sources.contains(AppMediaSource.local) &&
              state.googleAccount != null,
        ))
          _uploadToGoogleDriveAction(context, ref),
        if (state.selectedMedias.values
                .any((element) => element.isGoogleDriveStored) &&
            state.googleAccount != null)
          _downloadFromGoogleDriveAction(context, ref),
        if (state.selectedMedias.values.any(
              (element) => element.sources.contains(AppMediaSource.googleDrive),
            ) &&
            state.googleAccount != null)
          _deleteMediaFromGoogleDriveAction(context, ref),
        if (state.selectedMedias.values.any(
          (element) =>
              !element.sources.contains(AppMediaSource.dropbox) &&
              element.sources.contains(AppMediaSource.local) &&
              state.dropboxAccount != null,
        ))
          _uploadToDropboxAction(context, ref),
        if (state.selectedMedias.values
                .any((element) => element.isDropboxStored) &&
            state.dropboxAccount != null)
          _downloadFromDropboxAction(context, ref),
        if (state.selectedMedias.values.any(
              (element) => element.sources.contains(AppMediaSource.dropbox),
            ) &&
            state.dropboxAccount != null)
          _deleteMediaFromDropboxAction(context, ref),
        if (state.selectedMedias.values.any(
          (element) => element.sources.contains(AppMediaSource.local),
        ))
          _deleteFromDevice(context, ref),
        if (state.selectedMedias.values.any((element) => element.isLocalStored))
          _shareAction(context, state.selectedMedias, ref),
      ],
      show: state.selectedMedias.isNotEmpty,
    );
  }

  Widget _clearSelectionAction(BuildContext context, WidgetRef ref) {
    return SelectionMenuAction(
      title: context.l10n.common_cancel,
      icon: Icon(
        Icons.close,
        color: context.colorScheme.textPrimary,
        size: 22,
      ),
      onTap: ref.read(homeViewStateNotifier.notifier).clearSelection,
    );
  }

  Widget _uploadToGoogleDriveAction(BuildContext context, WidgetRef ref) {
    return SelectionMenuAction(
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
            Assets.images.icGoogleDrive,
            width: 14,
            height: 14,
          ),
        ],
      ),
      title: context.l10n.upload_to_google_drive_title,
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
                context.pop();
                ref.read(homeViewStateNotifier.notifier).uploadToGoogleDrive();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _downloadFromGoogleDriveAction(BuildContext context, WidgetRef ref) {
    return SelectionMenuAction(
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
            Assets.images.icGoogleDrive,
            width: 14,
            height: 14,
          ),
        ],
      ),
      title: context.l10n.download_from_google_drive_title,
      onTap: () async {
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
                context.pop();
                ref
                    .read(homeViewStateNotifier.notifier)
                    .downloadFromGoogleDrive();
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
    return SelectionMenuAction(
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
            Assets.images.icGoogleDrive,
            width: 14,
            height: 14,
          ),
        ],
      ),
      title: context.l10n.delete_from_google_drive_title,
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
                context.pop();
                ref
                    .read(homeViewStateNotifier.notifier)
                    .deleteGoogleDriveMedias();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _uploadToDropboxAction(BuildContext context, WidgetRef ref) {
    return SelectionMenuAction(
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
            Assets.images.icDropbox,
            width: 14,
            height: 14,
          ),
        ],
      ),
      title: context.l10n.upload_to_dropbox_title,
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
                context.pop();
                ref.read(homeViewStateNotifier.notifier).uploadToDropbox();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _downloadFromDropboxAction(BuildContext context, WidgetRef ref) {
    return SelectionMenuAction(
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
            Assets.images.icDropbox,
            width: 14,
            height: 14,
          ),
        ],
      ),
      title: context.l10n.download_from_dropbox_title,
      onTap: () async {
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
                context.pop();
                ref.read(homeViewStateNotifier.notifier).downloadFromDropbox();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _deleteMediaFromDropboxAction(BuildContext context, WidgetRef ref) {
    return SelectionMenuAction(
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
            Assets.images.icDropbox,
            width: 14,
            height: 14,
          ),
        ],
      ),
      title: context.l10n.delete_from_dropbox_title,
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
                context.pop();
                ref.read(homeViewStateNotifier.notifier).deleteDropboxMedias();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _deleteFromDevice(BuildContext context, WidgetRef ref) {
    return SelectionMenuAction(
      icon: const Icon(
        CupertinoIcons.delete,
        size: 24,
      ),
      title: context.l10n.delete_from_device_title,
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
                context.pop();
                ref.read(homeViewStateNotifier.notifier).deleteLocalMedias();
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
    WidgetRef ref,
  ) {
    return SelectionMenuAction(
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.share : Icons.share_rounded,
        color: context.colorScheme.textSecondary,
        size: 24,
      ),
      title: context.l10n.common_share,
      onTap: () {
        Share.shareXFiles(
          selectedMedias.values
              .where((element) => element.isLocalStored)
              .map((e) => XFile(e.path))
              .toList(),
        );
        ref.read(homeViewStateNotifier.notifier).clearSelection();
      },
    );
  }
}
