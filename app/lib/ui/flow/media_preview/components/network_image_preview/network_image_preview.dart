import 'dart:io';
import 'package:style/extensions/context_extensions.dart';
import '../../../../../components/place_holder_screen.dart';
import '../../../../../domain/extensions/context_extensions.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../components/app_page.dart';
import '../../../../../domain/image_providers/app_media_image_provider.dart';
import 'network_image_preview_view_model.dart';

class NetworkImagePreview extends ConsumerStatefulWidget {
  final AppMedia media;
  final String heroTag;

  const NetworkImagePreview({
    super.key,
    required this.media,
    required this.heroTag,
  });

  @override
  ConsumerState<NetworkImagePreview> createState() =>
      _NetworkImagePreviewState();
}

class _NetworkImagePreviewState extends ConsumerState<NetworkImagePreview> {
  late AutoDisposeStateNotifierProvider<NetworkImagePreviewStateNotifier,
      NetworkImagePreviewState> _provider;

  @override
  void initState() {
    if (!widget.media.sources.contains(AppMediaSource.local)) {
      _provider = networkImagePreviewStateNotifierProvider(widget.media);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final width = context.mediaQuerySize.width;
    double multiplier = 1;
    if (widget.media.displayWidth != null && widget.media.displayWidth! > 0) {
      multiplier = width / widget.media.displayWidth!;
    }
    final height =
        widget.media.displayHeight != null && widget.media.displayHeight! > 0
            ? widget.media.displayHeight! * multiplier
            : width;

    return Center(
      child: Hero(
        tag: "${widget.heroTag}${widget.media.toString()}",
        child: Image(
          image: state.filePath != null
              ? FileImage(File(state.filePath!)) as ImageProvider
              : AppMediaImageProvider(media: widget.media),
          fit: BoxFit.contain,
          width: width,
          height: height,
          gaplessPlayback: true,
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
              return SizedBox(width: width, height: height, child: child);
            }
          },
        ),
      ),
    );
  }
}
