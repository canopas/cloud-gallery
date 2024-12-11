import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/animations/fade_in_switcher.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../../../../domain/extensions/context_extensions.dart';
import '../../../../gen/assets.gen.dart';
import '../home_screen_view_model.dart';

class NoInternetConnectionHint extends ConsumerWidget {
  const NoInternetConnectionHint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showHint = ref.read(
      homeViewStateNotifier.select(
        (value) =>
            !value.hasInternet &&
            (value.dropboxAccount != null || value.googleAccount != null),
      ),
    );
    return FadeInSwitcher(
      child: !showHint
          ? const SizedBox()
          : Container(
              margin: EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: context.colorScheme.containerLowOnSurface,
                border: Border.all(
                  color: context.colorScheme.outline,
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    Assets.images.icNoInternet,
                    height: 50,
                    width: 50,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      context.l10n.no_internet_connection_message,
                      style: AppTextStyles.body2.copyWith(
                        letterSpacing: 0.05,
                        color: context.colorScheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
