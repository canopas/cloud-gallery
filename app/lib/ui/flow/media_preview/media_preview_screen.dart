import 'package:cloud_gallery/components/app_page.dart';
import 'package:cloud_gallery/components/error_view.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/domain/extensions/widget_extensions.dart';
import 'package:cloud_gallery/domain/formatter/date_formatter.dart';
import 'package:cloud_gallery/ui/flow/media_preview/components/image_preview_screen.dart';
import 'package:cloud_gallery/ui/flow/media_preview/media_preview_view_model.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'components/video_preview_screen.dart';

class MediaPreview extends ConsumerStatefulWidget {
  final List<AppMedia> medias;
  final String startingMediaId;

  const MediaPreview(
      {super.key, required this.medias, required this.startingMediaId});

  @override
  ConsumerState<MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends ConsumerState<MediaPreview> {
  late AutoDisposeStateNotifierProvider<MediaPreviewStateNotifier,
      MediaPreviewState> _provider;
  late PageController _pageController;
  late MediaPreviewStateNotifier notifier;

  @override
  void initState() {
    final currentIndex = widget.medias
        .indexWhere((element) => element.id == widget.startingMediaId);
    _provider = mediaPreviewStateNotifierProvider(
        MediaPreviewState(currentIndex: currentIndex));
    _pageController = PageController(initialPage: currentIndex);
    notifier = ref.read(_provider.notifier);
    runPostFrame(() => notifier.changeVisibleMediaIndex(currentIndex));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return AppPage(
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: notifier.toggleManu,
            child: PageView.builder(
              onPageChanged: notifier.changeVisibleMediaIndex,
              controller: _pageController,
              itemCount: widget.medias.length,
              itemBuilder: (context, index) =>
                  _preview(context: context, index: index),
            ),
          ),
          _manu(context: context),
        ],
      ),
    );
  }

  Widget _preview({required BuildContext context, required int index}) {
    final media = widget.medias[index];
    if (media.type.isVideo) {
      return VideoPreview(media: media);
    } else if (media.type.isImage) {
      return ImagePreview(media: media);
    } else {
      return ErrorView(
        title: context.l10n.unable_to_load_media_error,
        message: context.l10n.unable_to_load_media_message,
      );
    }
  }

  Widget _manu({required BuildContext context}) => Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(_provider);
          return AnimatedCrossFade(
            crossFadeState: state.showManu
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: AdaptiveAppBar(
              text: widget.medias[state.currentIndex].createdTime
                      ?.format(context, DateFormatType.relative) ??
                  '',
              actions: [
                ActionButton(
                  onPressed: () {
                    ///TODO: media details
                  },
                  icon: Icon(
                    CupertinoIcons.info,
                    color: context.colorScheme.textSecondary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                ActionButton(
                  onPressed: () {
                    ///TODO: delete media feature
                  },
                  icon: Icon(
                    CupertinoIcons.delete,
                    color: context.colorScheme.textSecondary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            secondChild: const SizedBox(
              width: double.infinity,
            ),
            firstCurve: Curves.easeInOut,
            secondCurve: Curves.easeInOut,
            duration: const Duration(milliseconds: 200),
            reverseDuration: const Duration(milliseconds: 200),
          );
        },
      );
}
