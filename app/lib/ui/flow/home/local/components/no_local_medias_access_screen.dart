import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/ui/flow/home/local/local_media_screen_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import 'package:style/buttons/primary_button.dart';

class NoLocalMediasAccessScreen extends ConsumerWidget {
  const NoLocalMediasAccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(localMediasViewStateNotifier.notifier);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.photo,
              color: context.colorScheme.containerHighOnSurface,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(context.l10n.cant_find_media_title,
                style: AppTextStyles.subtitle2.copyWith(
                  color: context.colorScheme.textPrimary,
                )),
            const SizedBox(height: 20),
            Text(
              context.l10n.ask_for_media_permission_message,
              style: AppTextStyles.body2.copyWith(
                color: context.colorScheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onPressed: () async {
                await openAppSettings();
                await notifier.loadMediaCount();
                await notifier.loadMedia();
              },
              text: context.l10n.load_local_media_button_text,
            ),
          ],
        ),
      ),
    );
  }
}
