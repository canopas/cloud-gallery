import 'dart:typed_data';
import 'package:cloud_gallery/components/thumbnail_builder.dart';
import 'package:cloud_gallery/domain/formatter/duration_formatter.dart';
import 'package:data/models/app_process/app_process.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:flutter/cupertino.dart';
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
  final AppProcess? process;

  const AppMediaItem({
    super.key,
    required this.media,
    this.onTap,
    this.onLongTap,
    this.isSelected = false,
    this.process,
  });

  @override
  State<AppMediaItem> createState() => _AppMediaItemState();
}

class _AppMediaItemState extends State<AppMediaItem>
    with AutomaticKeepAliveClientMixin {
  Future<Uint8List?>? thumbnailByte;

  @override
  void initState() {
    if (widget.media.sources.contains(AppMediaSource.local)) {
      thumbnailByte = widget.media.loadThumbnail();
    }
    super.initState();
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
    return AppMediaThumbnail(
      size: constraints.biggest,
      thumbnailByte: thumbnailByte,
      media: widget.media,
      heroTag: widget.media,
    );
  }

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
                    Assets.images.icons.googleDrive,
                    height: 14,
                    width: 14,
                  ),
              ],
            ),
          ),
        if (widget.process?.status.isProcessing ?? false)
          _BackgroundContainer(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppCircularProgressIndicator(
                  size: 16,
                  value: widget.process?.progress?.percentageInPoint,
                  color: context.colorScheme.surfaceInverse,
                ),
                if (widget.process?.progress != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    '${widget.process?.progress?.percentage.toStringAsFixed(0)}%',
                    style: AppTextStyles.caption.copyWith(
                      color: context.colorScheme.surfaceInverse,
                    ),
                  ),
                ]
              ],
            ),
          ),
        if (widget.process?.status.isWaiting ?? false)
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
