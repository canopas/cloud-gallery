import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class AppButtonSegment<T> {
  const AppButtonSegment({
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
}

class AppSegmentedButton<T> extends StatelessWidget {
  final Size? size;
  final List<AppButtonSegment> segments;
  final TextStyle segmentTextStyle;
  final Function(T value) onSelectionChanged;
  final T selected;

  const AppSegmentedButton({
    super.key,
    required this.segments,
    this.segmentTextStyle = AppTextStyles.caption,
    required this.selected,
    required this.onSelectionChanged,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments
          .map(
            (e) => ButtonSegment<T>(
              value: e.value,
              label: Text(
                e.label,
                style: segmentTextStyle,
              ),
            ),
          )
          .toList(),
      selected: {selected},
      multiSelectionEnabled: false,
      onSelectionChanged: (p0) {
        onSelectionChanged(p0.first);
      },
      showSelectedIcon: false,
      style: SegmentedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide.none,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        fixedSize: size,
        minimumSize: const Size(0, 0),
        side: BorderSide.none,
        foregroundColor: context.colorScheme.textPrimary,
        selectedForegroundColor: context.colorScheme.onPrimary,
        selectedBackgroundColor: context.colorScheme.primary,
        backgroundColor: context.colorScheme.containerNormal,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
