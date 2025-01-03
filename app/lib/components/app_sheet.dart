import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';

Future<T?> showAppSheet<T>({
  required BuildContext context,
  required Widget child,
}) {
  return showModalBottomSheet(
    useRootNavigator: true,
    backgroundColor: context.colorScheme.containerNormalOnSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
    ),
    context: context,
    builder: (context) {
      return Container(
        width: context.mediaQuerySize.width,
        decoration: BoxDecoration(
          color: context.colorScheme.containerNormalOnSurface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: child,
        ),
      );
    },
  );
}
