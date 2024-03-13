import 'package:cloud_gallery/components/snack_bar.dart';
import 'package:cloud_gallery/ui/navigation/app_router.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';

class AppMediaView {
  static void showPreview(
      {required BuildContext context,
      required AppMedia media,
      required String heroTag}) {
    if (media.type.isImage) {
      AppRouter.imagePreview(
              path: media.path,
              heroTag: heroTag,
              isLocal: media.sources.contains(AppMediaSource.local))
          .push(context);
    } else if (media.type.isVideo) {
      AppRouter.videoPreview(
              path: media.path,
              heroTag: heroTag,
              isLocal: media.sources.contains(AppMediaSource.local))
          .push(context);
    } else {
      showErrorSnackBar(context: context, error: 'Unable to open attachment');
    }
  }
}
