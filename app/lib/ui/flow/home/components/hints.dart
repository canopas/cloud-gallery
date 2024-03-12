import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/ui/flow/home/home_screen_view_model.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class HomeScreenHints extends ConsumerWidget {
  const HomeScreenHints({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleAccount =
        ref.watch(homeViewStateNotifier.select((value) => value.googleAccount));
    final canTakeAutoBackUpInGoogleDrive =
        ref.watch(AppPreferences.canTakeAutoBackUpInGoogleDrive);
    final googleDriveSignInHintShown =
        ref.watch(AppPreferences.googleDriveSignInHintShown);
    final googleDriveAutoBackUpHintShown =
        ref.watch(AppPreferences.googleDriveAutoBackUpHintShown);
    if (!googleDriveSignInHintShown && googleAccount == null) {
      return HintView(
        title: context.l10n.greetings_hey_there_text,
        hint: context.l10n.hint_google_sign_in_message,
        onClose: () {
          ref.read(AppPreferences.googleDriveSignInHintShown.notifier).state =
              true;
        },
        actionTitle: context.l10n.add_account_title,
        onActionTap: () {
          ref.read(homeViewStateNotifier.notifier).signInWithGoogle();
          ref.read(AppPreferences.googleDriveSignInHintShown.notifier).state =
              true;
        },
      );
    } else if (googleAccount != null &&
        !googleDriveAutoBackUpHintShown &&
        !canTakeAutoBackUpInGoogleDrive) {
      return HintView(
        title:
            "${context.l10n.greetings_hey_text} ${googleAccount.displayName?.split(' ').first ?? "There"}!",
        hint: context.l10n.hint_google_auto_backup_message,
        onClose: () {
          ref
              .read(AppPreferences.googleDriveAutoBackUpHintShown.notifier)
              .state = true;
        },
        actionTitle: context.l10n.hint_action_auto_backup,
        onActionTap: () {
          ref
              .read(AppPreferences.canTakeAutoBackUpInGoogleDrive.notifier)
              .state = true;
          ref
              .read(AppPreferences.googleDriveAutoBackUpHintShown.notifier)
              .state = true;
        },
      );
    } else {
      return const SizedBox();
    }
  }
}

class HintView extends StatelessWidget {
  final String title;
  final String hint;
  final String actionTitle;
  final VoidCallback? onActionTap;
  final VoidCallback onClose;

  const HintView(
      {super.key,
      required this.hint,
      required this.onClose,
      this.actionTitle = '',
      this.onActionTap,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.containerNormalOnSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16),
                  child: Text(
                    title,
                    style: AppTextStyles.subtitle2.copyWith(
                      color: context.colorScheme.textPrimary,
                    ),
                  ),
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: context.colorScheme.containerNormal,
                  minimumSize: const Size(28, 28),
                ),
                onPressed: onClose,
                icon: Icon(
                  Icons.close_rounded,
                  color: context.colorScheme.textSecondary,
                  size: 18,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: Text(
              hint,
              style: AppTextStyles.body2.copyWith(
                color: context.colorScheme.textSecondary,
              ),
            ),
          ),
          if (onActionTap != null)
            FilledButton(
              onPressed: onActionTap,
              style: FilledButton.styleFrom(
                backgroundColor: context.colorScheme.containerNormal,
                foregroundColor: context.colorScheme.textPrimary,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size(double.maxFinite, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                actionTitle,
                style: AppTextStyles.button,
              ),
            )
        ],
      ),
    );
  }
}
