import 'dart:io';
import '../../../../components/app_page.dart';
import '../../../../components/error_view.dart';
import '../../../../domain/extensions/context_extensions.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/extensions/widget_extensions.dart';
import 'network_image_preview/network_image_preview.dart';
import 'network_image_preview/network_image_preview_view_model.dart';

class ImagePreview extends ConsumerStatefulWidget {
  final AppMedia media;

  const ImagePreview({
    super.key,
    required this.media,
  });

  @override
  ConsumerState<ImagePreview> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends ConsumerState<ImagePreview> {
  late NetworkImagePreviewStateNotifier notifier;

  @override
  void initState() {
    if (!widget.media.sources.contains(AppMediaSource.local)) {
      notifier = ref.read(networkImagePreviewStateNotifierProvider.notifier);
      runPostFrame(() async {
        await notifier.loadImageFromGoogleDrive(
          id: widget.media.id,
          extension: widget.media.extension,
        );
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 100,
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: widget.media.sources.contains(AppMediaSource.local)
              ? _displayLocalImage(context: context)
              : NetworkImagePreview(
                  media: widget.media,
                ),
        ),
      ),
    );
  }

  Widget _displayLocalImage({required BuildContext context}) {
    return Hero(
      tag: widget.media,
      child: Image.file(
        File(widget.media.path),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return AppPage(
            body: ErrorView(
              title: context.l10n.unable_to_load_media_error,
              message: context.l10n.unable_to_load_media_message,
            ),
          );
        },
      ),
    );
  }
}
