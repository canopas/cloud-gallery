import 'dart:io';
import 'package:cloud_gallery/ui/flow/media_preview/image_preview/components%20/network_image_preview/network_image_preview.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';
import '../../../../components/app_page.dart';

class ImagePreviewScreen extends StatelessWidget {
  final AppMedia media;
  final String heroTag;
  final bool showCloseBtn;

  const ImagePreviewScreen({
    super.key,
    required this.media,
    required this.heroTag,
    this.showCloseBtn = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '',
      leading: Visibility(
        visible: showCloseBtn,
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close_rounded,
            color: context.colorScheme.textSecondary,
          ),
        ),
      ),
      body: InteractiveViewer(
        maxScale: 100,
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: media.sources.contains(AppMediaSource.local)
                ? _displayLocalImage(context: context)
                : NetworkImagePreview(
                    media: media,
                    heroTag: heroTag,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _displayLocalImage({required BuildContext context}) {
    return Hero(
      tag: heroTag,
      child: Image.memory(
        File(media.path).readAsBytesSync(),
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
