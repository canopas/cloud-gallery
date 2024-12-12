import 'package:app_links/app_links.dart';
import 'package:data/apis/network/urls.dart';
import 'package:data/log/logger.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/services/dropbox_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLinksProvider = Provider<AppLinks>((ref) {
  return AppLinks();
});

class DeepLinkHandler {
  static Future<void> observeDeepLinks({
    required ProviderContainer container,
  }) async {
    final appLinks = container.read(appLinksProvider);
    final logger = container.read(loggerProvider);

    Future<void> handleDeepLink(Uri link) async {
      if (link.toString().contains(RedirectURL.auth) &&
          link.queryParameters['code'] != null) {
        // Set the dropbox token from the code
        final authService = container.read(authServiceProvider);
        await authService.setDropboxTokenFromCode(
          code: link.queryParameters['code']!,
        );

        final dropboxService = container.read(dropboxServiceProvider);
        await Future.wait([
          dropboxService.setCurrentUserAccount(),
          dropboxService.setFileIdAppPropertyTemplate(),
        ]);
      }
    }

    try {
      final initialLink = await appLinks.getInitialLink();
      if (initialLink != null && !kDebugMode) handleDeepLink(initialLink);
    } catch (e, s) {
      logger.e(
        "DEEP LINK ERROR: Failed to handle deep link",
        error: e,
        stackTrace: s,
      );
    }

    appLinks.uriLinkStream.listen(
      (link) => handleDeepLink(link),
      onError: (e, s) {
        logger.e(
          "DEEP LINK ERROR: Failed to handle deep link",
          error: e,
          stackTrace: s,
        );
      },
    );
  }
}
