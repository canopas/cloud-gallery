import 'package:flutter/material.dart';
import '../animations/on_tap_scale.dart';
import '../extensions/context_extensions.dart';
import '../text/app_text_style.dart';

class RadioSelectionButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String label;
  final void Function() onTab;

  const RadioSelectionButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onTab,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return OnTapScale(
      onTap: onTab,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: value == groupValue
                ? context.colorScheme.primary
                : context.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            IgnorePointer(
              child: Material(
                color: Colors.transparent,
                child: Radio(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  value: value,
                  groupValue: groupValue,
                  onChanged: (_) {},
                ),
              ),
            ),
            Text(
              label,
              style: AppTextStyles.subtitle1.copyWith(
                color: value == groupValue
                    ? context.colorScheme.textPrimary
                    : context.colorScheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
