import 'package:cloud_gallery/components/snack_bar.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/ui/navigation/app_router.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';

class AppMediaView {
  static void showPreview(
      {required BuildContext context,
      required AppMedia media}) {
    if (media.type.isImage) {
      AppRouter.imagePreview(media: media).push(context);
    } else if (media.type.isVideo) {
      AppRouter.videoPreview(
              path: media.path,
              isLocal: media.sources.contains(AppMediaSource.local))
          .push(context);
    } else {
      showErrorSnackBar(context: context, error: context.l10n.unable_to_open_attachment_error);
    }
  }
}
