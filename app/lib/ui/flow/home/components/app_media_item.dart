import '../../../../components/thumbnail_builder.dart';
import '../../../../domain/formatter/duration_formatter.dart';
import 'package:data/models/app_process/app_process.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:style/text/app_text_style.dart';
import '../../../../domain/assets/assets_paths.dart';
import 'package:style/animations/item_selector.dart';

class AppMediaItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ItemSelector(
        onTap: onTap,
        onLongTap: onLongTap,
        isSelected: isSelected,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              AppMediaImage(
                size: constraints.biggest,
                media: media,
                heroTag: media,
              ),
              if (media.type.isVideo) _videoDuration(context),
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
                (media.videoDuration ?? Duration.zero).format,
                style: AppTextStyles.caption.copyWith(
                  color: context.colorScheme.surfaceInverse,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _sourceIndicators({required BuildContext context}) {
    return Row(
      children: [
        if (media.sources.contains(AppMediaSource.googleDrive))
          _BackgroundContainer(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (media.sources.contains(AppMediaSource.googleDrive))
                  SvgPicture.asset(
                    Assets.images.icons.googleDrive,
                    height: 14,
                    width: 14,
                  ),
              ],
            ),
          ),
        if (process?.status.isProcessing ?? false)
          _BackgroundContainer(
            margin: EdgeInsets.symmetric(
              vertical: 4,
              horizontal:
                  media.sources.contains(AppMediaSource.googleDrive) ? 0 : 4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppCircularProgressIndicator(
                  size: 16,
                  value: process?.progress?.percentageInPoint,
                  color: context.colorScheme.surfaceInverse,
                ),
                if (process?.progress != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    '${process?.progress?.percentage.toStringAsFixed(0)}%',
                    style: AppTextStyles.caption.copyWith(
                      color: context.colorScheme.surfaceInverse,
                    ),
                  ),
                ],
              ],
            ),
          ),
        if (process?.status.isWaiting ?? false)
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
}

class _BackgroundContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;

  const _BackgroundContainer({
    required this.child,
    this.margin = const EdgeInsets.all(4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withOpacity(0.6),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: child,
    );
  }
}
