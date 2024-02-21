import 'dart:io';
import 'package:cloud_gallery/components/app_page.dart';
import 'package:cloud_gallery/components/app_sheet.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/domain/extensions/widget_extensions.dart';
import 'package:cloud_gallery/ui/flow/home/home_screen_view_model.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/text/app_text_style.dart';
import '../../../components/action_sheet.dart';
import '../../../domain/assets/assets_paths.dart';
import 'components/image_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late HomeViewStateNotifier notifier;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    notifier = ref.read(homeViewStateNotifier.notifier);
    runPostFrame(() async {
      await notifier.loadMediaCount();
      await notifier.loadMedia();
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medias = ref.watch(
      homeViewStateNotifier.select((state) => state.medias),
    );

    final selectedMedia = ref.watch(
      homeViewStateNotifier.select((state) => state.selectedMedias),
    );

    final isLoading = ref.watch(
      homeViewStateNotifier.select((state) => state.loading),
    );

    final mediaCounts = ref.watch(
      homeViewStateNotifier.select((state) => state.mediaCount),
    );

    return AppPage(
      title: context.l10n.app_name,
      actions: [
        if (selectedMedia.isNotEmpty)
          TextButton(
              onPressed: () {
                showAppSheet(
                    context: context,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppSheetAction(
                          icon: SvgPicture.asset(
                            Assets.images.icons.googlePhotos,
                            height: 24,
                            width: 24,
                          ),
                          title: context.l10n.back_up_on_google_drive_text,
                          onPressed: () {

                          },
                        ),
                      ],
                    ));
              },
              child: Text(context.l10n.common_done,
                  style: AppTextStyles.button.copyWith(
                    color: context.colorScheme.primary,
                  )))
      ],
      body: Visibility(
        visible: !isLoading,
        replacement: const Center(child: CircularProgressIndicator()),
        child: Scrollbar(
          controller: _controller,
          child: GridView.builder(
            controller: _controller,
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
                      notifier.mediaSelection(medias[index]);
                    }
                  },
                  onLongTap: () {
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
      ),
    );
  }
}
