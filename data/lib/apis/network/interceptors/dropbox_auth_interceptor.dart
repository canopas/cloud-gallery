import 'dart:async';
import '../../../models/dropbox/token/dropbox_token.dart';
import '../../../services/auth_service.dart';
import 'package:dio/dio.dart';
import '../../../storage/provider/preferences_provider.dart';

class DropboxAuthInterceptor extends Interceptor {
  final AuthService authService;
  final PreferenceNotifier<DropboxToken?> dropboxTokenController;

  Completer<void>? _refreshTokenCompleter;

  DropboxAuthInterceptor({
    required this.dropboxTokenController,
    required this.authService,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final dropboxToken = dropboxTokenController.state;
    if (dropboxToken != null) {
      await _refreshTokenIfNeeded(dropboxToken);
      options.headers.addAll({
        'Authorization': 'Bearer ${dropboxToken.access_token}',
      });
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        dropboxTokenController.state != null) {
      await _refreshTokenIfNeeded(dropboxTokenController.state!);
    }
    handler.next(err);
  }

  Future<void> _refreshTokenIfNeeded(DropboxToken dropboxToken) async {
    if (dropboxToken.expires_in.isBefore(DateTime.now())) {
      if (_refreshTokenCompleter == null) {
        _refreshTokenCompleter = Completer<void>();
        await authService.refreshDropboxToken();
        _refreshTokenCompleter?.complete();
        _refreshTokenCompleter = null;
      } else {
        await _refreshTokenCompleter!.future;
      }
    }
  }
}
