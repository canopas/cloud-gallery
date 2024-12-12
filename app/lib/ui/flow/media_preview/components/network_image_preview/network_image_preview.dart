import 'dart:io';
import '../../../../../components/place_holder_screen.dart';
import '../../../../../domain/extensions/context_extensions.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import '../../../../../components/app_page.dart';
import 'network_image_preview_view_model.dart';

class NetworkImagePreview extends ConsumerWidget {
  final AppMedia media;

  const NetworkImagePreview({super.key, required this.media});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(networkImagePreviewStateNotifierProvider);

    if (state.loading) {
      return Center(child: AppCircularProgressIndicator(value: state.progress));
    } else if (state.filePath != null) {
      return Hero(
        tag: media,
        child: Image.file(
          File(state.filePath!),
          fit: BoxFit.fitWidth,
          errorBuilder: (context, error, stackTrace) {
            return AppPage(
              body: PlaceHolderScreen(
                title: context.l10n.unable_to_load_media_error,
                message: context.l10n.unable_to_load_media_message,
              ),
            );
          },
        ),
      );
    }
    return PlaceHolderScreen(
      title: context.l10n.unable_to_load_media_error,
      message: context.l10n.unable_to_load_media_message,
    );
  }
}
