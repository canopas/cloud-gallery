import 'package:data/models/album/album.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style/animations/fade_in_switcher.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import '../../../../components/action_sheet.dart';
import '../../../../components/app_media_thumbnail.dart';
import '../../../../components/app_page.dart';
import '../../../../components/app_sheet.dart';
import '../../../../components/error_screen.dart';
import '../../../../components/place_holder_screen.dart';
import '../../../../components/selection_menu.dart';
import '../../../../domain/extensions/context_extensions.dart';
import '../../../../domain/extensions/widget_extensions.dart';
import '../../../../gen/assets.gen.dart';
import '../../../navigation/app_route.dart';
import 'album_media_list_state_notifier.dart';

class AlbumMediaListScreen extends ConsumerStatefulWidget {
  final Album album;

  const AlbumMediaListScreen({super.key, required this.album});

  @override
  ConsumerState<AlbumMediaListScreen> createState() =>
      _AlbumMediaListScreenState();
}

class _AlbumMediaListScreenState extends ConsumerState<AlbumMediaListScreen> {
  late AutoDisposeStateNotifierProvider<AlbumMediaListStateNotifier,
      AlbumMediaListState> _provider;
  late AlbumMediaListStateNotifier _notifier;

  @override
  void initState() {
    _provider = albumMediaListStateNotifierProvider(widget.album);
    _notifier = ref.read(_provider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    return AppPage(
      title: state.album.name,
      actions: [
        ActionButton(
          onPressed: () async {
            showAppSheet(
              context: context,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSheetAction(
                    title: context.l10n.add_items_action_title,
                    onPressed: () async {
                      context.pop();
                      final res =
                          await MediaSelectionRoute($extra: widget.album.source)
                              .push(context);
                      if (res != null && res is List<String>) {
                        await _notifier.addMediaInAlbum(medias: res);
                      }
                    },
                    icon: Icon(
                      Icons.add,
                      size: 24,
                      color: context.colorScheme.textPrimary,
                    ),
                  ),
                  AppSheetAction(
                    title: context.l10n.edit_album_action_title,
                    onPressed: () async {
                      context.pop();
                      final res = await AddAlbumRoute($extra: state.album)
                          .push(context);
                      if (res == true) {
                        _notifier.loadAlbum();
                      }
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 24,
                      color: context.colorScheme.textPrimary,
                    ),
                  ),
                  AppSheetAction(
                    title: context.l10n.delete_album_action_title,
                    onPressed: () async {
                      context.pop();
                      _notifier.deleteAlbum();
                    },
                    icon: Icon(
                      CupertinoIcons.delete,
                      size: 24,
                      color: context.colorScheme.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          },
          icon: Icon(
            Icons.more_vert_rounded,
            color: context.colorScheme.textPrimary,
            size: 24,
          ),
        ),
      ],
      body: FadeInSwitcher(child: _body(context: context, state: state)),
    );
  }

  Widget _body({
    required BuildContext context,
    required AlbumMediaListState state,
  }) {
    if (state.loading) {
      return const Center(child: AppCircularProgressIndicator());
    } else if (state.error != null) {
      return ErrorScreen(
        error: state.error!,
        onRetryTap: () => _notifier.loadMedia(reload: true),
      );
    } else if (state.medias.isEmpty && state.addingMedia.isEmpty) {
      return PlaceHolderScreen(
        icon: SvgPicture.asset(
          Assets.images.ilNoMediaFound,
          width: 150,
        ),
        title: context.l10n.empty_album_media_list_title,
        message: context.l10n.empty_album_media_list_message,
      );
    }
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.mediaQuerySize.width > 600
                      ? context.mediaQuerySize.width ~/ 180
                      : context.mediaQuerySize.width ~/ 100,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: (state.medias.length + state.addingMedia.length),
                itemBuilder: (context, index) {
                  if (index >=
                      (state.medias.length + state.addingMedia.length) - 1) {
                    runPostFrame(() {
                      _notifier.loadMedia();
                    });
                  }
                  if (index < state.medias.length) {
                    return Opacity(
                      opacity: state.removingMedia.contains(
                        state.medias.keys.elementAt(index),
                      )
                          ? 0.7
                          : 1,
                      child: AppMediaThumbnail(
                        selected: state.selectedMedias
                            .contains(state.medias.keys.elementAt(index)),
                        onTap: () async {
                          if (state.selectedMedias.isNotEmpty) {
                            _notifier.toggleMediaSelection(
                              state.medias.keys.elementAt(index),
                            );
                            return;
                          }
                          await MediaPreviewRoute(
                            $extra: MediaPreviewRouteData(
                              onLoadMore: _notifier.loadMedia,
                              heroTag: "album_media_list",
                              medias: state.medias.values.toList(),
                              startFrom:
                                  state.medias.values.elementAt(index).id,
                            ),
                          ).push(context);
                          _notifier.loadMedia(reload: true);
                        },
                        onLongTap: () {
                          _notifier.toggleMediaSelection(
                            state.medias.keys.elementAt(index),
                          );
                        },
                        heroTag:
                            "album_media_list${state.medias.values.elementAt(index).toString()}",
                        media: state.medias.values.elementAt(index),
                      ),
                    );
                  }

                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: context.colorScheme.containerNormalOnSurface,
                    child: const Center(
                      child: AppCircularProgressIndicator(
                        size: 22,
                      ),
                    ),
                  );
                },
              ),
              if (state.loadingMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: AppCircularProgressIndicator(
                      size: 22,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SelectionMenu(
          items: [
            SelectionMenuAction(
              title: context.l10n.common_cancel,
              icon: Icon(
                Icons.close,
                color: context.colorScheme.textPrimary,
                size: 24,
              ),
              onTap: _notifier.clearSelection,
            ),
            SelectionMenuAction(
              title: context.l10n.remove_item_action_title,
              icon: Icon(
                CupertinoIcons.delete,
                color: context.colorScheme.textPrimary,
                size: 24,
              ),
              onTap: _notifier.removeMediaFromAlbum,
            ),
          ],
          show: state.selectedMedias.isNotEmpty,
        ),
      ],
    );
  }
}
