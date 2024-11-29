import 'package:data/models/media/media_extension.dart';
import 'package:data/models/media_process/media_process.dart';
import 'package:flutter/material.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:style/theme/colors.dart';
import '../../../../components/thumbnail_builder.dart';
import '../../../../domain/formatter/duration_formatter.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../../../../domain/assets/assets_paths.dart';
import 'package:style/animations/item_selector.dart';

class AppMediaItem extends StatelessWidget {
  final AppMedia media;
  final void Function()? onTap;
  final void Function()? onLongTap;
  final bool isSelected;
  final UploadMediaProcess? uploadMediaProcess;
  final DownloadMediaProcess? downloadMediaProcess;

  const AppMediaItem({
    super.key,
    required this.media,
    this.onTap,
    this.onLongTap,
    this.isSelected = false,
    this.uploadMediaProcess,
    this.downloadMediaProcess,
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
        if (!media.isLocalStored)
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
                if (media.sources.contains(AppMediaSource.dropbox) &&
                    media.sources.contains(AppMediaSource.googleDrive))
                  const SizedBox(width: 4),
                if (media.sources.contains(AppMediaSource.dropbox))
                  SvgPicture.asset(
                    Assets.images.icons.dropbox,
                    height: 14,
                    width: 14,
                  ),
              ],
            ),
          ),
        if (uploadMediaProcess?.status.isWaiting == true ||
            downloadMediaProcess?.status.isWaiting == true)
          _waitingIndicator(context),
        if (uploadMediaProcess != null && uploadMediaProcess!.status.isRunning)
          _progressIndicator(
            context: context,
            progressPercentage: uploadMediaProcess!.progressPercentage,
            progress: uploadMediaProcess!.progress,
          ),
        if (downloadMediaProcess != null &&
            downloadMediaProcess!.status.isRunning)
          _progressIndicator(
            context: context,
            progressPercentage: downloadMediaProcess!.progressPercentage,
            progress: downloadMediaProcess!.progress,
          ),
      ],
    );
  }

  Widget _waitingIndicator(BuildContext context) {
    return _BackgroundContainer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.watch_later_outlined,
            size: 14,
            color: context.colorScheme.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _progressIndicator({
    required BuildContext context,
    required double progressPercentage,
    required double progress,
  }) {
    return _BackgroundContainer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppCircularProgressIndicator(
            value: progress,
            color: context.colorScheme.textSecondary,
            size: 14,
          ),
          Text(
            "${uploadMediaProcess?.progressPercentage.toInt()}%",
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimaryDarkColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundContainer extends StatelessWidget {
  final Widget child;

  const _BackgroundContainer({
    required this.child,
  });

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
