import 'dart:async';
import 'package:data/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/token/token.dart';

class DropboxAuthInterceptor extends Interceptor {
  final AuthService authService;
  final StateController<DropboxToken?> dropboxTokenController;

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
