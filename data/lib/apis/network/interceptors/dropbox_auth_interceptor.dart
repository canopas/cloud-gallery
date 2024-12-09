import 'dart:async';
import '../../../models/dropbox/token/dropbox_token.dart';
import '../../../services/auth_service.dart';
import 'package:dio/dio.dart';

class DropboxAuthInterceptor extends Interceptor {
  final AuthService authService;
  final Dio rawDio;
  DropboxToken? dropboxToken;

  Completer<void>? _refreshTokenCompleter;

  DropboxAuthInterceptor({
    required this.dropboxToken,
    required this.authService,
    required this.rawDio,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    /// Add authorization header to the request if the token is not expired
    /// If the token is expired, refresh it and add the new token to the request
    if (dropboxToken != null) {
      if (dropboxToken!.expires_in.isBefore(DateTime.now())) {
        await _refreshAccessToken(dropboxToken!);
      }

      options.headers.addAll({
        'Authorization': 'Bearer ${dropboxToken!.access_token}',
      });
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        err.response?.data?['error']?['.tag'] == 'expired_access_token') {
      await _refreshAccessToken(dropboxToken!);
      try {
        handler.resolve(await _retry(err.requestOptions));
      } on DioException catch (e) {
        handler.next(e);
      }
      return;
    }

    /// If the error is not due to expired access token, pass the error to the next handler
    handler.next(err);
  }

  void updateToken(DropboxToken? newToken) {
    dropboxToken = newToken;
  }

  Future<void> _refreshAccessToken(DropboxToken dropboxToken) async {
    /// If there is already a refresh token request in progress, wait for it to complete
    if (_refreshTokenCompleter == null) {
      _refreshTokenCompleter = Completer<void>();

      /// Refresh the token
      await authService.refreshDropboxToken();
      _refreshTokenCompleter?.complete();
      _refreshTokenCompleter = null;
    } else {
      await _refreshTokenCompleter!.future;
    }
  }

  Future<Response> _retry(
    RequestOptions requestOptions,
  ) async {
    /// Remove the Authorization header from the request
    /// Add the new access token to the request
    final newHeaders = Map<String, dynamic>.from(requestOptions.headers);
    newHeaders.remove('Authorization');
    if (dropboxToken != null) {
      newHeaders['Authorization'] = 'Bearer ${dropboxToken!.access_token}';
    }

    /// Retry the request
    return rawDio.request(
      requestOptions.baseUrl + requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: newHeaders,
      ),
      cancelToken: requestOptions.cancelToken,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
    );
  }
}
