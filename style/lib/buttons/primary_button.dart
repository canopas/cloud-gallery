import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';
import '../text/app_text_style.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Widget? child;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    this.text = '',
    this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
      ),
      child: child ??
          Text(
            text,
            style: AppTextStyles.button
                .copyWith(color: context.colorScheme.onPrimary),
          ),
    );
  }
}
