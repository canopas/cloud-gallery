import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/animations/fade_in_switcher.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import '../../../components/app_page.dart';
import '../../../components/error_screen.dart';
import '../../../components/place_holder_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Albums',
      actions: [
        ActionButton(
          onPressed: () {
            ///TODO:Create Album
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

    if (state.loading) {
      return const Center(child: AppCircularProgressIndicator());
    } else if (state.error != null) {
      return ErrorScreen(
        error: state.error!,
        onRetryTap: _notifier.loadAlbums,
      );
    } else if (state.medias.isEmpty) {
      return PlaceHolderScreen(
        icon: Icon(
          CupertinoIcons.folder,
          size: 100,
          color: context.colorScheme.containerNormalOnSurface,
        ),
        title: 'Oops! No Albums Here!',
        message:
            "It seems like there are no albums to show right now. You can create a new one. We've got you covered!",
      );
    }

    return GridView(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      children: state.albums
          .map(
            (album) => Container(
              color: context.colorScheme.textSecondary,
            ),
          )
          .toList(),
    );
  }
}
