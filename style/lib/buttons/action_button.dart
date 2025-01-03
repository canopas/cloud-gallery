import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../indicators/circular_progress_indicator.dart';

class ActionButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget icon;
  final bool progress;
  final MaterialTapTargetSize tapTargetSize;
  final Color? backgroundColor;
  final double size;
  final EdgeInsets padding;

  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.size = 40,
    this.tapTargetSize = MaterialTapTargetSize.padded,
    this.backgroundColor,
    this.progress = false,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoButton(
        minSize: size,
        borderRadius: BorderRadius.circular(size),
        color: backgroundColor,
        onPressed: onPressed,
        padding: padding,
        child: progress ? const AppCircularProgressIndicator() : icon,
      );
    } else {
      return IconButton(
        style: IconButton.styleFrom(
          tapTargetSize: tapTargetSize,
          backgroundColor: backgroundColor,
          minimumSize: Size(size, size),
        ),
        onPressed: onPressed,
        icon: progress ? const AppCircularProgressIndicator() : icon,
        padding: padding,
      );
    }
  }
}
