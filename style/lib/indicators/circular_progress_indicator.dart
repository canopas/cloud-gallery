import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  final Color? color;
  final Color? backgroundColor;
  final double? value;
  final double? strokeWidth;
  final double size;

  const AppCircularProgressIndicator({
    super.key,
    this.color,
    this.size = 32,
    this.backgroundColor,
    this.value,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: value != null
          ? CircularProgressIndicator(
              strokeWidth: strokeWidth ?? size / 8,
              value: value,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? context.colorScheme.primary,
              ),
              backgroundColor: backgroundColor,
              strokeCap: StrokeCap.round,
            )
          : CircularProgressIndicator.adaptive(
              strokeWidth: size / 8,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? context.colorScheme.primary,
              ),
              backgroundColor: backgroundColor,
              strokeCap: StrokeCap.round,
            ),
    );
  }
}
