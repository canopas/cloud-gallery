import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends Interceptor {
  final Logger logger;

  LoggerInterceptor({required this.logger});

  String logMap(Map<String, dynamic> headers) {
    final sb = StringBuffer();
    sb.write('{\n');
    headers.forEach((key, value) {
      sb.write('      $key: ${value.toString()}\n');
    });
    sb.write('   }');
    return sb.toString();
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String message = '⚡️ Request Started: [${options.method}] ${options.uri}';
    if (kDebugMode) {
      if (options.headers.isNotEmpty) {
        message += '\n⚡️ Headers: ${logMap(options.headers)}';
      }
      if (options.data != null) {
        message +=
            '\n⚡️ Body: ${JsonEncoder.withIndent("     ").convert(options.data)}';
      }
      if (options.queryParameters.isNotEmpty) {
        message += '\n⚡️ Query Parameters: ${logMap(options.queryParameters)}';
      }
    }
    logger.d(message);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    String message =
        '⚡️ Response: ${response.statusCode} -> [${response.requestOptions.method}] ${response.requestOptions.uri}';

    if (kDebugMode) {
      if (response.headers.map.isNotEmpty) {
        message += '\n⚡️ Headers: ${logMap(response.headers.map)}';
      }
      message +=
          '\n⚡️ Response body: ${JsonEncoder.withIndent("     ").convert(response.data)}';
    }
    logger.d(message);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message =
        '⚡️ ERROR at [${err.requestOptions.method}] ${err.requestOptions.uri}: (${err.response?.statusCode}) ${err.message?.trim()}';
    if (err.response != null) {
      if (err.response!.headers.map.isNotEmpty) {
        message += '\n⚡️ Headers: ${logMap(err.response!.headers.map)}';
      }
      message +=
          '\n⚡️ Body: ${JsonEncoder.withIndent("     ").convert(err.response?.data)}';
    }
    logger.e(
      message,
      error: err.error,
      stackTrace: err.stackTrace,
      time: DateTime.now(),
    );
    handler.next(err);
  }
}
