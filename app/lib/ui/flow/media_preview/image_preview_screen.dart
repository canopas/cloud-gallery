import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import '../../../components/app_page.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String url;
  final bool isLocal;
  final String heroTag;
  final bool showCloseBtn;

  const ImagePreviewScreen({
    super.key,
    required this.url,
    required this.isLocal,
    required this.heroTag,
    this.showCloseBtn = true,
  });

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '',
      leading: Visibility(
        visible: widget.showCloseBtn,
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close_rounded,
            color: context.colorScheme.textSecondary,
          ),
        ),
      ),
      body: InteractiveViewer(
        child: Center(
          child: Hero(
            tag: widget.heroTag,
            child: SizedBox(
              width: double.infinity,
              child: Visibility(
                visible: !widget.isLocal,
                replacement: Image.file(File.fromUri(Uri.parse(widget.url)),
                    fit: BoxFit.fitWidth),
                child: CachedNetworkImage(
                  imageUrl: widget.url,
                  fit: BoxFit.fitWidth,
                  progressIndicatorBuilder: (context, child, loadingProgress) =>
                      const AppCircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
