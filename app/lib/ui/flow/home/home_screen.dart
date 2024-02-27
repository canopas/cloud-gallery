import 'package:cloud_gallery/components/app_page.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/ui/flow/home/components/screen_source_segment_control.dart';
import 'package:cloud_gallery/ui/flow/home/home_screen_view_model.dart';
import 'package:cloud_gallery/ui/flow/home/local/local_medias_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/assets/assets_paths.dart';
import 'google_drive/google_drive_medias_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late HomeViewStateNotifier notifier;
  final _pageController = PageController();

  @override
  void initState() {
    notifier = ref.read(homeViewStateNotifier.notifier);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updatePageOnChangeSource() {
    ref.listen(homeViewStateNotifier.select((value) => value.sourcePage),
        (previous, next) {
      if (!next.viewChangedByScroll) {
        _pageController.jumpToPage(next.sourcePage.index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _updatePageOnChangeSource();
    return AppPage(
      titleWidget: _titleWidget(context: context),
      body: Column(
        children: [
          const ScreenSourceSegmentControl(),
          Expanded(
            child: PageView(
              onPageChanged: (value) {
                notifier.updateMediaSource(
                    isChangedByScroll: true, source: MediaSource.values[value]);
              },
              controller: _pageController,
              children: const [
                LocalMediasScreen(),
                GoogleDriveMediasScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleWidget({required BuildContext context}) => Row(
        children: [
          const SizedBox(width: 16),
          Image.asset(
            Assets.images.appIcon,
            width: 28,
          ),
          const SizedBox(width: 10),
          Text(context.l10n.app_name)
        ],
      );
}
