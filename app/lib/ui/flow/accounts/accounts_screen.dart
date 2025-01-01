import 'package:data/domain/config.dart';
import '../../../components/app_page.dart';
import '../../../domain/extensions/context_extensions.dart';
import '../../../gen/assets.gen.dart';
import 'accounts_screen_view_model.dart';
import 'components/settings_action_list.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class _AccountsScreenState extends ConsumerState<AccountsScreen>
    with WidgetsBindingObserver {
  late AccountsStateNotifier notifier;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    notifier = ref.read(accountsStateNotifierProvider.notifier);
    super.initState();
  }

  void _errorObserver() {
    ref.listen(accountsStateNotifierProvider.select((value) => value.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context: context, error: next);
      }
    });
  }

  void _clearCacheSucceedObserver() {
    ref.listen(
        accountsStateNotifierProvider.select(
          (value) =>
              (clearCacheLoading: value.clearCacheLoading, error: value.error),
        ), (previous, next) {
      if (previous!.clearCacheLoading &&
          !next.clearCacheLoading &&
          next.error == null) {
        showSnackBar(
          context: context,
          text: context.l10n.clear_cache_succeed_message,
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      notifier.updateNotificationsPermissionStatus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _errorObserver();
    _clearCacheSucceedObserver();
    return AppPage(
      title: context.l10n.accounts_title,
      bodyBuilder: (context) {
        return ListView(
          padding: context.systemPadding +
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            if (FeatureFlag.googleDriveSupport)
              _googleAccount(context: context),
            const SizedBox(height: 8),
            _dropboxAccount(context: context),
            const SizedBox(height: 8),
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
            actions: [
              ActionListItem(
                leading: Icon(
                  CupertinoIcons.arrow_2_circlepath,
                  color: context.colorScheme.textPrimary,
                  size: 22,
                ),
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
              ActionListItem(
                leading: SvgPicture.asset(
                  Assets.images.icLogout,
                  height: 22,
                  width: 22,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.textPrimary,
                    BlendMode.srcATop,
                  ),
                ),
                title: context.l10n.sign_out_title,
                onPressed: notifier.signOutWithGoogle,
              ),
            ],
            backgroundColor: AppColors.googleDriveColor,
          );
        }
        return ActionList(
          buttons: [
            ActionListItem(
              leading: SvgPicture.asset(
                Assets.images.icGoogleDrive,
                height: 22,
                width: 22,
              ),
              subtitle: context.l10n.sign_in_with_google_drive_message,
              trailing: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  CupertinoIcons.forward,
                  color: context.colorScheme.containerHigh,
                  size: 18,
                ),
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
            actions: [
              ActionListItem(
                leading: Icon(
                  CupertinoIcons.arrow_2_circlepath,
                  color: context.colorScheme.textPrimary,
                  size: 22,
                ),
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
              ActionListItem(
                leading: SvgPicture.asset(
                  Assets.images.icLogout,
                  height: 22,
                  width: 22,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.textPrimary,
                    BlendMode.srcATop,
                  ),
                ),
                title: context.l10n.sign_out_title,
                onPressed: notifier.signOutWithDropbox,
              ),
            ],
            backgroundColor: AppColors.dropBoxColor,
          );
        }
        return ActionList(
          buttons: [
            ActionListItem(
              leading: SvgPicture.asset(
                Assets.images.icDropbox,
                height: 22,
                width: 22,
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  CupertinoIcons.forward,
                  color: context.colorScheme.containerHigh,
                  size: 18,
                ),
              ),
              subtitle: context.l10n.sign_in_with_dropbox_message,
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
