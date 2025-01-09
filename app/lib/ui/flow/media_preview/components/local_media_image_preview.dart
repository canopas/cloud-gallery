import 'dart:io';
import 'package:style/extensions/context_extensions.dart';
import '../../../../components/app_page.dart';
import '../../../../components/place_holder_screen.dart';
import '../../../../domain/extensions/context_extensions.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/material.dart';
import '../../../../domain/image_providers/app_media_image_provider.dart';

class LocalMediaImagePreview extends StatelessWidget {
  final AppMedia media;
  final String heroTag;

  const LocalMediaImagePreview({
    super.key,
    required this.media,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final width = context.mediaQuerySize.width;
    double multiplier = 1;
    if (media.displayWidth != null && media.displayWidth! > 0) {
      multiplier = width / media.displayWidth!;
    }
    final height = media.displayHeight != null && media.displayHeight! > 0
        ? media.displayHeight! * multiplier
        : width;
    return Center(
      child: Hero(
        tag: "$heroTag${media.toString()}",
        child: Image.file(
          width: width,
          height: height,
          alignment: Alignment.center,
          gaplessPlayback: true,
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
            }
            if (frame == null) {
              return Image(
                image: AppMediaImageProvider(media: media),
                width: width,
                height: height,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return AppPage(
                    body: PlaceHolderScreen(
                      title: context.l10n.unable_to_load_media_error,
                      message: context.l10n.unable_to_load_media_message,
                    ),
                  );
                },
              );
            }

            return SizedBox(width: width, height: height, child: child);
          },
        ),
      ),
    );
  }
}
