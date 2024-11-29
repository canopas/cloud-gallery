import 'package:data/models/media_process/media_process.dart';
import '../../../../domain/extensions/context_extensions.dart';
import '../../../../domain/formatter/byte_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class UploadProcessItem extends StatelessWidget {
  final UploadMediaProcess process;
  final void Function() onCancelTap;

  const UploadProcessItem({
    super.key,
    required this.process,
    required this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                process.path.split('/').lastOrNull ?? process.media_id,
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
              if (process.status.isRunning) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${process.chunk.formatBytes}  ${process.progressPercentage.toStringAsFixed(0)}%',
                      style: AppTextStyles.body2.copyWith(
                        color: context.colorScheme.textSecondary,
                      ),
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: process.progress,
                        backgroundColor: context.colorScheme.outline,
                        borderRadius: BorderRadius.circular(4),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.colorScheme.primary,
                        ),
                      ),
                    ),
                    Text(
                      process.total.formatBytes,
                      style: AppTextStyles.body2.copyWith(
                        color: context.colorScheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
              if (process.status.isFailed)
                Text(
                  "Failed",
                  style: AppTextStyles.body2.copyWith(
                    color: context.colorScheme.textSecondary,
                  ),
                ),
              if (process.status.isCompleted)
                Text(
                  "Uploaded Successfully",
                  style: AppTextStyles.body2.copyWith(
                      color: context.colorScheme.textSecondary,
                  ),
                ),
              if (process.status.isTerminated)
                Text(
                  "Upload Cancelled",
                  style: AppTextStyles.body2.copyWith(
                    color: context.colorScheme.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        ActionButton(
          onPressed: onCancelTap,
          icon: const Icon(CupertinoIcons.xmark),
        ),
      ],
    );
  }
}

class DownloadProcessItem extends StatelessWidget {
  final DownloadMediaProcess process;
  final void Function() onCancelTap;

  const DownloadProcessItem({
    super.key,
    required this.process,
    required this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                process.media_id,
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
              if (process.status.isRunning) ...[
                LinearProgressIndicator(
                  value: process.progress,
                  backgroundColor: context.colorScheme.outline,
                  borderRadius: BorderRadius.circular(4),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${process.chunk.formatBytes}  ${process.progressPercentage.toStringAsFixed(0)}%',
                      style: AppTextStyles.body2.copyWith(
                        color: context.colorScheme.textSecondary,
                      ),
                    ),
                    Text(
                      process.total.formatBytes,
                      style: AppTextStyles.body2.copyWith(
                        color: context.colorScheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        ActionButton(
          onPressed: onCancelTap,
          icon: const Icon(CupertinoIcons.xmark),
        ),
      ],
    );
  }
}