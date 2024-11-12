import 'package:flutter/material.dart';

class AnimatedIconAnimation extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  final Curve reverseCurve;
  final Duration reverseDuration;
  final AnimatedIconData icon;
  final double size;
  final Color color;
  final bool value;

  const AnimatedIconAnimation({
    Key? key,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.reverseCurve = Curves.easeInOut,
    required this.icon,
    this.size = 24,
    this.color = const Color(0xffffffff),
    required this.value,
  }) : super(key: key);

  @override
  State<AnimatedIconAnimation> createState() => _AnimatedIconAnimationState();
}

class _AnimatedIconAnimationState extends State<AnimatedIconAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animatedIconController;

  @override
  void initState() {
    super.initState();
    _animatedIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    if (widget.value) {
      _animatedIconController.value = 1.0;
    } else {
      _animatedIconController.value = 0.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedIconAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _animatedIconController.forward();
      } else {
        _animatedIconController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animatedIconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedIcon(
      icon: widget.icon,
      progress: CurvedAnimation(
        parent: _animatedIconController,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve,
      ),
      color: widget.color,
      size: widget.size,
    );
  }
}
