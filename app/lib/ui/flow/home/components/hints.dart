import '../../../../domain/extensions/context_extensions.dart';
import '../../../navigation/app_route.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'hint_view.dart';

class HomeScreenHints extends ConsumerWidget {
  const HomeScreenHints({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleAccount = ref.watch(googleUserAccountProvider);
    final dropboxAccount = ref.watch(AppPreferences.dropboxCurrentUserAccount);
    final signInHintShown = ref.watch(AppPreferences.signInHintShown);

    if (!signInHintShown && googleAccount == null && dropboxAccount == null) {
      return HintView(
        title: context.l10n.greetings_hey_there_text,
        hint: context.l10n.hint_sign_in_message,
        onClose: () {
          ref.read(AppPreferences.signInHintShown.notifier).state = true;
        },
        actionTitle: context.l10n.add_account_title,
        onActionTap: () {
          AccountRoute().push(context);
          ref.read(AppPreferences.signInHintShown.notifier).state = true;
        },
      );
    } else {
      return const SizedBox();
    }
  }
}
