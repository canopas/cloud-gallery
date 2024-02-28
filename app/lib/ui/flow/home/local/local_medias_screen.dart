import 'dart:io';
import 'package:cloud_gallery/ui/flow/home/local/components/multi_selection_done_button.dart';
import 'package:cloud_gallery/ui/flow/home/local/components/no_local_medias_access_screen.dart';
import 'package:cloud_gallery/ui/flow/home/local/local_media_screen_view_model.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/extensions/context_extensions.dart';
import '../../../../components/snack_bar.dart';
import '../../../../domain/extensions/widget_extensions.dart';
import '../components/image_item.dart';

class LocalMediasScreen extends ConsumerStatefulWidget {
  const LocalMediasScreen({super.key});

  @override
  ConsumerState createState() => _LocalSourceViewState();
}

class _LocalSourceViewState extends ConsumerState<LocalMediasScreen> {
  late LocalMediasViewStateNotifier notifier;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    notifier = ref.read(localMediasViewStateNotifier.notifier);
    runPostFrame(() async {
      await notifier.loadMediaCount();
      await notifier.loadMedia();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _observeError() {
    ref.listen(localMediasViewStateNotifier.select((value) => value.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context: context, error: next);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //Listeners
    _observeError();

    //States
    final medias =
        ref.watch(localMediasViewStateNotifier.select((state) => state.medias));

    final selectedMedia = ref.watch(
        localMediasViewStateNotifier.select((state) => state.selectedMedias));

    final isLoading = ref
        .watch(localMediasViewStateNotifier.select((state) => state.loading));

    final mediaCounts = ref.watch(
        localMediasViewStateNotifier.select((state) => state.mediaCount));

    final hasAccess = ref.watch(localMediasViewStateNotifier
        .select((state) => state.hasLocalMediaAccess));

    //View
    if (!hasAccess) {
      return const NoLocalMediasAccessScreen();
    } else if (isLoading && medias.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Scrollbar(
          controller: _scrollController,
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: mediaCounts,
            itemBuilder: (context, index) {
              if (index > medias.length - 6) {
                runPostFrame(() {
                  notifier.loadMedia(append: true);
                });
              }
              if (index < medias.length) {
                if (medias[index].type != AppMediaType.image) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: context.colorScheme.outline,
                    ),
                  );
                }
                return ImageItem(
                  onTap: () {
                    if (selectedMedia.isNotEmpty) {
                      HapticFeedback.vibrate();
                      notifier.mediaSelection(medias[index]);
                    }
                  },
                  onLongTap: () {
                    HapticFeedback.vibrate();
                    notifier.mediaSelection(medias[index]);
                  },
                  isSelected: selectedMedia.contains(medias[index]),
                  imageProvider: FileImage(File(medias[index].path)),
                );
              } else {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: context.colorScheme.primary,
                  ),
                );
              }
            },
          ),
        ),
        if (selectedMedia.isNotEmpty)
          Padding(
            padding: context.systemPadding + const EdgeInsets.all(16),
            child: const MultiSelectionDoneButton(),
          ),
      ],
    );
  }
}
