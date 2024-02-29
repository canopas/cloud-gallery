import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/buttons/buttons_list.dart';
import 'package:style/buttons/segmented_button.dart';

class SettingsActionList extends ConsumerWidget {
  const SettingsActionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(AppPreferences.isDarkMode);
    return ActionList(buttons: [
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
          ///TODO: Add term and condition screen
        },
      ),
      ActionListButton(
          title: context.l10n.common_privacy_policy,
          onPressed: () {
            ///TODO: Add privacy policy screen
          }),
    ]);
  }
}
