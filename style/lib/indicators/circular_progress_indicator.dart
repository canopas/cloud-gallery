import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';

class AppCircularProgressIndicator extends StatefulWidget {
  final Color? color;
  final double size;

  const AppCircularProgressIndicator({
    super.key,
    this.color,
    this.size = 32,
  });

  @override
  State<AppCircularProgressIndicator> createState() =>
      _AppCircularProgressIndicatorState();
}

class _AppCircularProgressIndicatorState
    extends State<AppCircularProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.color ?? context.colorScheme.primary,
        ),
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
