import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:style/animations/cross_fade_animation.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class SelectionMenuAction extends StatelessWidget {
  final String title;
  final Widget icon;
  final void Function() onTap;

  const SelectionMenuAction({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OnTapScale(
      onTap: onTap,
      child: SizedBox(
        width: 92,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: context.colorScheme.containerLowOnSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.colorScheme.outline),
              ),
              child: icon,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.body2.copyWith(
                color: context.colorScheme.textPrimary,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}

class SelectionMenu extends StatelessWidget {
  final List<Widget> items;
  final bool useSystemPadding;
  final bool show;

  const SelectionMenu({
    super.key,
    required this.items,
    this.useSystemPadding = true,
    required this.show,
  });

  @override
  Widget build(BuildContext context) {
    return CrossFadeAnimation(
      showChild: show,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.only(bottom: 16, top: 24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: context.colorScheme.outline,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              bottom: useSystemPadding,
              left: false,
              right: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: items,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
