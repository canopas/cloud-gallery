import 'package:flutter/widgets.dart';

const _defaultSwitcherTimeMillis = Duration(milliseconds: 300);

class FadeInSwitcher extends StatefulWidget {
  final Widget child;

  const FadeInSwitcher({
    super.key,
    required this.child,
  });

  @override
  State<FadeInSwitcher> createState() => _FadeInSwitcherState();
}

class _FadeInSwitcherState extends State<FadeInSwitcher> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _defaultSwitcherTimeMillis,
      child: widget.child,
    );
  }
}
