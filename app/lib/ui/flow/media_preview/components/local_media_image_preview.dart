import 'dart:io';
import 'package:style/extensions/context_extensions.dart';
import '../../../../components/app_page.dart';
import '../../../../components/place_holder_screen.dart';
import '../../../../domain/extensions/context_extensions.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/material.dart';

class LocalMediaImagePreview extends StatelessWidget {
  final AppMedia media;
  final void Function(double scale)? onScale;

  const LocalMediaImagePreview({
    super.key,
    required this.media,
    this.onScale,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      onInteractionUpdate: (details) {
        if (details.pointerCount == 2) {
          onScale?.call(details.scale);
        }
      },
      maxScale: 100,
      child: Center(
        child: Hero(
          tag: media,
          child: Image.file(
            width: double.infinity,
            File(media.path),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return AppPage(
                body: PlaceHolderScreen(
                  title: context.l10n.unable_to_load_media_error,
                  message: context.l10n.unable_to_load_media_message,
                ),
              );
            },
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              } else {
                final width = context.mediaQuerySize.width;
                double multiplier = 1;
                if (media.displayWidth != null && media.displayWidth! > 0) {
                  multiplier = width / media.displayWidth!;
                }
                return SizedBox(
                  width: width,
                  height:
                      media.displayHeight != null && media.displayHeight! > 0
                          ? media.displayHeight! * multiplier
                          : width,
                  child: child,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
