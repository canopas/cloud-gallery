import 'package:data/domain/formatters/byte_formatter.dart';
import 'package:data/models/media_process/media_process.dart';
import '../../../../domain/extensions/context_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class UploadProcessItem extends StatelessWidget {
  final UploadMediaProcess process;
  final void Function() onCancelTap;
  final void Function() onRemoveTap;
  final void Function() onPausedTap;
  final void Function() onResumeTap;

  const UploadProcessItem({
    super.key,
    required this.process,
    required this.onCancelTap,
    required this.onRemoveTap,
    required this.onPausedTap,
    required this.onResumeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8),
      child: Row(
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
                const SizedBox(height: 2),
                if (!process.status.isRunning)
                  Text(
                    _getUploadMessage(context),
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
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${process.chunk.formatBytes} - ${process.progressPercentage.toStringAsFixed(0)}%',
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
          if (process.status.isPaused)
            ActionButton(
              onPressed: onResumeTap,
              icon: Icon(
                CupertinoIcons.play,
                color: context.colorScheme.textPrimary,
                size: 20,
              ),
            ),
          if (process.status.isRunning)
            ActionButton(
              onPressed: onPausedTap,
              icon: Icon(
                CupertinoIcons.pause,
                color: context.colorScheme.textPrimary,
                size: 20,
              ),
            ),
          if (process.status.isRunning ||
              process.status.isWaiting ||
              process.status.isPaused)
            ActionButton(
              onPressed: onCancelTap,
              icon: Icon(
                CupertinoIcons.xmark,
                color: context.colorScheme.textPrimary,
                size: 20,
              ),
            ),
          if (process.status.isFailed)
            ActionButton(
              onPressed: onResumeTap,
              icon: Icon(
                CupertinoIcons.refresh,
                color: context.colorScheme.textSecondary,
                size: 20,
              ),
            ),
          if (process.status.isTerminated ||
              process.status.isFailed ||
              process.status.isCompleted)
            ActionButton(
              onPressed: onRemoveTap,
              icon: Icon(
                CupertinoIcons.trash,
                color: context.colorScheme.textSecondary,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  String _getUploadMessage(BuildContext context) {
    if (process.status.isWaiting) {
      return context.l10n.upload_status_waiting;
    } else if (process.status.isPaused) {
      return context.l10n.upload_status_paused;
    } else if (process.status.isFailed) {
      return context.l10n.upload_status_failed;
    } else if (process.status.isCompleted) {
      return context.l10n.upload_status_success;
    } else if (process.status.isTerminated) {
      return context.l10n.upload_status_cancelled;
    }
    return '';
  }
}

class DownloadProcessItem extends StatelessWidget {
  final DownloadMediaProcess process;
  final void Function() onCancelTap;
  final void Function() onRemoveTap;

  const DownloadProcessItem({
    super.key,
    required this.process,
    required this.onCancelTap,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  process.name,
                  style: AppTextStyles.body.copyWith(
                    color: context.colorScheme.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                if (!process.status.isRunning)
                  Text(
                    _getMessage(context),
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
                  const SizedBox(height: 2),
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
          if (process.status.isRunning || process.status.isWaiting)
            ActionButton(
              onPressed: onCancelTap,
              icon: Icon(
                CupertinoIcons.xmark,
                color: context.colorScheme.textPrimary,
                size: 20,
              ),
            ),
          if (process.status.isTerminated ||
              process.status.isFailed ||
              process.status.isCompleted)
            ActionButton(
              onPressed: onRemoveTap,
              icon: Icon(
                CupertinoIcons.trash,
                color: context.colorScheme.textPrimary,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  String _getMessage(BuildContext context) {
    if (process.status.isWaiting) {
      return context.l10n.download_status_waiting;
    } else if (process.status.isFailed) {
      return context.l10n.download_status_failed;
    } else if (process.status.isCompleted) {
      return context.l10n.download_status_success;
    } else if (process.status.isTerminated) {
      return context.l10n.download_status_cancelled;
    }
    return '';
  }
}
