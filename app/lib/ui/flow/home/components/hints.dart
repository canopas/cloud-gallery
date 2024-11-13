import '../../../../domain/extensions/context_extensions.dart';
import '../home_screen_view_model.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'hint_view.dart';

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
