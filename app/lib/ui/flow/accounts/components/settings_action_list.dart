import 'package:permission_handler/permission_handler.dart';
import '../../../../components/web_view_screen.dart';
import '../../../../domain/extensions/context_extensions.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/buttons/buttons_list.dart';
import 'package:style/buttons/segmented_button.dart';
import 'package:style/buttons/switch.dart';
import 'package:style/extensions/context_extensions.dart';
import '../accounts_screen_view_model.dart';

class SettingsActionList extends ConsumerStatefulWidget {
  const SettingsActionList({super.key});

  @override
  ConsumerState<SettingsActionList> createState() => _SettingsActionListState();
}

class _SettingsActionListState extends ConsumerState<SettingsActionList>
    with WidgetsBindingObserver {
  late AccountsStateNotifier notifier;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    notifier = ref.read(accountsStateNotifierProvider.notifier);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      notifier.updateNotificationsPermissionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(AppPreferences.isDarkMode);
    final notifications = ref.watch(AppPreferences.notifications);
    final notificationsPermissionStatusAllowed = ref.watch(
      accountsStateNotifierProvider.select(
        (value) => value.notificationsPermissionStatus,
      ),
    );
    return ActionList(
      buttons: [
        ActionListButton(
          title: context.l10n.notification_title,
          trailing: AppSwitch(
            value: notificationsPermissionStatusAllowed ? notifications : false,
            onChanged: (value) async {
              if (notificationsPermissionStatusAllowed) {
                ref.read(AppPreferences.notifications.notifier).state = value;
              } else {
                final status = await Permission.notification.request();
                notifier.updateNotificationsPermissionStatus(status: status);
              }
            },
          ),
        ),
        ActionListButton(
          title: context.l10n.theme_title,
          trailing: AppSegmentedButton(
            segments: [
              AppButtonSegment(
                value: true,
                label: context.l10n.dark_theme_title,
              ),
              AppButtonSegment(
                value: false,
                label: context.l10n.light_theme_title,
              ),
              AppButtonSegment(
                value: null,
                label: context.l10n.system_theme_title,
              ),
            ],
            selected: isDarkMode,
            onSelectionChanged: (source) {
              ref.read(AppPreferences.isDarkMode.notifier).state = source;
            },
          ),
        ),
        ActionListButton(
          title: context.l10n.rate_us_title,
          onPressed: notifier.rateUs,
        ),
        ActionListButton(
          title: context.l10n.clear_cache_title,
          onPressed: notifier.clearCache,
        ),
        ActionListButton(
          title: context.l10n.term_and_condition_title,
          onPressed: () {
            final colors = _getWebPageColors(context, ref);
            showWebView(
              context,
              "https://canopas.github.io/cloud-gallery/terms-and-conditions?bgColor=${colors.background}&textColor=${colors.text}",
            );
          },
        ),
        ActionListButton(
          title: context.l10n.privacy_policy_title,
          onPressed: () {
            final colors = _getWebPageColors(context, ref);
            showWebView(
              context,
              "https://canopas.github.io/cloud-gallery/privacy-policy?bgColor=${colors.background}&textColor=${colors.text}",
            );
          },
        ),
      ],
    );
  }

  ({String background, String text}) _getWebPageColors(
    BuildContext context,
    WidgetRef ref,
  ) {
    final isDark =
        (ref.watch(AppPreferences.isDarkMode) ?? context.systemThemeIsDark);
    return (
      background: isDark ? "%23000000" : "%23FFFFFF",
      text: isDark ? "%23FFFFFF" : "%23000000"
    );
  }
}
