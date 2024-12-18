import 'package:flutter/material.dart';
import '../animations/on_tap_scale.dart';
import '../extensions/column_extension.dart';
import '../extensions/context_extensions.dart';
import '../text/app_text_style.dart';

class ActionList extends StatelessWidget {
  final List<Widget> buttons;
  final EdgeInsetsGeometry margin;
  final BorderRadius borderRadius;
  final Color? background;

  const ActionList({
    super.key,
    required this.buttons,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.background,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

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
        itemBuilder: (index) => buttons[index],
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
}

class ActionListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final VoidCallback? onPressed;
  final Widget? trailing;

  const ActionListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.onPressed,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return OnTapScale(
      enabled: onPressed != null,
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.body2.copyWith(
                              color: context.colorScheme.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: AppTextStyles.body2.copyWith(
                                color: context.colorScheme.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
