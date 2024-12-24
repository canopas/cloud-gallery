import '../domain/extensions/context_extensions.dart';
import 'place_holder_screen.dart';
import 'package:data/errors/app_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import '../gen/assets.gen.dart';

class ErrorScreen extends StatelessWidget {
  final Object error;
  final VoidCallback onRetryTap;

  const ErrorScreen({super.key, required this.error, required this.onRetryTap});

  @override
  Widget build(BuildContext context) {
    final error = AppError.fromError(this.error);
    if (error is NoConnectionError) {
      return _noInternetConnectionScreen(context);
    } else {
      return _errorScreen(context);
    }
  }

  Widget _noInternetConnectionScreen(BuildContext context) => PlaceHolderScreen(
        icon: SvgPicture.asset(
          Assets.images.ilNoInternet,
          height: 120,
          width: 120,
        ),
        title: context.l10n.no_internet_connection_title,
        message: context.l10n.no_internet_connection_message,
        action: PlaceHolderScreenAction(
          title: context.l10n.common_retry,
          onPressed: onRetryTap,
        ),
      );

  Widget _errorScreen(BuildContext context) => PlaceHolderScreen(
        icon: SvgPicture.asset(
          Assets.images.ilError,
          height: 120,
          width: 120,
        ),
        title: context.l10n.error_screen_title,
        message: context.l10n.error_screen_message,
        action: PlaceHolderScreenAction(
          title: context.l10n.common_retry,
          onPressed: onRetryTap,
        ),
      );
}
