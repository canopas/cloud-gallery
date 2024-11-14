import '../../../components/app_page.dart';
import '../../../domain/extensions/context_extensions.dart';
import '../../../domain/extensions/widget_extensions.dart';
import 'accounts_screen_view_model.dart';
import 'components/settings_action_list.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import 'package:style/theme/colors.dart';
import 'package:style/buttons/buttons_list.dart';
import 'package:style/buttons/switch.dart';
import '../../../components/snack_bar.dart';
import 'components/account_tab.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> {
  late AccountsStateNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = ref.read(accountsStateNotifierProvider.notifier);
    runPostFrame(() => notifier.init());
  }

  void _errorObserver() {
    ref.listen(accountsStateNotifierProvider.select((value) => value.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context: context, error: next);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _errorObserver();
    final googleAccount = ref.watch(
      accountsStateNotifierProvider.select((value) => value.googleAccount),
    );
    return AppPage(
      title: context.l10n.common_accounts,
      bodyBuilder: (context) {
        return ListView(
          padding: context.systemPadding + const EdgeInsets.all(16),
          children: [
            if (googleAccount != null)
              AccountsTab(
                name: googleAccount.displayName ?? googleAccount.email,
                serviceDescription: context.l10n.common_google_drive,
                profileImage: googleAccount.photoUrl,
                actionList: ActionList(
                  buttons: [
                    ActionListButton(
                      title: context.l10n.common_auto_back_up,
                      trailing: Consumer(
                        builder: (context, ref, child) {
                          final googleDriveAutoBackUp = ref.watch(
                            AppPreferences.canTakeAutoBackUpInGoogleDrive,
                          );
                          return AppSwitch(
                            value: googleDriveAutoBackUp,
                            onChanged: (bool value) {
                              ref
                                  .read(
                                    AppPreferences
                                        .canTakeAutoBackUpInGoogleDrive
                                        .notifier,
                                  )
                                  .state = value;
                            },
                          );
                        },
                      ),
                    ),
                    ActionListButton(
                      title: context.l10n.common_sign_out,
                      onPressed: notifier.signOutWithGoogle,
                    ),
                  ],
                ),
                backgroundColor: AppColors.googleDriveColor.withAlpha(50),
              ),
            if (googleAccount == null)
              OnTapScale(
                onTap: () {
                  notifier.signInWithGoogle();
                },
                child: AccountsTab(
                  name: context.l10n.add_account_title,
                  backgroundColor: context.colorScheme.containerNormal,
                ),
              ),
            const SizedBox(height: 16),
            const SettingsActionList(),
            const SizedBox(height: 16),
            _buildVersion(context: context),
          ],
        );
      },
    );
  }

  Widget _buildVersion({required BuildContext context}) => Consumer(
        builder: (context, ref, child) {
          final version = ref.watch(
            accountsStateNotifierProvider.select((value) => value.version),
          );
          return Visibility(
            visible: version != null,
            child: Text(
              "${context.l10n.version_text} $version",
              style: AppTextStyles.body2.copyWith(
                color: context.colorScheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
}
