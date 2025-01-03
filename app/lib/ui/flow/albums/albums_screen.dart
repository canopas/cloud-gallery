import 'package:data/models/album/album.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style/animations/fade_in_switcher.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:style/text/app_text_style.dart';
import '../../../components/action_sheet.dart';
import '../../../components/app_page.dart';
import '../../../components/app_sheet.dart';
import '../../../components/error_screen.dart';
import '../../../components/place_holder_screen.dart';
import '../../../components/snack_bar.dart';
import '../../../components/thumbnail_builder.dart';
import '../../../domain/extensions/context_extensions.dart';
import '../../../gen/assets.gen.dart';
import '../../navigation/app_route.dart';
import 'albums_view_notifier.dart';

class AlbumsScreen extends ConsumerStatefulWidget {
  const AlbumsScreen({super.key});

  @override
  ConsumerState<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends ConsumerState<AlbumsScreen> {
  late AlbumStateNotifier _notifier;

  @override
  void initState() {
    _notifier = ref.read(albumStateNotifierProvider.notifier);
    super.initState();
  }

  void _observeError(BuildContext context) {
    ref.listen(
        albumStateNotifierProvider.select(
          (value) => value.actionError,
        ), (previous, error) {
      if (error != null) {
        showErrorSnackBar(context: context, error: error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _observeError(context);
    return AppPage(
      title: context.l10n.album_screen_title,
      actions: [
        ActionButton(
          onPressed: () async {
            final res = await AddAlbumRoute().push(context);
            if (res == true) {
              _notifier.loadAlbums();
            }
          },
          icon: Icon(
            Icons.add,
            color: context.colorScheme.textPrimary,
          ),
        ),
      ],
      body: FadeInSwitcher(child: _body(context: context)),
    );
  }

  Widget _body({required BuildContext context}) {
    final state = ref.watch(albumStateNotifierProvider);

    if (state.loading && state.albums.isEmpty) {
      return const Center(child: AppCircularProgressIndicator());
    } else if (state.error != null) {
      return ErrorScreen(
        error: state.error!,
        onRetryTap: _notifier.loadAlbums,
      );
    } else if (state.albums.isEmpty) {
      return PlaceHolderScreen(
        icon: Icon(
          CupertinoIcons.folder,
          size: 100,
          color: context.colorScheme.containerNormalOnSurface,
        ),
        title: context.l10n.empty_album_title,
        message: context.l10n.empty_album_message,
      );
    }

    return GridView(
      padding: EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
      ),
      children: state.albums
          .map(
            (album) => AlbumItem(
              album: album,
              onTap: () async {
                await AlbumMediaListRoute(
                  $extra: album,
                ).push(context);
                _notifier.loadAlbums();
              },
              onLongTap: () {
                showAppSheet(
                  context: context,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppSheetAction(
                        title: context.l10n.common_edit,
                        onPressed: () async {
                          context.pop();
                          final res = await AddAlbumRoute(
                            $extra: album,
                          ).push(context);
                          if (res == true) {
                            _notifier.loadAlbums();
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
                        onPressed: () {
                          context.pop();
                          _notifier.deleteAlbum(album);
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
            ),
          )
          .toList(),
    );
  }
}

class AlbumItem extends StatelessWidget {
  final Album album;
  final void Function() onTap;
  final void Function() onLongTap;

  const AlbumItem({
    super.key,
    required this.album,
    required this.onTap,
    required this.onLongTap,
  });

  @override
  Widget build(BuildContext context) {
    return OnTapScale(
      onTap: onTap,
      onLongTap: onLongTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: album.medias.isEmpty
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.colorScheme.containerLowOnSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: context.colorScheme.outline,
                      ),
                    ),
                    child: Icon(
                      CupertinoIcons.folder,
                      size: 80,
                      color: context.colorScheme.containerHighOnSurface,
                    ),
                  )
                : AppMediaImage(
                    media: AppMedia(
                      id: album.medias.first,
                      path: '',
                      type: AppMediaType.image,
                      sources: [album.source],
                    ),
                    size: Size(300, 300),
                  ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                if (album.source == AppMediaSource.dropbox) ...[
                  SvgPicture.asset(
                    Assets.images.icDropbox,
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 4),
                ],
                if (album.source == AppMediaSource.googleDrive) ...[
                  SvgPicture.asset(
                    Assets.images.icGoogleDrive,
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(
                    album.name,
                    style: AppTextStyles.subtitle1.copyWith(
                      color: context.colorScheme.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
