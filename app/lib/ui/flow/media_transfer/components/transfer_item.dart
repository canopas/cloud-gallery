import 'dart:typed_data';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/domain/formatter/byte_formatter.dart';
import 'package:data/models/app_process/app_process.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../../../../components/thumbnail_builder.dart';

class ProcessItem extends StatefulWidget {
  final AppProcess process;
  final void Function() onCancelTap;

  const ProcessItem(
      {super.key, required this.process, required this.onCancelTap});

  @override
  State<ProcessItem> createState() => _ProcessItemState();
}

class _ProcessItemState extends State<ProcessItem> {
  Future<Uint8List?>? thumbnailByte;

  @override
  void initState() {
    if (widget.process.media.sources.contains(AppMediaSource.local)) {
      thumbnailByte =
          widget.process.media.loadThumbnail(size: const Size(80, 80));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildThumbnailView(context: context),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.process.media.name != null &&
                        widget.process.media.name!.trim().isNotEmpty
                    ? widget.process.media.name!
                    : widget.process.media.path,
                style: AppTextStyles.body.copyWith(
                  color: context.colorScheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              if (widget.process.status.isWaiting)
                Text(
                  context.l10n.waiting_in_queue_text,
                  style: AppTextStyles.body2.copyWith(
                    color: context.colorScheme.textSecondary,
                  ),
                ),
              if (widget.process.progress != null &&
                  widget.process.status.isProcessing) ...[
                LinearProgressIndicator(
                  value: widget.process.progress?.percentageInPoint,
                  backgroundColor: context.colorScheme.outline,
                  borderRadius: BorderRadius.circular(4),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      context.colorScheme.primary),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.process.progress?.chunk.formatBytes}  ${widget.process.progress?.percentage.toStringAsFixed(0)}%',
                      style: AppTextStyles.body2.copyWith(
                        color: context.colorScheme.textSecondary,
                      ),
                    ),
                    Text(
                      '${widget.process.progress?.total.formatBytes}',
                      style: AppTextStyles.body2.copyWith(
                        color: context.colorScheme.textSecondary,
                      ),
                    ),
                  ],
                )
              ]
            ],
          ),
        ),
          ActionButton(
            onPressed: widget.onCancelTap,
            icon: const Icon(CupertinoIcons.xmark),
          )
      ],
    );
  }

  Widget _buildThumbnailView({required BuildContext context}) {
    return AppMediaThumbnail(
      size: const Size(80, 80),
      thumbnailByte: thumbnailByte,
      media: widget.process.media,
    );
  }
}
