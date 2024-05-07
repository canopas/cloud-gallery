import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:data/errors/app_error.dart';
import 'package:data/errors/l10n_error_codes.dart';
import 'package:flutter/cupertino.dart';

extension AppErrorExtensions on Object {
  String l10nMessage(BuildContext context) {
    if (this is AppError) {
      switch ((this as AppError).l10nCode) {
        case AppErrorL10nCodes.noInternetConnectionError:
          return context.l10n.no_internet_connection_error;
        case AppErrorL10nCodes.somethingWentWrongError:
          return context.l10n.something_went_wrong_error;
        case AppErrorL10nCodes.googleSignInUserNotFoundError:
          return context.l10n.user_google_sign_in_account_not_found_error;
        case AppErrorL10nCodes.backUpFolderNotFoundError:
          return context.l10n.back_up_folder_not_found_error;
        case AppErrorL10nCodes.authSessionExpiredError:
          return context.l10n.auth_session_expired_error;
        default:
          return (this as AppError).message ??
              context.l10n.something_went_wrong_error;
      }
    } else if (this is String) {
      return this as String;
    } else {
      return context.l10n.something_went_wrong_error;
    }
  }
}
