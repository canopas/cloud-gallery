import '../../../components/app_page.dart';
import '../../../domain/extensions/context_extensions.dart';
import '../../../gen/assets.gen.dart';
import 'accounts_screen_view_model.dart';
import 'components/settings_action_list.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import 'package:style/theme/colors.dart';
import 'package:style/buttons/buttons_list.dart';
import 'package:style/buttons/switch.dart';
import '../../../components/snack_bar.dart';
import 'components/account_tab.dart';
import 'package:data/domain/config.dart';

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
    return AppPage(
      title: context.l10n.accounts_title,
      bodyBuilder: (context) {
        return ListView(
          padding: context.systemPadding +
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            _googleAccount(context: context),
            if (FeatureFlags.dropboxEnabled) _dropboxAccount(context: context),
            const SettingsActionList(),
            const SizedBox(height: 16),
            _buildVersion(context: context),
          ],
        );
      },
    );
  }

  Widget _googleAccount({required BuildContext context}) {
    return Consumer(
      builder: (context, ref, child) {
        final googleAccount = ref.watch(
          accountsStateNotifierProvider.select((value) => value.googleAccount),
        );

        if (googleAccount != null) {
          return AccountsTab(
            name: googleAccount.displayName ?? googleAccount.email,
            serviceDescription:
                "${context.l10n.common_google_drive} - ${googleAccount.email}",
            profileImage: googleAccount.photoUrl,
            actionList: ActionList(
              buttons: [
                ActionListButton(
                  title: context.l10n.auto_back_up_title,
                  trailing: Consumer(
                    builder: (context, ref, child) {
                      final googleDriveAutoBackUp =
                          ref.watch(AppPreferences.googleDriveAutoBackUp);
                      return AppSwitch(
                        value: googleDriveAutoBackUp,
                        onChanged: notifier.toggleAutoBackupInGoogleDrive,
                      );
                    },
                  ),
                ),
                ActionListButton(
                  title: context.l10n.sign_out_title,
                  onPressed: notifier.signOutWithGoogle,
                ),
              ],
            ),
            backgroundColor: AppColors.googleDriveColor.withAlpha(50),
          );
        }
        return ActionList(
          buttons: [
            ActionListButton(
              leading: SvgPicture.asset(
                Assets.images.icGoogleDrive,
                height: 24,
                width: 24,
              ),
              title: context.l10n.sign_in_with_google_drive_title,
              onPressed: () {
                notifier.signInWithGoogle();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _dropboxAccount({required BuildContext context}) {
    return Consumer(
      builder: (context, ref, child) {
        final dropboxAccount =
            ref.watch(AppPreferences.dropboxCurrentUserAccount);
        if (dropboxAccount != null) {
          return AccountsTab(
            name: dropboxAccount.name.display_name,
            serviceDescription:
                "${context.l10n.common_dropbox} - ${dropboxAccount.email}",
            profileImage: dropboxAccount.profile_photo_url,
            actionList: ActionList(
              buttons: [
                ActionListButton(
                  title: context.l10n.auto_back_up_title,
                  trailing: Consumer(
                    builder: (context, ref, child) {
                      final dropboxAutoBackUp =
                          ref.watch(AppPreferences.dropboxAutoBackUp);
                      return AppSwitch(
                        value: dropboxAutoBackUp,
                        onChanged: notifier.toggleAutoBackupInDropbox,
                      );
                    },
                  ),
                ),
                ActionListButton(
                  title: context.l10n.sign_out_title,
                  onPressed: notifier.signOutWithDropbox,
                ),
              ],
            ),
            backgroundColor: AppColors.dropBoxColor.withAlpha(50),
          );
        }
        return ActionList(
          buttons: [
            ActionListButton(
              leading: SvgPicture.asset(
                Assets.images.icDropbox,
                height: 24,
                width: 24,
              ),
              title: context.l10n.sign_in_with_dropbox_title,
              onPressed: () {
                notifier.signInWithDropbox();
              },
            ),
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
              "${context.l10n.version_title} $version",
              style: AppTextStyles.body2.copyWith(
                color: context.colorScheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
}
