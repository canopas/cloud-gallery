import 'package:cloud_gallery/components/error_view.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/ui/flow/home/home_screen_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:style/extensions/context_extensions.dart';

class NoLocalMediasAccessScreen extends ConsumerWidget {
  const NoLocalMediasAccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(homeViewStateNotifier.notifier);
    return ErrorView(
      title: context.l10n.cant_find_media_title,
      icon: Icon(
        CupertinoIcons.photo,
        color: context.colorScheme.containerHighOnSurface,
        size: 100,
      ),
      message: context.l10n.ask_for_media_permission_message,
      action: ErrorViewAction(
        onPressed: () async {
          await openAppSettings();
          await notifier.loadLocalMedia();
        },
        title: context.l10n.load_local_media_button_text,
      ),
    );
  }
}
