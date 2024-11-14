import 'interceptors/auth_interceptor.dart';
import '../../errors/app_error.dart';
import '../../services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'endpoint.dart';

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
    } catch (error) {
      throw AppError.fromError(error);
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
