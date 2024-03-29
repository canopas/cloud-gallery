import 'dart:typed_data';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import '../../../../../components/error_view.dart';
import 'network_image_preview_view_model.dart';

class NetworkImagePreview extends ConsumerWidget {
  final AppMedia media;

  const NetworkImagePreview({super.key, required this.media});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(networkImagePreviewStateNotifierProvider);

    if (state.loading) {
      return const Center(child: AppCircularProgressIndicator());
    } else if (state.mediaBytes != null) {
      return Hero(
        tag: media,
        child: Image.memory(Uint8List.fromList(state.mediaBytes!),
            fit: BoxFit.fitWidth),
      );
    } else if (state.error != null) {
      return ErrorView(
        title: context.l10n.unable_to_load_media_error,
        message: context.l10n.unable_to_load_media_message,
      );
    }
    return const Placeholder();
  }
}
