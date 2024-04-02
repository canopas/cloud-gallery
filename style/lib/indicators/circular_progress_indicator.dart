import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  final Color? color;
  final double? value;
  final double size;

  const AppCircularProgressIndicator({
    super.key,
    this.color,
    this.size = 32,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: value != null
          ? CircularProgressIndicator(
              strokeWidth: size / 8,
              value: value,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? context.colorScheme.primary,
              ),
              strokeCap: StrokeCap.round,
            )
          : CircularProgressIndicator.adaptive(
              strokeWidth: size / 8,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? context.colorScheme.primary,
              ),
              strokeCap: StrokeCap.round,
            ),
    );
  }
}
