import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
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
  //VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    ///TODO: Video view
    // if (widget.media.type.isVideo &&
    //     widget.media.sources.contains(AppMediaSource.local)) {
    //
    //      _videoPlayerController =
    //          VideoPlayerController.file(File(widget.media.path))
    //            ..initialize().then((_) {
    //             setState(() {});
    //            });
    //
    // }
    super.initState();
  }

  @override
  void dispose() {
    // _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ItemSelector(
      onTap: widget.onTap,
      onLongTap: widget.onLongTap,
      isSelected: widget.isSelected,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            widget.media.type.isVideo && widget.media.thumbnailLink == null
                ? _buildVideoView(context: context)
                : _buildImageView(context: context),
            _sourceIndicators(context: context),
          ],
        ),
      ),
    );
  }

  Widget _sourceIndicators({required BuildContext context}) {
    return Row(
      children: [
        if (widget.media.sources.contains(AppMediaSource.googleDrive))
          Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.media.sources.contains(AppMediaSource.googleDrive))
                  SvgPicture.asset(
                    Assets.images.icons.googlePhotos,
                    height: 12,
                    width: 12,
                  ),
              ],
            ),
          ),
        if (widget.status == UploadStatus.uploading)
          AppCircularProgressIndicator(
            size: 22,
            color: context.colorScheme.onPrimary,
          ),
        if (widget.status == UploadStatus.waiting)
          Icon(
            CupertinoIcons.time,
            size: 22,
            color: context.colorScheme.onPrimary,
          ),
      ],
    );
  }

  Widget _buildImageView({required BuildContext context}) {
    return LayoutBuilder(builder: (context, constraints) {
      return Image(
        image: widget.media.sources.contains(AppMediaSource.local)
            ? ResizeImage(
                FileImage(File(widget.media.path)),
                height: constraints.maxHeight.toInt(),
                width: constraints.maxWidth.toInt(),
                policy: ResizeImagePolicy.fit,
              )
            : CachedNetworkImageProvider(widget.media.thumbnailLink!)
                as ImageProvider,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: context.colorScheme.containerNormalOnSurface,
            child: Center(
              child: AppCircularProgressIndicator(
                value: (loadingProgress.expectedTotalBytes != null &&
                        (loadingProgress.expectedTotalBytes ?? 0) > 0)
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: context.colorScheme.containerNormalOnSurface,
            child: Center(
              child: Icon(
                CupertinoIcons.photo,
                color: context.colorScheme.onPrimary,
                size: 32,
              ),
            ),
          );
        },
        width: double.maxFinite,
        height: double.maxFinite,
      );
    });
  }

  Widget _buildVideoView({required BuildContext context}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.containerNormalOnSurface,
          ),
          // child: VideoPlayer(_videoPlayerController!),
        ),
        Icon(CupertinoIcons.play_arrow_solid,
            color: context.colorScheme.onPrimary),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
