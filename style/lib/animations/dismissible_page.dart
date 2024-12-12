import 'package:flutter/cupertino.dart';

class DismissiblePage extends StatefulWidget {
  final Widget Function(double progress) child;
  final double threshold;
  final Color backgroundColor;
  final bool enable;
  final void Function(double progress)? onProgress;
  final void Function()? onDismiss;
  final double scaleDownPercentage;

  const DismissiblePage({
    Key? key,
    required this.child,
    this.threshold = 100,
    this.onProgress,
    this.enable = true,
    this.onDismiss,
    this.scaleDownPercentage = 0.25,
    this.backgroundColor = const Color(0xff000000),
  }) : super(key: key);

  @override
  State<DismissiblePage> createState() => _DismissiblePageState();
}

class _DismissiblePageState extends State<DismissiblePage> {
  double _startY = 0.0;
  double displacement = 0.0;
  double percentage = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (DragStartDetails details) {
        _startY = details.globalPosition.dy;
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if ((details.globalPosition.dy - _startY) > 0 && widget.enable) {
          setState(() {
            displacement = details.globalPosition.dy - _startY;
            percentage = (displacement / widget.threshold).clamp(0, 1);
          });
          widget.onProgress?.call(percentage);
        }
      },
      onVerticalDragEnd: (DragEndDetails details) {
        if (displacement > widget.threshold) {
          widget.onDismiss?.call();
        } else {
          setState(() {
            displacement = 0.0;
            percentage = 0.0;
          });
        }
      },
      child: Stack(
        children: [
          Container(
            color: widget.backgroundColor.withValues(alpha: 1 - percentage),
            height: double.infinity,
            width: double.infinity,
          ),
          Transform.translate(
            offset: Offset(0, displacement),
            child: Transform.scale(
              scale: 1 - (percentage * widget.scaleDownPercentage),
              child: widget.child(percentage),
            ),
          ),
        ],
      ),
    );
  }
}
