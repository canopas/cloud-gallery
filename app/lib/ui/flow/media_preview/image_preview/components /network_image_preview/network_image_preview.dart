import 'dart:typed_data';
import 'package:cloud_gallery/ui/flow/media_preview/image_preview/components%20/network_image_preview/network_image_preview_view_model.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/indicators/circular_progress_indicator.dart';

import '../../../../../../domain/extensions/widget_extensions.dart';

class NetworkImagePreview extends ConsumerStatefulWidget {
  final AppMedia media;
  final String heroTag;

  const NetworkImagePreview(
      {super.key, required this.media, required this.heroTag});

  @override
  ConsumerState<NetworkImagePreview> createState() =>
      _NetworkImagePreviewState();
}

class _NetworkImagePreviewState extends ConsumerState<NetworkImagePreview> {
  late NetworkImagePreviewStateNotifier notifier;

  @override
  void initState() {
    notifier = ref.read(networkImagePreviewStateNotifierProvider.notifier);
    runPostFrame(() {
      notifier.loadImage(widget.media.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(networkImagePreviewStateNotifierProvider);

    if (state.loading) {
      return const Center(child: AppCircularProgressIndicator());
    } else if (state.mediaBytes != null) {
      return Hero(
        tag: widget.heroTag,
        child: Image.memory(Uint8List.fromList(state.mediaBytes!),
            fit: BoxFit.fitWidth),
      );
    } else if (state.error != null) {
      return const Center(child: Text('Error'));
    }
    return const Placeholder();
  }
}
