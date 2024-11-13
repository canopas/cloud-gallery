import 'dart:io';
import '../domain/extensions/app_error_extensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

void showErrorSnackBar({required BuildContext context, required Object error}) {
  final message = error.l10nMessage(context);
  showSnackBar(
    context: context,
    text: message,
    icon: Icon(
      Icons.warning_amber_rounded,
      color: context.colorScheme.alert,
    ),
  );
}

final _toast = FToast();

void showSnackBar({
  required BuildContext context,
  required String text,
  Widget? icon,
  Duration duration = const Duration(seconds: 4),
}) {
  if (Platform.isIOS || Platform.isMacOS) {
    _toast.init(context);
    _toast.removeCustomToast();
    _toast.showToast(
      fadeDuration: const Duration(milliseconds: 100),
      toastDuration: duration,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.containerNormalOnSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (icon != null) icon,
            if (icon != null) const SizedBox(width: 10),
            Flexible(
              child: Text(
                text,
                style: AppTextStyles.body2.copyWith(
                  color: context.colorScheme.textPrimary,
                ),
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
      gravity: ToastGravity.TOP,
    );
  } else {
    final snackBar = SnackBar(
      elevation: 0,
      margin: const EdgeInsets.all(16),
      content: Row(
        children: [
          if (icon != null) icon,
          if (icon != null) const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              style: AppTextStyles.body2.copyWith(
                color: context.colorScheme.textPrimary,
              ),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
      backgroundColor: context.colorScheme.containerNormalOnSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
      duration: duration,
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
