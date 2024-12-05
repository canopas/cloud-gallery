import '../../../../components/web_view_screen.dart';
import '../../../../domain/extensions/context_extensions.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/buttons/buttons_list.dart';
import 'package:style/buttons/segmented_button.dart';
import 'package:style/buttons/switch.dart';
import 'package:style/extensions/context_extensions.dart';

class SettingsActionList extends ConsumerWidget {
  const SettingsActionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(AppPreferences.isDarkMode);
    final notifications = ref.watch(AppPreferences.notifications);
    return ActionList(
      buttons: [
        ActionListButton(
          title: context.l10n.notification_title,
          trailing: AppSwitch(
            value: notifications,
            onChanged: (value) {
              ref.read(AppPreferences.notifications.notifier).state = value;
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
