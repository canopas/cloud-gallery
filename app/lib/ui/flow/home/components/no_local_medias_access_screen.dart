import '../../../../components/place_holder_screen.dart';
import '../../../../domain/extensions/context_extensions.dart';
import '../home_screen_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:style/extensions/context_extensions.dart';

class NoLocalMediasAccessScreen extends ConsumerWidget {
  const NoLocalMediasAccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(homeViewStateNotifier.notifier);
    return PlaceHolderScreen(
      title: context.l10n.no_media_access_screen_title,
      icon: Icon(
        CupertinoIcons.photo_on_rectangle,
        color: context.colorScheme.containerNormalOnSurface,
        size: 120,
      ),
      message: context.l10n.no_media_access_screen_message,
      action: PlaceHolderScreenAction(
        onPressed: () async {
          await openAppSettings();
          notifier.loadMedias(reload: true);
        },
        title: context.l10n.common_open_settings,
      ),
    );
  }
}
