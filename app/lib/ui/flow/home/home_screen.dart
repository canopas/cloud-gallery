import 'dart:io';
import 'package:cloud_gallery/components/app_page.dart';
import 'package:cloud_gallery/domain/extensions/widget_extensions.dart';
import 'package:cloud_gallery/domain/formatter/date_formatter.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/ui/flow/home/components/no_local_medias_access_screen.dart';
import 'package:cloud_gallery/ui/flow/home/home_screen_view_model.dart';
import 'package:collection/collection.dart';
import 'package:data/models/app_process/app_process.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:style/text/app_text_style.dart';
import '../../../components/snack_bar.dart';
import '../../../domain/assets/assets_paths.dart';
import '../../navigation/app_router.dart';
import 'components/app_media_item.dart';
import 'components/hints.dart';
import 'components/multi_selection_done_button.dart';
import 'package:style/buttons/action_button.dart';

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
        ActionButton(
          size: 36,
          backgroundColor: context.colorScheme.containerNormal,
          onPressed: () {
            AppRouter.accounts.push(context);
          },
          icon: Icon(
            CupertinoIcons.person,
            color: context.colorScheme.textSecondary,
            size: 18,
          ),
        ),
        if (!Platform.isIOS && !Platform.isMacOS) const SizedBox(width: 16),
      ],
      body: _body(context: context),
    );
  }

  Widget _body({required BuildContext context}) {
    //View State
    final ({
      Map<DateTime, List<AppMedia>> medias,
      List<AppProcess> mediaProcesses,
      List<AppMedia> selectedMedias,
      bool isLoading,
      bool hasLocalMediaAccess,
      String? lastLocalMediaId
    }) state = ref.watch(homeViewStateNotifier.select((value) => (
          medias: value.medias,
          mediaProcesses: value.mediaProcesses,
          selectedMedias: value.selectedMedias,
          isLoading: value.loading,
          hasLocalMediaAccess: value.hasLocalMediaAccess,
          lastLocalMediaId: value.lastLocalMediaId,
        )));

    //View
    if (state.isLoading) {
      return const Center(child: AppCircularProgressIndicator());
    } else if (state.medias.isEmpty && !state.hasLocalMediaAccess) {
      return const NoLocalMediasAccessScreen();
    }
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        _buildMediaList(
          context: context,
          medias: state.medias,
          mediaProcesses: state.mediaProcesses,
          selectedMedias: state.selectedMedias,
          lastLocalMediaId: state.lastLocalMediaId,
        ),
        if (state.selectedMedias.isNotEmpty)
          Padding(
            padding: context.systemPadding + const EdgeInsets.all(16),
            child: const MultiSelectionDoneButton(),
          ),
      ],
    );
  }

  Widget _buildMediaList(
      {required BuildContext context,
      required Map<DateTime, List<AppMedia>> medias,
      required List<AppProcess> mediaProcesses,
      required String? lastLocalMediaId,
      required List<AppMedia> selectedMedias}) {
    return Scrollbar(
      controller: _scrollController,
      interactive: true,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: medias.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const HomeScreenHints();
          } else {
            final gridEntry = medias.entries.elementAt(index - 1);
            return Column(
              children: [
                Container(
                  height: 45,
                  padding: const EdgeInsets.only(left: 16, top: 5),
                  margin: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                  ),
                  child: Text(
                    gridEntry.key.format(context, DateFormatType.relative),
                    style: AppTextStyles.subtitle1.copyWith(
                      color: context.colorScheme.textPrimary,
                    ),
                  ),
                ),
                GridView.builder(
                  padding: const EdgeInsets.all(4),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.mediaQuerySize.width > 600
                        ? context.mediaQuerySize.width ~/ 180
                        : context.mediaQuerySize.width ~/ 100,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: gridEntry.value.length,
                  itemBuilder: (context, index) {
                    final media = gridEntry.value[index];
                    if (media.id == lastLocalMediaId) {
                      runPostFrame(() {
                        notifier.loadLocalMedia(append: true);
                      });
                    }
                    return AppMediaItem(
                      key: ValueKey(media.id),
                      onTap: () {
                        if (selectedMedias.isNotEmpty) {
                          notifier.toggleMediaSelection(media);
                        } else {
                          AppRouter.preview(
                                  medias: medias.values
                                      .expand((element) => element)
                                      .toList(),
                                  startFrom: media.id)
                              .push(context);
                        }
                      },
                      onLongTap: () {
                        notifier.toggleMediaSelection(media);
                      },
                      isSelected: selectedMedias.contains(media),
                      process: mediaProcesses.firstWhereOrNull(
                          (process) => process.id == media.id),
                      media: media,
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _titleWidget({required BuildContext context}) {
    return Row(
      children: [
        if (Platform.isIOS) const SizedBox(width: 10),
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
