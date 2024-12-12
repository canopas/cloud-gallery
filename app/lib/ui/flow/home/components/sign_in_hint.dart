import 'package:style/animations/fade_in_switcher.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../../../../domain/extensions/context_extensions.dart';
import '../../../navigation/app_route.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenHints extends ConsumerWidget {
  const HomeScreenHints({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleAccount = ref.watch(googleUserAccountProvider);
    final dropboxAccount = ref.watch(AppPreferences.dropboxCurrentUserAccount);
    final signInHintShown = ref.watch(AppPreferences.signInHintShown);

    return FadeInSwitcher(
      child: (googleAccount != null ||
              dropboxAccount != null ||
              signInHintShown)
          ? const SizedBox()
          : Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colorScheme.containerLowOnSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.colorScheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.common_hey_there,
                    style: AppTextStyles.subtitle2.copyWith(
                      color: context.colorScheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.sign_in_hint_message,
                    style: AppTextStyles.body2.copyWith(
                      color: context.colorScheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            ref
                                .read(AppPreferences.signInHintShown.notifier)
                                .state = true;
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: context.colorScheme.containerLow,
                            foregroundColor: context.colorScheme.textPrimary,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: const Size(double.maxFinite, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            context.l10n.common_skip_for_now,
                            style: AppTextStyles.button,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            AccountRoute().push(context);
                            ref
                                .read(AppPreferences.signInHintShown.notifier)
                                .state = true;
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: context.colorScheme.containerLow,
                            foregroundColor: context.colorScheme.textPrimary,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: const Size(double.maxFinite, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            context.l10n.common_sign_in,
                            style: AppTextStyles.button,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
