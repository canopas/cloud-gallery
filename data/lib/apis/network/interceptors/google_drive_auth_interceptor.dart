import 'dart:async';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleDriveAuthInterceptor extends Interceptor {
  final GoogleSignIn googleSignIn;

  GoogleDriveAuthInterceptor({
    required this.googleSignIn,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final authHeaders = await googleSignIn.currentUser?.authHeaders;
    if (authHeaders != null) {
      options.headers.addAll(authHeaders);
    }
    handler.next(options);
  }
}
