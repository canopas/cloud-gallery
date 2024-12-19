import 'dart:io';
import 'package:data/models/media/media_extension.dart';
import 'package:style/extensions/context_extensions.dart';
import '../../../../../components/place_holder_screen.dart';
import '../../../../../domain/extensions/context_extensions.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../components/app_page.dart';
import '../../../../../domain/extensions/widget_extensions.dart';
import '../../../../../domain/image_providers/app_media_image_provider.dart';
import 'network_image_preview_view_model.dart';

class NetworkImagePreview extends ConsumerStatefulWidget {
  final AppMedia media;

  const NetworkImagePreview({super.key, required this.media});

  @override
  ConsumerState<NetworkImagePreview> createState() =>
      _NetworkImagePreviewState();
}

class _NetworkImagePreviewState extends ConsumerState<NetworkImagePreview> {
  late NetworkImagePreviewStateNotifier notifier;

  @override
  void initState() {
    if (!widget.media.sources.contains(AppMediaSource.local)) {
      notifier = ref.read(networkImagePreviewStateNotifierProvider.notifier);
      runPostFrame(() async {
        if (widget.media.driveMediaRefId != null) {
          await notifier.loadImageFromGoogleDrive(
            id: widget.media.driveMediaRefId!,
            extension: widget.media.extension,
          );
        } else if (widget.media.dropboxMediaRefId != null) {
          await notifier.loadImageFromDropbox(
            id: widget.media.dropboxMediaRefId!,
            extension: widget.media.extension,
          );
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(networkImagePreviewStateNotifierProvider);
    return InteractiveViewer(
      maxScale: 100,
      child: Center(
        child: Hero(
          createRectTween: (begin, end) {
            return RectTween(begin: begin, end: end);
          },
          tag: widget.media,
          child: Image(
            image: state.filePath != null
                ? FileImage(File(state.filePath!)) as ImageProvider
                : AppMediaImageProvider(media: widget.media),
            fit: BoxFit.contain,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return AppPage(
                body: PlaceHolderScreen(
                  title: context.l10n.unable_to_load_media_error,
                  message: context.l10n.unable_to_load_media_message,
                ),
              );
            },
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              } else {
                final width = context.mediaQuerySize.width;
                double multiplier = 1;
                if (widget.media.displayWidth != null && widget.media.displayWidth! > 0) {
                  multiplier = width / widget.media.displayWidth!;
                }
                return SizedBox(
                  width: width,
                  height:
                  widget.media.displayHeight != null && widget.media.displayHeight! > 0
                          ? widget.media.displayHeight! * multiplier
                          : width,
                  child: child,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
