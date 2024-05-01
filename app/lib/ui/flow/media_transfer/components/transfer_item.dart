import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/domain/formatter/byte_formatter.dart';
import 'package:data/models/app_process/app_process.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../../../../components/thumbnail_builder.dart';

class ProcessItem extends StatelessWidget {
  final AppProcess process;
  final void Function() onCancelTap;

  const ProcessItem(
      {super.key, required this.process, required this.onCancelTap});

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
                process.media.name != null &&
                        process.media.name!.trim().isNotEmpty
                    ? process.media.name!
                    : process.media.path,
                style: AppTextStyles.body.copyWith(
                  color: context.colorScheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              if (process.status.isWaiting)
                Text(
                  context.l10n.waiting_in_queue_text,
                  style: AppTextStyles.body2.copyWith(
                    color: context.colorScheme.textSecondary,
                  ),
                ),
              if (process.progress != null &&
                  process.status.isProcessing) ...[
                LinearProgressIndicator(
                  value: process.progress?.percentageInPoint,
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
                      '${process.progress?.chunk.formatBytes}  ${process.progress?.percentage.toStringAsFixed(0)}%',
                      style: AppTextStyles.body2.copyWith(
                        color: context.colorScheme.textSecondary,
                      ),
                    ),
                    Text(
                      '${process.progress?.total.formatBytes}',
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
          onPressed: onCancelTap,
          icon: const Icon(CupertinoIcons.xmark),
        )
      ],
    );
  }

  Widget _buildThumbnailView({required BuildContext context}) {
    return AppMediaThumbnail(
      size: const Size(80, 80),
      media: process.media,
    );
  }
}
