import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/animations/parallax_effect.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:video_player/video_player.dart';
import '../../../../domain/assets/assets_paths.dart';
import 'package:style/animations/item_selector.dart';

class AppMediaItem extends StatefulWidget {
  final AppMedia media;
  final void Function()? onTap;
  final void Function()? onLongTap;
  final bool isSelected;
  final bool isUploading;

  const AppMediaItem({
    super.key,
    required this.media,
    this.onTap,
    this.onLongTap,
    this.isSelected = false,
    this.isUploading = false,
  });

  @override
  State<AppMediaItem> createState() => _AppMediaItemState();
}

class _AppMediaItemState extends State<AppMediaItem> with AutomaticKeepAliveClientMixin {
  final _imageKey = GlobalKey();
  VideoPlayerController? _videoPlayerController;


  @override
  void initState() {
    if (widget.media.type.isVideo &&
        widget.media.sources.contains(AppMediaSource.local)) {
      if (widget.media.sources.contains(AppMediaSource.local)) {
        _videoPlayerController =
            VideoPlayerController.file(File(widget.media.path))
              ..initialize().then((_) {
                setState(() {});
              });
      }
    }
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ItemSelector(
      onTap: widget.onTap,
      onLongTap: widget.onLongTap,
      isSelected: widget.isSelected,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          widget.media.type.isVideo &&
                  widget.media.sources.contains(AppMediaSource.local)
              ? _buildVideoView(context: context)
              : _buildImageView(context: context),
          if (widget.media.sources.contains(AppMediaSource.googleDrive) ||
              widget.isUploading)
            _sourceIndicators(context: context),
        ],
      ),
    );
  }

  Widget _sourceIndicators({required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withOpacity(0.6),
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
          if (widget.isUploading) const AppCircularProgressIndicator(size: 12),
        ],
      ),
    );
  }

  Widget _buildImageView({required BuildContext context}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Flow(
            delegate: ParallaxFlowDelegate(
              scrollable: Scrollable.of(context),
              listItemContext: context,
              backgroundImageKey: _imageKey,
            ),
            children: [
              Image(
                key: _imageKey,
                image: widget.media.sources.contains(AppMediaSource.local)
                    ? FileImage(File(widget.media.path))
                    : CachedNetworkImageProvider(widget.media.thumbnailPath!)
                        as ImageProvider,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(child: AppCircularProgressIndicator());
                },
                width: constraints.maxWidth,
                height: constraints.maxHeight * 1.5,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideoView({required BuildContext context}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            decoration: BoxDecoration(
              color: context.colorScheme.containerLowOnSurface,
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: VideoPlayer(_videoPlayerController!))),
        Icon(CupertinoIcons.play_arrow_solid, color: context.colorScheme.onPrimary),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
