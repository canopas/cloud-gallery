import 'dart:async';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_gallery/domain/formatter/duration_formatter.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:style/text/app_text_style.dart';
import '../../../../domain/assets/assets_paths.dart';
import 'package:style/animations/item_selector.dart';

class AppMediaItem extends StatefulWidget {
  final AppMedia media;
  final void Function()? onTap;
  final void Function()? onLongTap;
  final bool isSelected;
  final UploadStatus? status;

  const AppMediaItem({
    super.key,
    required this.media,
    this.onTap,
    this.onLongTap,
    this.isSelected = false,
    this.status,
  });

  @override
  State<AppMediaItem> createState() => _AppMediaItemState();
}

class _AppMediaItemState extends State<AppMediaItem>
    with AutomaticKeepAliveClientMixin {
  late Future<Uint8List?> thumbnailByte;

  @override
  void initState() {
    if (widget.media.sources.contains(AppMediaSource.local)) {
      _loadImage();
    }
    super.initState();
  }

  _loadImage() async {
    thumbnailByte = widget.media.thumbnailDataWithSize(const Size(300, 300));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) => ItemSelector(
        onTap: widget.onTap,
        onLongTap: widget.onLongTap,
        isSelected: widget.isSelected,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              _buildMediaView(context: context, constraints: constraints),
              if (widget.media.type.isVideo) _videoDuration(context),
              _sourceIndicators(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _videoDuration(BuildContext context) => Align(
        alignment: Alignment.bottomRight,
        child: _BackgroundContainer(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.play_fill,
                color: context.colorScheme.surfaceInverse,
                size: 14,
              ),
              const SizedBox(width: 2),
              Text(
                (widget.media.videoDuration ?? Duration.zero).format,
                style: AppTextStyles.caption.copyWith(
                  color: context.colorScheme.surfaceInverse,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildMediaView(
      {required BuildContext context, required BoxConstraints constraints}) {
    if (widget.media.sources.contains(AppMediaSource.local)) {
      return FutureBuilder(
        future: thumbnailByte,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Hero(
              tag: widget.media,
              child: Image.memory(
                snapshot.data!,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                fit: BoxFit.cover,
              ),
            );
          } else {
            return _buildPlaceholder(context: context, showLoader: false);
          }
        },
      );
    } else {
      return Hero(
        tag: widget.media,
        child: CachedNetworkImage(
            imageUrl: widget.media.thumbnailLink!,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => _buildErrorWidget(context),
            progressIndicatorBuilder: (context, url, progress) =>
                _buildPlaceholder(
                  context: context,
                  value: progress.progress,
                )),
      );
    }
  }

  Widget _buildPlaceholder(
          {required BuildContext context,
          double? value,
          bool showLoader = true}) =>
      Container(
        color: context.colorScheme.containerHighOnSurface,
        alignment: Alignment.center,
        child: showLoader ? AppCircularProgressIndicator(value: value) : null,
      );

  Widget _buildErrorWidget(BuildContext context) => Container(
        color: context.colorScheme.containerNormalOnSurface,
        alignment: Alignment.center,
        child: Icon(
          CupertinoIcons.exclamationmark_circle,
          color: context.colorScheme.onPrimary,
          size: 32,
        ),
      );

  Widget _sourceIndicators({required BuildContext context}) {
    return Row(
      children: [
        if (widget.media.sources.contains(AppMediaSource.googleDrive))
          _BackgroundContainer(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.media.sources.contains(AppMediaSource.googleDrive))
                  SvgPicture.asset(
                    Assets.images.icons.googlePhotos,
                    height: 14,
                    width: 14,
                  ),
              ],
            ),
          ),
        if (widget.status == UploadStatus.uploading)
          _BackgroundContainer(
            child: AppCircularProgressIndicator(
              size: 16,
              color: context.colorScheme.surfaceInverse,
            ),
          ),
        if (widget.status == UploadStatus.waiting)
          _BackgroundContainer(
            child: Icon(
              CupertinoIcons.time,
              size: 16,
              color: context.colorScheme.surfaceInverse,
            ),
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _BackgroundContainer extends StatelessWidget {
  final Widget child;

  const _BackgroundContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withOpacity(0.6),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: child,
    );
  }
}
