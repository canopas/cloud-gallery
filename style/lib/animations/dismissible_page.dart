import 'package:flutter/cupertino.dart';

class DismissiblePage extends StatefulWidget {
  final Widget child;
  final double threshold;
  final bool enableScale;
  final Color backgroundColor;
  final void Function(double scale)? onScaleChange;
  final void Function(double displacement)? onDragDown;
  final void Function(double displacement)? onDragUp;
  final void Function()? onDismiss;
  final double scaleDownPercentage;

  const DismissiblePage({
    Key? key,
    required this.child,
    this.threshold = 100,
    this.enableScale = true,
    this.onScaleChange,
    this.onDragDown,
    this.onDragUp,
    required this.backgroundColor,
    this.onDismiss,
    this.scaleDownPercentage = 0.25,
  }) : super(key: key);

  @override
  State<DismissiblePage> createState() => _DismissiblePageState();
}

class _DismissiblePageState extends State<DismissiblePage> {
  double _startY = 0.0;
  double _displacement = 0.0;
  double _percentage = 0.0;
  bool _isZoomed = false;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 100,
      scaleEnabled: widget.enableScale,
      onInteractionStart: (details) {
        _startY = details.localFocalPoint.dy;
      },
      onInteractionUpdate: (details) {
        if ((details.localFocalPoint.dy - _startY) > 0 &&
            details.pointerCount == 1 &&
            !_isZoomed) {
          setState(() {
            _displacement = details.localFocalPoint.dy - _startY;
            _percentage = (_displacement / widget.threshold).clamp(0, 1);
            widget.onDragDown?.call(_displacement);
          });
        } else if ((details.localFocalPoint.dy - _startY) < 0 &&
            details.pointerCount == 1 &&
            !_isZoomed) {
          widget.onDragUp?.call(_startY - details.localFocalPoint.dy);
        } else {
          if (details.pointerCount == 2) {
            _isZoomed = details.scale > 1;
            widget.onScaleChange?.call(details.scale);
          }
          setState(() {
            _displacement = 0.0;
            _percentage = (_displacement / widget.threshold).clamp(0, 1);
            widget.onDragDown?.call(_displacement);
          });
        }
      },
      onInteractionEnd: (details) {
        if (_displacement > widget.threshold) {
          widget.onDismiss?.call();
        } else {
          setState(() {
            _displacement = 0.0;
            _percentage = (_displacement / widget.threshold).clamp(0, 1);
            widget.onDragDown?.call(_displacement);
          });
        }
      },
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(0.0, _displacement)
          ..scale(1 - (_percentage * widget.scaleDownPercentage)),
        child: widget.child,
      ),
    );
  }
}
