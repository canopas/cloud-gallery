import '../../../components/app_page.dart';
import '../../../domain/extensions/context_extensions.dart';
import '../../../gen/assets.gen.dart';
import '../../navigation/app_route.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import 'package:style/animations/on_tap_scale.dart';

class OnBoardScreen extends ConsumerWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPage(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  context.colorScheme.primary.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _appLogo(context),
                  _onBoardDescription(context),
                  _getStartedButton(
                    context: context,
                    onGetStartedTap: () {
                      ref
                          .read(AppPreferences.isOnBoardComplete.notifier)
                          .state = true;
                      HomeRoute().go(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appLogo(BuildContext context) => Image.asset(
        Assets.images.appIcon.path,
        width: 250,
      );

  Widget _onBoardDescription(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.l10n.app_name,
              style: AppTextStyles.header1.copyWith(
                color: context.colorScheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.on_board_description,
              style: AppTextStyles.subtitle1
                  .copyWith(color: context.colorScheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  Widget _getStartedButton({
    required BuildContext context,
    required VoidCallback onGetStartedTap,
  }) {
    return OnTapScale(
      onTap: onGetStartedTap,
      child: Container(
        width: context.mediaQuerySize.width * 0.8,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: context.colorScheme.primary,
        ),
        alignment: Alignment.center,
        child: Text(
          context.l10n.common_get_started,
          style: AppTextStyles.button.copyWith(
            color: context.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
