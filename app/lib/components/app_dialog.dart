import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class AppAlertAction {
  final String title;
  final bool isDestructiveAction;
  final VoidCallback onPressed;

  const AppAlertAction({
    required this.title,
    this.isDestructiveAction = false,
    required this.onPressed,
  });
}

Future<T?> showAppAlertDialog<T>({
  required BuildContext context,
  required String title,
  required String message,
  required List<AppAlertAction> actions,
}) {
  return showAdaptiveDialog<T>(
    context: context,
    builder: (context) {
      if (Platform.isIOS || Platform.isMacOS) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: AppTextStyles.body
                .copyWith(color: context.colorScheme.textPrimary),
          ),
          content: Text(
            message,
            style: AppTextStyles.caption
                .copyWith(color: context.colorScheme.textSecondary),
          ),
          actions: [
            for (final action in actions)
              CupertinoDialogAction(
                onPressed: action.onPressed,
                child: Text(
                  action.title,
                  style: AppTextStyles.button.copyWith(
                    color: action.isDestructiveAction
                        ? context.colorScheme.alert
                        : context.colorScheme.textPrimary,
                  ),
                ),
              ),
          ],
        );
      }

      return AlertDialog(
        backgroundColor: context.colorScheme.containerNormalOnSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: Text(
          title,
          style: AppTextStyles.body
              .copyWith(color: context.colorScheme.textPrimary),
        ),
        content: Text(
          message,
          style: AppTextStyles.caption
              .copyWith(color: context.colorScheme.textSecondary),
        ),
        actions: [
          for (final action in actions)
            TextButton(
              onPressed: action.onPressed,
              child: Text(
                action.title,
                style: AppTextStyles.button.copyWith(
                  color: action.isDestructiveAction
                      ? context.colorScheme.alert
                      : context.colorScheme.textPrimary,
                ),
              ),
            ),
        ],
      );
    },
  );
}
