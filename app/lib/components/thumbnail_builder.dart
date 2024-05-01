import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';

class AppMediaThumbnail extends StatelessWidget {
  final Object? heroTag;
  final AppMedia media;
  final Size size;
  final double radius;
  final bool isOriginal;

  const AppMediaThumbnail({
    super.key,
    required this.size,
    this.heroTag,
    this.radius = 4,
    required this.media,
    this.isOriginal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (media.sources.contains(AppMediaSource.local)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Hero(
          tag: heroTag ?? '',
          child: AssetEntityImage(
            media.assetEntity,
            isOriginal: isOriginal,
            thumbnailSize:
                ThumbnailSize(size.width.toInt(), size.height.toInt()),
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
            thumbnailFormat: ThumbnailFormat.png,
            height: size.height,
            width: size.width,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Hero(
        tag: heroTag ?? '',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: CachedNetworkImage(
              imageUrl: media.thumbnailLink ?? '',
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => AppMediaErrorPlaceHolder(
                    size: size,
                  ),
              progressIndicatorBuilder: (context, url, progress) =>
                  AppMediaPlaceHolder(
                    size: size,
                    value: progress.progress,
                  )),
        ),
      );
    }
  }
}

class AppMediaPlaceHolder extends StatelessWidget {
  final double? value;
  final Size? size;
  final bool showLoader;

  const AppMediaPlaceHolder(
      {super.key, this.value, this.showLoader = true, this.size});

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
