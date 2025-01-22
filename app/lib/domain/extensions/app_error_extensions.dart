import 'context_extensions.dart';
import 'package:data/errors/app_error.dart';
import 'package:data/errors/l10n_error_codes.dart';
import 'package:flutter/cupertino.dart';

extension AppErrorExtensions on Object {
  String l10nMessage(BuildContext context) {
    if (this is String) {
      return this as String;
    }
    switch (AppError.fromError(this).l10nCode) {
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
      case AppErrorL10nCodes.unableToSaveFileInGalleryError:
        return context.l10n.save_media_in_gallery_error;
      case AppErrorL10nCodes.noGoogleDriveAccessError:
        return context.l10n.no_google_drive_access_error;
      default:
        return context.l10n.something_went_wrong_error;
    }
  }
}
