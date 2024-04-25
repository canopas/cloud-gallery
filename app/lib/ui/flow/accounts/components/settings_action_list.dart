import 'package:cloud_gallery/components/web_view_screen.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/buttons/buttons_list.dart';
import 'package:style/buttons/segmented_button.dart';
import 'package:style/buttons/switch.dart';

class SettingsActionList extends ConsumerWidget {
  const SettingsActionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(AppPreferences.isDarkMode);
    final notifications = ref.watch(AppPreferences.notifications);
    return ActionList(buttons: [
      ActionListButton(
        title: context.l10n.notification_text,
        trailing: AppSwitch(
          value: notifications,
          onChanged: (value) {
            ref.read(AppPreferences.notifications.notifier).state = value;
          },
        ),
      ),
      ActionListButton(
        title: context.l10n.theme_text,
        trailing: AppSegmentedButton(
          segments: [
            AppButtonSegment(
              value: true,
              label: context.l10n.dark_theme_text,
            ),
            AppButtonSegment(
              value: false,
              label: context.l10n.light_theme_text,
            ),
            AppButtonSegment(
              value: null,
              label: context.l10n.system_theme_text,
            ),
          ],
          selected: isDarkMode,
          onSelectionChanged: (source) {
            ref.read(AppPreferences.isDarkMode.notifier).state = source;
          },
        ),
      ),
      ActionListButton(
        title: context.l10n.common_term_and_condition,
        onPressed: () {
          showWebView(context, "https://canopas.github.io/cloud-gallery/terms-and-conditions");
        },
      ),
      ActionListButton(
          title: context.l10n.common_privacy_policy,
          onPressed: () {
            showWebView(context, "https://canopas.github.io/cloud-gallery/privacy-policy");
          }),
    ]);
  }
}
