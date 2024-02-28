import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../home_screen_view_model.dart';

class ScreenSourceSegmentControl extends ConsumerWidget {
  const ScreenSourceSegmentControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sources =
        ref.watch(homeViewStateNotifier.select((state) => state.sourcePage));
    final notifier = ref.read(homeViewStateNotifier.notifier);
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton(
          segments: [
            ButtonSegment(
              value: MediaSource.local,
              label:
                  Text(context.l10n.common_local, style: AppTextStyles.body2),
            ),
            ButtonSegment(
              value: MediaSource.googleDrive,
              label: Text(
                context.l10n.common_google_drive,
                style: AppTextStyles.body2,
              ),
            )
          ],
          selected: {sources.sourcePage},
          multiSelectionEnabled: false,
          onSelectionChanged: (source) {
            HapticFeedback.vibrate();
            notifier.updateMediaSource(
                source: source.first, isChangedByScroll: false);
          },
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide.none,
            ),
            side: BorderSide.none,
            foregroundColor: context.colorScheme.textPrimary,
            selectedForegroundColor: context.colorScheme.onPrimary,
            selectedBackgroundColor: context.colorScheme.primary,
            backgroundColor: context.colorScheme.containerNormalOnSurface,
            visualDensity: VisualDensity.compact,
          ),
        ),
      ),
    );
  }
}
