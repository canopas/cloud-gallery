import 'dart:io';
import 'package:flutter/services.dart';
import 'package:style/buttons/primary_button.dart';
import '../../../components/app_page.dart';
import '../../../components/error_screen.dart';
import '../../../domain/extensions/widget_extensions.dart';
import '../../../domain/formatter/date_formatter.dart';
import '../../../domain/extensions/context_extensions.dart';
import '../../../gen/assets.gen.dart';
import 'components/no_internet_connection_hint.dart';
import 'components/no_local_medias_access_screen.dart';
import 'components/sign_in_hint.dart';
import 'home_screen_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:style/text/app_text_style.dart';
import '../../../components/snack_bar.dart';
import '../../navigation/app_route.dart';
import 'components/app_media_item.dart';
import 'components/multi_selection_done_button.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/animations/fade_in_switcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late HomeViewStateNotifier _notifier;
  final _scrollController = ScrollController();

  @override
  void initState() {
    _notifier = ref.read(homeViewStateNotifier.notifier);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _errorObserver() {
    ref.listen(
      homeViewStateNotifier.select((value) => value.actionError),
      (previous, next) {
        if (next != null) {
          showErrorSnackBar(context: context, error: next);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _errorObserver();
    return AppPage(
      titleWidget: const HomeAppTitle(),
      actions: const [
        HomeTransferButton(),
        SizedBox(width: 8),
        HomeAccountButton(),
      ],
      body: FadeInSwitcher(child: _body(context: context)),
    );
  }

  Widget _body({required BuildContext context}) {
    final state = ref.watch(
      homeViewStateNotifier.select(
        (value) => (
          hasMedia: value.medias.isNotEmpty,
          hasSelectedMedia: value.selectedMedias.isNotEmpty,
          isLoading: value.loading,
          hasLocalMediaAccess: value.hasLocalMediaAccess,
          error: value.error,
        ),
      ),
    );

    if (state.isLoading && !state.hasMedia) {
      return const Center(child: AppCircularProgressIndicator());
    } else if (!state.hasMedia && !state.hasLocalMediaAccess) {
      return const NoLocalMediasAccessScreen();
    } else if (state.error != null && !state.hasMedia) {
      return ErrorScreen(
        error: state.error!,
        onRetryTap: () => _notifier.loadMedias(reload: true),
      );
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        _buildMediaList(context: context),
        if (state.hasSelectedMedia)
          Padding(
            padding: context.systemPadding + const EdgeInsets.all(16),
            child: const MultiSelectionDoneButton(),
          ),
      ],
    );
  }

  Widget _buildMediaList({required BuildContext context}) {
    final state = ref.watch(
      homeViewStateNotifier.select(
        (value) => (
          medias: value.medias,
          uploadMediaProcesses: value.uploadMediaProcesses,
          downloadMediaProcesses: value.downloadMediaProcesses,
          loading: value.loading,
          selectedMedias: value.selectedMedias,
          lastLocalMediaId: value.lastLocalMediaId,
        ),
      ),
    );

    return Scrollbar(
      controller: _scrollController,
      interactive: true,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.medias.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                const HomeScreenHints(),
                const NoInternetConnectionHint(),
                PrimaryButton(
                  onPressed: () {
                    AlbumsRoute().push(context);
                  },
                  text: "Albums",
                ),
              ],
            );
          } else if (index == state.medias.length + 1) {
            return FadeInSwitcher(
              child: state.loading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: AppCircularProgressIndicator(
                          size: 20,
                        ),
                      ),
                    )
                  : const SizedBox(),
            );
          } else {
            final gridEntry = state.medias.entries.elementAt(index - 1);
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
                  itemCount: gridEntry.value.entries.length,
                  itemBuilder: (context, index) {
                    final media =
                        gridEntry.value.entries.elementAt(index).value;

                    if (media.id == state.lastLocalMediaId) {
                      runPostFrame(() {
                        _notifier.loadMedias();
                      });
                    }

                    return AppMediaItem(
                      key: ValueKey(media.id),
                      onTap: () async {
                        if (state.selectedMedias.isNotEmpty) {
                          _notifier.toggleMediaSelection(media);
                          HapticFeedback.lightImpact();
                        } else {
                          await MediaPreviewRoute(
                            $extra: MediaPreviewRouteData(
                              medias: state.medias.values
                                  .expand((element) => element.values)
                                  .toList(),
                              startFrom: media.id,
                            ),
                          ).push(context);
                        }
                      },
                      onLongTap: () {
                        _notifier.toggleMediaSelection(media);
                        HapticFeedback.lightImpact();
                      },
                      isSelected: state.selectedMedias.containsKey(media.id),
                      uploadMediaProcess: state.uploadMediaProcesses[media.id],
                      downloadMediaProcess:
                          state.downloadMediaProcesses[media.id],
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
}

class HomeAppTitle extends StatelessWidget {
  const HomeAppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (Platform.isIOS) const SizedBox(width: 10),
        Image.asset(
          Assets.images.appLogo.path,
          width: 28,
        ),
        const SizedBox(width: 10),
        Text(
          context.l10n.app_name,
          style: AppTextStyles.header3.copyWith(
            color: context.colorScheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class HomeAccountButton extends StatelessWidget {
  const HomeAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      size: 36,
      backgroundColor: context.colorScheme.containerNormal,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () async {
        await AccountRoute().push(context);
      },
      icon: Icon(
        CupertinoIcons.person,
        color: context.colorScheme.textSecondary,
        size: 18,
      ),
    );
  }
}

class HomeTransferButton extends StatelessWidget {
  const HomeTransferButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      size: 36,
      backgroundColor: context.colorScheme.containerNormal,
      onPressed: () async {
        await TransferRoute().push(context);
      },
      icon: Icon(
        CupertinoIcons.arrow_up_arrow_down,
        color: context.colorScheme.textSecondary,
        size: 18,
      ),
    );
  }
}
