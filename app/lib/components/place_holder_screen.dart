import 'package:flutter/cupertino.dart';
import 'package:style/buttons/primary_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class PlaceHolderScreenAction {
  final String title;
  final VoidCallback onPressed;

  const PlaceHolderScreenAction({required this.title, required this.onPressed});
}

class PlaceHolderScreen extends StatelessWidget {
  final Widget? icon;
  final String title;
  final String message;
  final Color? foregroundColor;
  final PlaceHolderScreenAction? action;

  const PlaceHolderScreen({
    super.key,
    this.icon,
    required this.title,
    this.foregroundColor,
    this.message = '',
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            icon ??
                Icon(
                  CupertinoIcons.exclamationmark_circle,
                  color: context.colorScheme.containerHighOnSurface,
                  size: 100,
                ),
            const SizedBox(height: 40),
            Text(
              title,
              style: AppTextStyles.subtitle1.copyWith(
                color: foregroundColor ?? context.colorScheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: AppTextStyles.subtitle2.copyWith(
                color: foregroundColor ?? context.colorScheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: 20),
              PrimaryButton(
                onPressed: action!.onPressed,
                child: Text(
                  action!.title,
                  style: AppTextStyles.button,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
