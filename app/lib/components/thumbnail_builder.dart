import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'app_media_image_provider.dart';

class AppMediaImage extends StatelessWidget {
  final Object? heroTag;
  final AppMedia media;
  final Size size;
  final double radius;

  const AppMediaImage({
    super.key,
    required this.size,
    this.heroTag,
    this.radius = 4,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Hero(
        tag: heroTag ?? '',
        child: Image(
          image: AppMediaImageProvider(media: media, thumbnailSize: size),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress != null) {
              return AppMediaPlaceHolder(
                size: size,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              );
            }
            return child;
          },
          errorBuilder: (context, error, stackTrace) {
            return AppMediaErrorPlaceHolder(size: size);
          },
          height: size.height,
          width: size.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class AppMediaPlaceHolder extends StatelessWidget {
  final double? value;
  final Size? size;
  final bool showLoader;

  const AppMediaPlaceHolder({
    super.key,
    this.value,
    this.showLoader = true,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size?.height,
      width: size?.width,
      color: context.colorScheme.containerHighOnSurface,
      alignment: Alignment.center,
      child: showLoader ? AppCircularProgressIndicator(value: value) : null,
    );
  }
}

class AppMediaErrorPlaceHolder extends StatelessWidget {
  final Size? size;

  const AppMediaErrorPlaceHolder({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size?.height,
      width: size?.width,
      color: context.colorScheme.containerNormalOnSurface,
      alignment: Alignment.center,
      child: Icon(
        CupertinoIcons.exclamationmark_circle,
        color: context.colorScheme.onPrimary,
        size: 32,
      ),
    );
  }
}
