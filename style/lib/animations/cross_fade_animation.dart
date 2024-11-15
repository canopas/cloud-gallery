import 'package:flutter/cupertino.dart';

class CrossFadeAnimation extends StatelessWidget {
  final bool showChild;
  final Widget child;
  final Alignment alignment;
  final Widget replacement;

  const CrossFadeAnimation({
    super.key,
    required this.showChild,
    required this.child,
    this.replacement = const SizedBox(
      width: double.infinity,
    ),
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      alignment: alignment,
      crossFadeState:
          showChild ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: child,
      secondChild: replacement,
      firstCurve: Curves.easeInOut,
      secondCurve: Curves.easeInOut,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
    );
  }
}
