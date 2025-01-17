import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/animations/fade_in_switcher.dart';
import 'package:style/buttons/primary_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import '../../../components/app_page.dart';
import '../../../components/error_screen.dart';
import '../../../components/place_holder_screen.dart';
import '../../../components/snack_bar.dart';
import '../../../domain/extensions/context_extensions.dart';
import '../home/components/app_media_item.dart';
import 'clean_up_state_notifier.dart';

class CleanUpScreen extends ConsumerStatefulWidget {
  const CleanUpScreen({super.key});

  @override
  ConsumerState<CleanUpScreen> createState() => _BinScreenState();
}

class _BinScreenState extends ConsumerState<CleanUpScreen> {
  late CleanUpStateNotifier _notifier;

  @override
  void initState() {
    _notifier = ref.read(cleanUpStateNotifierProvider.notifier);
    super.initState();
  }

  void _observeError() {
    ref.listen(
      cleanUpStateNotifierProvider.select((value) => value.actionError),
      (previous, next) {
        if (next != null) {
          showErrorSnackBar(context: context, error: next);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _observeError();
    return AppPage(
      title: context.l10n.clean_up_screen_title,
      body: FadeInSwitcher(child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    final state = ref.watch(cleanUpStateNotifierProvider);

    if (state.loading) {
      return const Center(child: AppCircularProgressIndicator());
    } else if (state.error != null) {
      return ErrorScreen(
        error: state.error!,
        onRetryTap: _notifier.loadCleanUpMedias,
      );
    } else if (state.medias.isEmpty) {
      return PlaceHolderScreen(
        icon: Icon(
          Icons.cleaning_services,
          size: 100,
          color: context.colorScheme.containerHighOnSurface,
        ),
        title: context.l10n.empty_clean_up_title,
        message: context.l10n.empty_clean_up_message,
      );
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(4),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (context.mediaQuerySize.width > 600
                      ? context.mediaQuerySize.width ~/ 180
                      : context.mediaQuerySize.width ~/ 100)
                  .clamp(1, 6),
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: state.medias.length,
            itemBuilder: (context, index) {
              return AppMediaItem(
                media: state.medias[index],
                heroTag: "clean_up${state.medias[index].toString()}",
                onTap: () async {
                  _notifier.toggleSelection(state.medias[index].id);
                  HapticFeedback.lightImpact();
                },
                isSelected: state.selected.contains(state.medias[index].id),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16)
              .copyWith(bottom: 16 + context.systemPadding.bottom),
          child: SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              onPressed: _notifier.deleteAll,
              text: context.l10n.clean_up_title,
              child: state.deleteAllLoading
                  ? AppCircularProgressIndicator(
                      color: context.colorScheme.onPrimary,
                    )
                  : Text(context.l10n.clean_up_title),
            ),
          ),
        ),
      ],
    );
  }
}
