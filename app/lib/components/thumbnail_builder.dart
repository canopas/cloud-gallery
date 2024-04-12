import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';

class AppMediaThumbnail extends StatelessWidget {
  final Object? heroTag;
  final AppMedia media;
  final Size size;
  final double radius;
  final Future<Uint8List?>? thumbnailByte;

  const AppMediaThumbnail({
    super.key,
    required this.size,
    this.heroTag,
    this.radius = 4,
    required this.thumbnailByte,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    if (media.sources.contains(AppMediaSource.local)) {
      return FutureBuilder(
        future: thumbnailByte,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Hero(
                tag: heroTag ?? '',
                child: Image.memory(
                  snapshot.data!,
                  height: size.height,
                  width: size.width,
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return AppMediaErrorPlaceHolder(
              size: size,
            );
          } else {
            return AppMediaPlaceHolder(
              showLoader: false,
              size: size,
            );
          }
        },
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
