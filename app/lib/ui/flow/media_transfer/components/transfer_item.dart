import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:style/text/app_text_style.dart';

class ProcessItem extends StatefulWidget {
  final AppProcess process;
  final void Function() onCancelTap;

  const ProcessItem(
      {super.key, required this.process, required this.onCancelTap});

  @override
  State<ProcessItem> createState() => _ProcessItemState();
}

class _ProcessItemState extends State<ProcessItem> {

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
              if (widget.process.progress != null && widget.process.status.isProcessing) ...[
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
        if (widget.process.status.isWaiting)
          ActionButton(
            onPressed: widget.onCancelTap,
            icon: const Icon(CupertinoIcons.xmark),
          )
      ],
    );
  }

  Widget _buildThumbnailView({required BuildContext context}) {
    if (widget.process.media.sources.contains(AppMediaSource.local)) {
      return FutureByteLoader(
        bytes: widget.process.media.loadThumbnail(size: const Size(100, 100)),
        builder: (context, bytes) => Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: context.colorScheme.containerHighOnSurface,
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: MemoryImage(bytes!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        errorWidget: (context, error) => _buildErrorWidget(context),
        placeholder: (context) => _buildPlaceholder(context: context),
      );
    } else {
      return CachedNetworkImage(
          imageUrl: widget.process.media.thumbnailLink!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => _buildErrorWidget(context),
          progressIndicatorBuilder: (context, url, progress) =>
              _buildPlaceholder(
                context: context,
                value: progress.progress,
              ));
    }
  }

  Widget _buildPlaceholder(
          {required BuildContext context,
          double? value,
          bool showLoader = true}) =>
      Container(
        color: context.colorScheme.containerHighOnSurface,
        alignment: Alignment.center,
        child: showLoader ? AppCircularProgressIndicator(value: value) : null,
      );

  Widget _buildErrorWidget(BuildContext context) => Container(
        color: context.colorScheme.containerNormalOnSurface,
        alignment: Alignment.center,
        child: Icon(
          CupertinoIcons.exclamationmark_circle,
          color: context.colorScheme.onPrimary,
          size: 32,
        ),
      );
}

class FutureByteLoader extends StatefulWidget {
  final Future<Uint8List?> bytes;
  final Widget Function(BuildContext context, Uint8List? bytes) builder;
  final Widget Function(BuildContext context) placeholder;
  final Widget Function(BuildContext context, Object? error) errorWidget;

  const FutureByteLoader(
      {super.key,
      required this.bytes,
      required this.builder,
      required this.placeholder,
      required this.errorWidget});

  @override
  State<FutureByteLoader> createState() => _FutureByteLoaderState();
}

class _FutureByteLoaderState extends State<FutureByteLoader> {
  late Future<Uint8List?> bytes;

  @override
  void initState() {
    bytes = widget.bytes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: bytes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return widget.builder(context, snapshot.data);
        } else if (snapshot.hasError) {
          return widget.errorWidget(context, snapshot.error);
        } else {
          return widget.placeholder(context);
        }
      },
    );
  }
}
