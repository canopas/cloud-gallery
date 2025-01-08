import 'package:data/models/media/media_extension.dart';
import 'package:data/models/media_process/media_process.dart';
import 'package:flutter/material.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import '../../../../components/thumbnail_builder.dart';
import '../../../../domain/formatter/duration_formatter.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../../../../gen/assets.gen.dart';

class AppMediaItem extends StatelessWidget {
  final AppMedia media;
  final String heroTag;
  final void Function()? onTap;
  final void Function()? onLongTap;
  final bool isSelected;
  final UploadMediaProcess? uploadMediaProcess;
  final DownloadMediaProcess? downloadMediaProcess;

  const AppMediaItem({
    super.key,
    required this.media,
    required this.heroTag,
    this.onTap,
    this.onLongTap,
    this.isSelected = false,
    this.uploadMediaProcess,
    this.downloadMediaProcess,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        onTap: onTap,
        onLongPress: onLongTap,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            AnimatedOpacity(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 100),
              opacity: isSelected ? 0.6 : 1,
              child: AppMediaImage(
                radius: isSelected ? 4 : 0,
                size: constraints.biggest,
                media: media,
                heroTag: heroTag,
              ),
            ),
            if (media.type.isVideo) _videoDuration(context),
            if (!media.isLocalStored ||
                uploadMediaProcess != null ||
                downloadMediaProcess != null)
              _sourceIndicators(context: context),
            if (isSelected)
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.primary,
                  ),
                  child: const Icon(
                    CupertinoIcons.checkmark_alt,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _videoDuration(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: [0.0, 0.9],
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withValues(alpha: 0.4),
                Colors.transparent,
              ],
            ),
          ),
          padding: const EdgeInsets.all(4).copyWith(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                (media.videoDuration ?? Duration.zero).format,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontSize: 12,
                  shadows: [
                    Shadow(
                      color: Colors.grey.shade400,
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                CupertinoIcons.play_fill,
                color: Colors.white,
                size: 14,
                shadows: [
                  Shadow(
                    color: Colors.grey.shade400,
                    blurRadius: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _sourceIndicators({required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.all(4).copyWith(top: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.0, 0.9],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.4),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          if (media.sources.contains(AppMediaSource.googleDrive))
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: SvgPicture.asset(
                Assets.images.icGoogleDrive,
                height: 10,
                width: 10,
              ),
            ),
          if (media.sources.contains(AppMediaSource.dropbox) &&
              media.sources.contains(AppMediaSource.googleDrive))
            const SizedBox(width: 4),
          if (media.sources.contains(AppMediaSource.dropbox))
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: SvgPicture.asset(
                Assets.images.icDropbox,
                height: 10,
                width: 10,
              ),
            ),
          Spacer(),
          if (uploadMediaProcess != null &&
                  uploadMediaProcess!.status.isWaiting ||
              downloadMediaProcess != null &&
                  downloadMediaProcess!.status.isWaiting)
            Icon(
              Icons.watch_later_outlined,
              size: 14,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.grey.shade400,
                  blurRadius: 5,
                ),
              ],
            ),
          if (uploadMediaProcess != null &&
              uploadMediaProcess!.status.isRunning)
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
      ),
    );
  }

  Widget _progressIndicator({
    required BuildContext context,
    required double progressPercentage,
    required double progress,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppCircularProgressIndicator(
          value: progress,
          color: Colors.white,
          size: 14,
          backgroundColor: Colors.white38,
        ),
        const SizedBox(width: 4),
        Text(
          "${progressPercentage.toInt()}%",
          style: AppTextStyles.caption.copyWith(
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.grey.shade400,
                blurRadius: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
