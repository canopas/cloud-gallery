import 'package:cloud_gallery/components/app_dialog.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/ui/flow/home/home_screen_view_model.dart';
import 'package:data/models/media/media.dart';
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
                  icon: SvgPicture.asset(
                    Assets.images.icons.googlePhotos,
                    height: 24,
                    width: 24,
                  ),
                  title: context.l10n.back_up_on_google_drive_text,
                  onPressed: () {
                    notifier.backUpMediaOnGoogleDrive();
                    context.pop();
                  },
                ),
              if (showDeleteFromDeviceButton)
                AppSheetAction(
                  icon: const Icon(CupertinoIcons.delete),
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
                  icon: const Icon(CupertinoIcons.delete),
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
