import 'package:data/models/album/album.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:style/text/app_text_field.dart';
import 'package:style/text/app_text_style.dart';
import '../../../../components/app_page.dart';
import '../../../../components/snack_bar.dart';
import '../../../../domain/extensions/context_extensions.dart';
import 'add_album_state_notifier.dart';
import 'package:style/buttons/radio_selection_button.dart';

class AddAlbumScreen extends ConsumerStatefulWidget {
  final Album? editAlbum;

  const AddAlbumScreen({super.key, this.editAlbum});

  @override
  ConsumerState<AddAlbumScreen> createState() => _AddAlbumScreenState();
}

class _AddAlbumScreenState extends ConsumerState<AddAlbumScreen> {
  late AutoDisposeStateNotifierProvider<AddAlbumStateNotifier, AddAlbumsState>
      _provider;
  late AddAlbumStateNotifier _notifier;

  @override
  void initState() {
    _provider = addAlbumStateNotifierProvider(widget.editAlbum);
    _notifier = ref.read(_provider.notifier);
    super.initState();
  }

  void _observeError(BuildContext context) {
    ref.listen(
        _provider.select(
          (value) => value.error,
        ), (previous, error) {
      if (error != null) {
        showErrorSnackBar(context: context, error: error);
      }
    });
  }

  void _observeSucceed(BuildContext context) {
    ref.listen(
        _provider.select(
          (value) => value.succeed,
        ), (previous, success) {
      if (success) {
        context.pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _observeError(context);
    _observeSucceed(context);
    final state = ref.watch(_provider);
    return AppPage(
      resizeToAvoidBottomInset: false,
      title: context.l10n.add_album_screen_title,
      body: _body(context: context, state: state),
      actions: [
        state.loading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: AppCircularProgressIndicator(),
              )
            : ActionButton(
                onPressed: state.allowSave ? _notifier.createAlbum : null,
                icon: Icon(
                  Icons.check,
                  size: 24,
                  color: state.allowSave
                      ? context.colorScheme.textPrimary
                      : context.colorScheme.textDisabled,
                ),
              ),
      ],
    );
  }

  Widget _body({required BuildContext context, required AddAlbumsState state}) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppTextField(
            controller: state.albumNameController,
            onChanged: _notifier.validateAlbumName,
            label: context.l10n.album_name_field_title,
          ),
        ),
        if ((state.googleAccount != null || state.dropboxAccount != null) &&
            widget.editAlbum == null) ...[
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              context.l10n.store_in_title,
              style: AppTextStyles.subtitle1.copyWith(
                color: context.colorScheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              RadioSelectionButton<AppMediaSource>(
                value: AppMediaSource.local,
                groupValue: state.mediaSource,
                onTab: () => _notifier.onSourceChange(AppMediaSource.local),
                label: context.l10n.store_in_device_title,
              ),
              if (state.googleAccount != null)
                RadioSelectionButton<AppMediaSource>(
                  value: AppMediaSource.googleDrive,
                  groupValue: state.mediaSource,
                  onTab: () =>
                      _notifier.onSourceChange(AppMediaSource.googleDrive),
                  label: context.l10n.common_google_drive,
                ),
              if (state.dropboxAccount != null)
                RadioSelectionButton<AppMediaSource>(
                  value: AppMediaSource.dropbox,
                  groupValue: state.mediaSource,
                  onTab: () => _notifier.onSourceChange(AppMediaSource.dropbox),
                  label: context.l10n.common_dropbox,
                ),
            ],
          ),
        ],
      ],
    );
  }
}
