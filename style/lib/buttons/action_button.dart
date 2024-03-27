import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';

class ActionButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget icon;
  final bool progress;
  final Color? backgroundColor;
  final double size;
  final EdgeInsets padding;

  const ActionButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.size = 30,
      this.backgroundColor,
      this.progress = false,
      this.padding = const EdgeInsets.all(0)});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoButton(
        minSize: size,
        borderRadius: BorderRadius.circular(size),
        color: backgroundColor ?? context.colorScheme.containerNormal,
        onPressed: onPressed,
        padding: padding,
        child: progress ? const AppCircularProgressIndicator() : icon,
      );
    } else {
      return IconButton(
        style: IconButton.styleFrom(
          backgroundColor:
              backgroundColor ?? context.colorScheme.containerNormal,
          minimumSize: Size(size, size),
        ),
        onPressed: onPressed,
        icon: progress ? const AppCircularProgressIndicator() : icon,
        padding: padding,
      );
    }
  }
}
