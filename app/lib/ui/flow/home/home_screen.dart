import 'package:cloud_gallery/components/app_page.dart';
import 'package:cloud_gallery/components/resume_detector.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/ui/flow/home/components/no_local_medias_access_screen.dart';
import 'package:cloud_gallery/ui/flow/home/home_screen_view_model.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:style/text/app_text_style.dart';
import '../../../components/snack_bar.dart';
import '../../../domain/assets/assets_paths.dart';
import '../../navigation/app_router.dart';
import 'components/app_media_item.dart';
import 'components/multi_selection_done_button.dart';
import 'package:style/slivers/sticky_header_delegate.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late HomeViewStateNotifier notifier;
  final _scrollController = ScrollController();

  @override
  void initState() {
    notifier = ref.read(homeViewStateNotifier.notifier);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _errorObserver() {
    ref.listen(homeViewStateNotifier.select((value) => value.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context: context, error: next);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _errorObserver();

    return AppPage(
      titleWidget: _titleWidget(context: context),
      actions: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: context.colorScheme.containerNormalOnSurface,
            minimumSize: const Size(28, 28),
          ),
          onPressed: () {
            AppRouter.accounts.push(context);
          },
          icon: Icon(
            CupertinoIcons.person,
            color: context.colorScheme.textSecondary,
            size: 18,
          ),
        ),
      ],
      body: _body(context: context),
    );
  }

  Widget _body({required BuildContext context}) {
    //States
    final medias =
        ref.watch(homeViewStateNotifier.select((state) => state.medias));
    final isLoading =
        ref.watch(homeViewStateNotifier.select((state) => state.loading));

    final selectedMedias = ref
        .watch(homeViewStateNotifier.select((state) => state.selectedMedias));

    final uploadingMedias = ref
        .watch(homeViewStateNotifier.select((state) => state.uploadingMedias));

    final hasLocalMediaAccess = ref.watch(
        homeViewStateNotifier.select((state) => state.hasLocalMediaAccess));

    //View
    if (isLoading) {
      return const Center(child: AppCircularProgressIndicator());
    } else if (medias.isEmpty && !hasLocalMediaAccess) {
      return const NoLocalMediasAccessScreen();
    }
    return ResumeDetector(
      onResume: notifier.loadMedias,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          _buildMediaList(
            context: context,
            medias: medias,
            uploadingMedias: uploadingMedias,
            selectedMedias: selectedMedias,
          ),
          if (selectedMedias.isNotEmpty)
            Padding(
              padding: context.systemPadding + const EdgeInsets.all(16),
              child: const MultiSelectionDoneButton(),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaList(
      {required BuildContext context,
      required Map<DateTime, List<AppMedia>> medias,
      required List<String> uploadingMedias,
      required List<AppMedia> selectedMedias}) {
    return Scrollbar(
      controller: _scrollController,
      interactive: true,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: medias.entries
            .map(
              (e) => SliverMainAxisGroup(
                slivers: [
                  SliverPersistentHeader(
                    delegate: SliverStickyHeaderDelegate(
                      header: Container(
                        padding: const EdgeInsets.only(left: 16),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surface,
                        ),
                        child: Text(
                          DateFormat("d MMMM, y").format(e.key),
                          style: AppTextStyles.subtitle1.copyWith(
                            color: context.colorScheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    pinned: true,
                  ),
                  SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    sliver: SliverGrid.builder(
                      itemBuilder: (context, index) {
                        final media = e.value[index];
                        return AppMediaItem(
                          key: ValueKey(media.id),
                          onTap: () {
                            if (selectedMedias.isNotEmpty) {
                              notifier.toggleMediaSelection(media);
                            }
                          },
                          onLongTap: () {
                            notifier.toggleMediaSelection(media);
                          },
                          isSelected: selectedMedias.contains(media),
                          isUploading: uploadingMedias.contains(media.id),
                          media: media,
                        );
                      },
                      itemCount: e.value.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _titleWidget({required BuildContext context}) {
    return Row(
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
}
