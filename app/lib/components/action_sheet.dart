import 'package:style/extensions/context_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/text/app_text_style.dart';

class AppSheetAction extends StatelessWidget {
  final String title;
  final Widget? icon;
  final bool enable;
  final void Function() onPressed;

  const AppSheetAction({
    super.key,
    required this.title,
    this.icon,
    required this.onPressed,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    return OnTapScale(
      onTap: onPressed,
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Row(
          children: [
            icon ?? const SizedBox(),
            if (icon != null) const SizedBox(width: 16),
            Text(
              title,
              style: AppTextStyles.subtitle2.copyWith(
                color: enable
                    ? context.colorScheme.textPrimary
                    : context.colorScheme.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
