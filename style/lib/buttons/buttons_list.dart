import 'package:flutter/material.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/extensions/column_extension.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class ActionListButton {
  final String title;
  final Widget? leading;
  final VoidCallback? onPressed;
  final Widget? trailing;

  const ActionListButton({
    required this.title,
    this.leading,
    this.onPressed,
    this.trailing,
  });
}

class ActionList extends StatelessWidget {
  final List<ActionListButton> buttons;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;
  final Color? background;

  const ActionList(
      {super.key,
      required this.buttons,
      this.margin,
      this.background,
      this.borderRadius = const BorderRadius.all(Radius.circular(12))});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: background ?? context.colorScheme.containerNormal,
      ),
      child: ColumnBuilder.separated(
        itemCount: buttons.length,
        itemBuilder: (index) =>
            _buildButton(context: context, button: buttons[index]),
        separatorBuilder: (index) => Divider(
          color: context.colorScheme.outline,
          height: 0,
          thickness: 0.8,
          indent: 16,
          endIndent: 16,
        ),
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  Widget _buildButton(
      {required BuildContext context, required ActionListButton button}) {
    return OnTapScale(
      enabled: button.onPressed != null,
      onTap: button.onPressed,
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              if (button.leading != null) ...[
                button.leading!,
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(
                  button.title,
                  style: AppTextStyles.body2
                      .copyWith(color: context.colorScheme.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (button.trailing != null) button.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
