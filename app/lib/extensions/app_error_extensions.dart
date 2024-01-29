import 'package:cloud_gallery/utils/extensions/context_extensions.dart';
import 'package:data/errors/app_error.dart';
import 'package:data/errors/l10n_error_codes.dart';
import 'package:flutter/cupertino.dart';

extension AppErrorExtensions on AppError {
  String l10nMessage(BuildContext context) {
    switch (l10nCode) {
      case AppErrorL10nCodes.noInternetConnection:
        return context.l10n.no_internet_connection_error;
      case AppErrorL10nCodes.somethingWentWrongError:
        return context.l10n.something_went_wrong_error;
      default:
        return message ?? context.l10n.something_went_wrong_error;
    }
  }
}
