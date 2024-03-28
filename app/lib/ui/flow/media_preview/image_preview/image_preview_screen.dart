import 'dart:io';
import 'dart:math';
import 'package:data/models/media/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/extensions/context_extensions.dart';
import '../../../../components/app_page.dart';
import '../../../../domain/extensions/widget_extensions.dart';
import 'components/network_image_preview/network_image_preview.dart';
import 'components/network_image_preview/network_image_preview_view_model.dart';

class ImagePreviewScreen extends ConsumerStatefulWidget {
  final AppMedia media;

  const ImagePreviewScreen({
    super.key,
    required this.media,
  });

  @override
  ConsumerState<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends ConsumerState<ImagePreviewScreen> {
  final _transformationController = TransformationController();
  double _translateY = 0;
  double _scale = 1;

  late NetworkImagePreviewStateNotifier notifier;

  @override
  void initState() {
    if (!widget.media.sources.contains(AppMediaSource.local)) {
      notifier = ref.read(networkImagePreviewStateNotifierProvider.notifier);
      runPostFrame(() {
        notifier.loadImage(widget.media.id);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        _translateY = 0;
        _scale = 1;
      },
      onVerticalDragUpdate: (details) {
        if (_transformationController.value.getMaxScaleOnAxis() > 1) {
          return;
        }

        setState(() {
          _translateY = max(0, _translateY + (details.primaryDelta ?? 0));
          _scale = 1 - (_translateY / 1000);
        });
      },
      onVerticalDragEnd: (details) {
        if (_transformationController.value.getMaxScaleOnAxis() > 1 ||
            _translateY == 0) {
          return;
        }

        final velocity = details.primaryVelocity ?? 0;
        if (velocity > 1000) {
          Navigator.of(context).pop();
        } else if (_translateY > 100) {
          Navigator.of(context).pop();
        } else {
          setState(() {
            _translateY = 0;
            _scale = 1;
          });
        }
      },
      child: AppPage(
        backgroundColor: _scale == 1
            ? context.colorScheme.surface
            : context.colorScheme.surface.withOpacity(_scale / 2),
        body: Stack(
          children: [
            Transform.translate(
              offset: Offset(0, _translateY),
              child: Transform.scale(
                scale: _scale,
                child: InteractiveViewer(
                  transformationController: _transformationController,
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
                ),
              ),
            ),
            if (_scale == 1)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AdaptiveAppBar(
                    iosTransitionBetweenRoutes: false,
                    text: widget.media.name ?? '',
                  ),
                ],
              ),
          ],
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
      ),
    );
  }
}
