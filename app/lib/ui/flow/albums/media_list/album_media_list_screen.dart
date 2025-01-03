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
import '../../../../domain/extensions/context_extensions.dart';
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
                    title: context.l10n.add_media_title,
                    onPressed: () async {
                      context.pop();
                      final res =
                          await MediaSelectionRoute($extra: widget.album.source)
                              .push(context);

                      if (res != null && res is List<String>) {
                        await _notifier.addMedias(res);
                      }
                    },
                    icon: Icon(
                      Icons.add,
                      size: 24,
                      color: context.colorScheme.textPrimary,
                    ),
                  ),
                  AppSheetAction(
                    title: context.l10n.common_edit,
                    onPressed: () async {
                      context.pop();
                      final res = await AddAlbumRoute($extra: widget.album)
                          .push(context);
                      if (res == true) {
                        await _notifier.reloadAlbum();
                      }
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 24,
                      color: context.colorScheme.textPrimary,
                    ),
                  ),
                  AppSheetAction(
                    title: context.l10n.common_delete,
                    onPressed: () async {
                      context.pop();
                      await _notifier.deleteAlbum();
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
    if (state.loading && state.medias.isEmpty) {
      return const Center(child: AppCircularProgressIndicator());
    } else if (state.error != null) {
      return ErrorScreen(
        error: state.error!,
        onRetryTap: () => _notifier.loadMedia(reload: true),
      );
    } else if (state.medias.isEmpty) {
      return PlaceHolderScreen(
        icon: SvgPicture.asset(
          Assets.images.ilNoMediaFound,
          width: 150,
        ),
        title: context.l10n.empty_media_title,
        message: context.l10n.empty_media_message,
      );
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.mediaQuerySize.width > 600
            ? context.mediaQuerySize.width ~/ 180
            : context.mediaQuerySize.width ~/ 100,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: state.medias.length,
      itemBuilder: (context, index) => AppMediaThumbnail(
        heroTag: "album_media_list",
        media: state.medias[index],
      ),
    );
  }
}
