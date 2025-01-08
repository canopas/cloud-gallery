import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../domain/formatter/duration_formatter.dart';
import 'thumbnail_builder.dart';

class AppMediaThumbnail extends StatelessWidget {
  final AppMedia media;
  final String heroTag;
  final void Function()? onTap;
  final void Function()? onLongTap;
  final bool selected;

  const AppMediaThumbnail({
    super.key,
    required this.media,
    required this.heroTag,
    this.onTap,
    this.onLongTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        onTap: onTap,
        onLongPress: onLongTap,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            AnimatedOpacity(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 100),
              opacity: selected ? 0.6 : 1,
              child: AppMediaImage(
                radius: selected ? 4 : 0,
                size: constraints.biggest,
                media: media,
                heroTag: heroTag,
              ),
            ),
            if (media.type.isVideo) _videoDuration(context),
            if (selected)
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.primary,
                  ),
                  child: const Icon(
                    CupertinoIcons.checkmark_alt,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _videoDuration(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: [0.0, 0.9],
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withValues(alpha: 0.4),
                Colors.transparent,
              ],
            ),
          ),
          padding: const EdgeInsets.all(4).copyWith(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                (media.videoDuration ?? Duration.zero).format,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontSize: 12,
                  shadows: [
                    Shadow(
                      color: Colors.grey.shade400,
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                CupertinoIcons.play_fill,
                color: Colors.white,
                size: 14,
                shadows: [
                  Shadow(
                    color: Colors.grey.shade400,
                    blurRadius: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
