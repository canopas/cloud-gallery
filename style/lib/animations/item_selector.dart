import 'package:flutter/cupertino.dart';
import 'package:style/extensions/context_extensions.dart';

class ItemSelector extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onLongTap;
  final bool isSelected;
  final Widget child;

  const ItemSelector(
      {super.key,
      this.onTap,
      this.onLongTap,
      required this.isSelected,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongTap,
      child: Stack(
        children: [
          AnimatedScale(
            curve: Curves.easeInOut,
            scale: isSelected ? 0.9 : 1,
            duration: const Duration(milliseconds: 100),
            child: AnimatedOpacity(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 100),
                opacity: isSelected ? 0.7 : 1,
                child: child),
          ),
          if (isSelected)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colorScheme.surface,
                  border: Border.all(
                    color: const Color(0xff808080),
                  ),
                ),
                child: const Icon(
                  CupertinoIcons.checkmark_alt,
                  color: Color(0xff808080),
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
