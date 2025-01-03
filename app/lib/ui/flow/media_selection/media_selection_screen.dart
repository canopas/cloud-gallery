import 'package:data/models/media/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style/animations/fade_in_switcher.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:style/text/app_text_style.dart';
import '../../../components/app_media_thumbnail.dart';
import '../../../components/app_page.dart';
import '../../../components/error_screen.dart';
import '../../../components/place_holder_screen.dart';
import '../../../components/snack_bar.dart';
import '../../../domain/extensions/context_extensions.dart';
import '../../../domain/extensions/widget_extensions.dart';
import '../../../domain/formatter/date_formatter.dart';
import '../../../gen/assets.gen.dart';
import '../home/components/no_local_medias_access_screen.dart';
import 'media_selection_state_notifier.dart';
import 'package:style/callback/on_visible_callback.dart';

class MediaSelectionScreen extends ConsumerStatefulWidget {
  final AppMediaSource source;

  const MediaSelectionScreen({super.key, required this.source});

  @override
  ConsumerState createState() => _MediaSelectionScreenState();
}

class _MediaSelectionScreenState extends ConsumerState<MediaSelectionScreen> {
  late AutoDisposeStateNotifierProvider<MediaSelectionStateNotifier,
      MediaSelectionState> _provider;
  late MediaSelectionStateNotifier _notifier;

  void _observeError(BuildContext context) {
    ref.listen(
      _provider.select(
        (value) => value.actionError,
      ),
      (previous, error) {
        if (error != null) {
          showErrorSnackBar(context: context, error: error);
        }
      },
    );
  }

  @override
  void initState() {
    _provider = mediaSelectionStateNotifierProvider(widget.source);
    _notifier = ref.read(_provider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _observeError(context);
    final state = ref.watch(_provider);
    return AppPage(
      title: widget.source == AppMediaSource.googleDrive
          ? context.l10n.select_from_google_drive_title
          : widget.source == AppMediaSource.dropbox
              ? context.l10n.select_from_dropbox_title
              : context.l10n.select_from_device_title,
      actions: [
        ActionButton(
          onPressed: () {
            context.pop(state.selectedMedias);
          },
          icon: Icon(
            Icons.check,
            color: context.colorScheme.textPrimary,
            size: 24,
          ),
        ),
      ],
      body: Builder(
        builder: (context) {
          return FadeInSwitcher(child: _body(context: context, state: state));
        },
      ),
    );
  }

  Widget _body({
    required BuildContext context,
    required MediaSelectionState state,
  }) {
    if (state.loading && state.medias.isEmpty) {
      return const Center(child: AppCircularProgressIndicator());
    } else if (state.error != null) {
      return ErrorScreen(
        error: state.error!,
        onRetryTap: () => _notifier.loadMedias(reload: true),
      );
    } else if (state.medias.isEmpty && state.noAccess) {
      return widget.source == AppMediaSource.local
          ? NoLocalMediasAccessScreen()
          : PlaceHolderScreen(
              icon: SvgPicture.asset(
                Assets.images.ilNoMediaFound,
                width: 150,
              ),
              title: context.l10n.no_media_access_title,
              message: context.l10n.no_cloud_media_access_message,
            );
    } else if (state.medias.isEmpty && !state.noAccess) {
      return PlaceHolderScreen(
        icon: SvgPicture.asset(
          Assets.images.ilNoMediaFound,
          width: 150,
        ),
        title: context.l10n.empty_media_title,
        message: context.l10n.empty_media_message,
      );
    } else {
      return ListView.builder(
        itemCount: state.medias.length + 1,
        itemBuilder: (context, index) {
          if (index < state.medias.length) {
            final gridEntry = state.medias.entries.elementAt(index);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Builder(
                  builder: (context) {
                    return Container(
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
                    );
                  },
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
                  itemBuilder: (context, index) => AppMediaThumbnail(
                    heroTag: "selection",
                    onTap: () {
                      _notifier.toggleMediaSelection(
                        gridEntry.value.elementAt(index),
                      );
                    },
                    selected: state.selectedMedias.contains(
                      widget.source == AppMediaSource.googleDrive
                          ? gridEntry.value.elementAt(index).driveMediaRefId
                          : widget.source == AppMediaSource.dropbox
                              ? gridEntry.value
                                  .elementAt(index)
                                  .dropboxMediaRefId
                              : gridEntry.value.elementAt(index).id,
                    ),
                    media: gridEntry.value.elementAt(index),
                  ),
                ),
              ],
            );
          } else {
            return OnVisibleCallback(
              onVisible: () {
                runPostFrame(() {
                  _notifier.loadMedias();
                });
              },
              child: FadeInSwitcher(
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
              ),
            );
          }
        },
      );
    }
  }
}
