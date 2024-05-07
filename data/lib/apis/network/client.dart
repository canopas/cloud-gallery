import 'package:data/errors/app_error.dart';
import 'package:data/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../storage/app_preferences.dart';
import 'endpoint.dart';
import 'interceptors/dropbox_auth_interceptor.dart';
import 'interceptors/google_drive_auth_interceptor.dart';

final googleAuthenticatedDioProvider = Provider((ref) {
  return Dio()
    ..options.connectTimeout = const Duration(seconds: 60)
    ..options.sendTimeout = const Duration(seconds: 60)
    ..options.receiveTimeout = const Duration(seconds: 60)
    ..interceptors.add(
      GoogleDriveAuthInterceptor(
        googleSignIn: ref.read(googleSignInProvider),
      ),
    );
});

final dropboxAuthenticatedDioProvider = Provider((ref) {
  return Dio()
    ..options.connectTimeout = const Duration(seconds: 60)
    ..options.sendTimeout = const Duration(seconds: 60)
    ..options.receiveTimeout = const Duration(seconds: 60)
    ..interceptors.add(
      DropboxAuthInterceptor(
        authService: ref.read(authServiceProvider),
        dropboxTokenController: ref.read(AppPreferences.dropboxToken.notifier),
      ),
    );
});

final rawDioProvider = Provider((ref) {
  return Dio()
    ..options.connectTimeout = const Duration(seconds: 60)
    ..options.sendTimeout = const Duration(seconds: 60)
    ..options.receiveTimeout = const Duration(seconds: 60);
});

extension DioExtensions on Dio {
  Future<Response<T>> req<T>(Endpoint endpoint) async {
    try {
      return await request(
        endpoint.baseUrl + endpoint.path,
        queryParameters: endpoint.queryParameters,
        options: Options(
          method: endpoint.method.name,
          headers: endpoint.headers,
          responseType: endpoint.responseType,
          contentType: endpoint.contentType,
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        ),
        data: endpoint.data,
        cancelToken: endpoint.cancelToken,
        onReceiveProgress: endpoint.onReceiveProgress,
        onSendProgress: endpoint.onSendProgress,
      );
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  Future<Response> downloadReq(DownloadEndpoint endpoint) async {
    try {
      return await download(
        endpoint.baseUrl + endpoint.path,
        endpoint.storePath,
        queryParameters: endpoint.queryParameters,
        options: Options(
          method: endpoint.method.name,
          headers: endpoint.headers,
          responseType: endpoint.responseType,
          contentType: endpoint.contentType,
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        ),
        data: endpoint.data,
        cancelToken: endpoint.cancelToken,
        onReceiveProgress: endpoint.onReceiveProgress,
      );
    } catch (e) {
      throw AppError.fromError(e);
    }
  }
}
