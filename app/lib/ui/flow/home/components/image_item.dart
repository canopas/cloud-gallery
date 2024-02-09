import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/animations/parallex_effect.dart';

class ImageItem extends StatefulWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLongTap;
  final ImageProvider imageProvider;
  final bool isSelected;

  const ImageItem({
    super.key,
    required this.imageProvider,
    this.onTap,
    this.onLongTap,
    this.isSelected = false,
  });

  @override
  State<ImageItem> createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  final _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ItemSelector(
      onTap: widget.onTap,
      onLongTap: widget.onLongTap,
      isSelected: widget.isSelected,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Flow(
              delegate: ParallaxFlowDelegate(
                scrollable: Scrollable.of(context),
                listItemContext: context,
                backgroundImageKey: _backgroundImageKey,
              ),
              children: [
                Image(
                  key: _backgroundImageKey,
                  image: widget.imageProvider,
                  fit: BoxFit.cover,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 1.5,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

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
    return OnTapScale(
      onTap: onTap,
      onLongTap: onLongTap,
      child: Stack(
        children: [
          AnimatedScale(
            scale: isSelected ? 0.9 : 1,
            duration: const Duration(milliseconds: 100),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: isSelected ? 0.7 : 1,
                child: child),
          ),
          if (isSelected)
             Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colorScheme.surface,
                  border: Border.all(
                    color: CupertinoColors.systemGreen,
                  ),
                ),
                child: const Icon(
                  CupertinoIcons.checkmark_alt,
                  color: CupertinoColors.systemGreen,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
