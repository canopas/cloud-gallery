import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

Future<T?> showAppSheet<T>(BuildContext context, List<Widget> children) {
  return showModalBottomSheet(
    backgroundColor: context.colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
    ),
    context: context,
    builder: (context) {
      return Container(
        width: context.mediaQuerySize.width,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      );
    },
  );
}
