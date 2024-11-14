import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class HintView extends StatelessWidget {
  final String title;
  final String hint;
  final String actionTitle;
  final VoidCallback? onActionTap;
  final VoidCallback onClose;

  const HintView({
    super.key,
    required this.hint,
    required this.onClose,
    this.actionTitle = '',
    this.onActionTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.containerNormalOnSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, left: 16),
                  child: Text(
                    title,
                    style: AppTextStyles.subtitle2.copyWith(
                      color: context.colorScheme.textPrimary,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(bottom: 4),
                child: ActionButton(
                  backgroundColor: context.colorScheme.containerNormal,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  size: 28,
                  onPressed: onClose,
                  icon: Icon(
                    CupertinoIcons.xmark,
                    color: context.colorScheme.textSecondary,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: Text(
              hint,
              style: AppTextStyles.body2.copyWith(
                color: context.colorScheme.textSecondary,
              ),
            ),
          ),
          if (onActionTap != null)
            FilledButton(
              onPressed: onActionTap,
              style: FilledButton.styleFrom(
                backgroundColor: context.colorScheme.containerNormal,
                foregroundColor: context.colorScheme.textPrimary,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size(double.maxFinite, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                actionTitle,
                style: AppTextStyles.button,
              ),
            ),
        ],
      ),
    );
  }
}
