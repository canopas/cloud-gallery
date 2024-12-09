import 'package:data/domain/formatters/byte_formatter.dart';
import 'package:data/models/media_process/media_process.dart';
import '../../../../domain/extensions/context_extensions.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import '../../../../components/error_view.dart';
import '../../../../domain/image_providers/app_media_image_provider.dart';

class DownloadRequireView extends StatelessWidget {
  final AppMedia media;
  final String? dropboxAccessToken;
  final DownloadMediaProcess? downloadProcess;
  final void Function() onDownload;

  const DownloadRequireView({
    super.key,
    required this.media,
    this.downloadProcess,
    required this.onDownload,
    this.dropboxAccessToken,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: media,
            child: Image(
              image: AppMediaImageProvider(
                media: media,
                dropboxAccessToken: dropboxAccessToken,
                thumbnailSize: Size(2000, 1500),
              ),
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox();
              },
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black38,
          ),
          if (downloadProcess?.progress != null &&
              downloadProcess!.status.isRunning) ...[
            ErrorView(
              foregroundColor: context.colorScheme.onPrimary,
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  AppCircularProgressIndicator(
                    backgroundColor: context.colorScheme.outline,
                    color: context.colorScheme.onPrimary,
                    strokeWidth: 6,
                    size: context.mediaQuerySize.width * 0.15,
                    value: downloadProcess?.progress,
                  ),
                  Icon(
                    CupertinoIcons.cloud_download,
                    color: context.colorScheme.onPrimary,
                    size: context.mediaQuerySize.width * 0.08,
                  ),
                ],
              ),
              title:
                  "${downloadProcess?.chunk.formatBytes ?? "0.0 B"} - ${downloadProcess?.total.formatBytes ?? "0.0 B"} ${downloadProcess?.progressPercentage.toStringAsFixed(0) ?? "0.0"}%",
              message: context.l10n.download_in_progress_text,
            ),
          ],
          if (downloadProcess?.progress == null)
            ErrorView(
              foregroundColor: context.colorScheme.onPrimary,
              icon: Icon(
                CupertinoIcons.cloud_download,
                size: 68,
                color: context.colorScheme.onPrimary,
              ),
              title: context.l10n.download_require_text,
              message: context.l10n.download_require_message,
              action: ErrorViewAction(
                title: context.l10n.common_download,
                onPressed: onDownload,
              ),
            ),
        ],
      ),
    );
  }
}
