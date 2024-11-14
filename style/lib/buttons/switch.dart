import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;

  const AppSwitch({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: context.colorScheme.positive,
        activeColor: context.colorScheme.positive,
        thumbColor: WidgetStateProperty.all(context.colorScheme.surface),
        inactiveTrackColor: context.colorScheme.containerNormal,
      ),
    );
  }
}
