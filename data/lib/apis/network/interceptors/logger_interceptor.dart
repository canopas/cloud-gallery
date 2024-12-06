import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends Interceptor {
  final Logger logger;

  LoggerInterceptor({required this.logger});

  String prettyJson(Object? data) {
    try {
      if (data is Map<String, dynamic> || data is List) {
        return JsonEncoder.withIndent("     ").convert(data);
      } else {
        return data.toString();
      }
    } catch (e) {
      return data.toString();
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String message = '⚡️ Request Started: [${options.method}] ${options.uri}';
    if (kDebugMode) {
      if (options.headers.isNotEmpty) {
        message += '\n⚡️ Headers: ${prettyJson(options.headers)}';
      }
      if (options.data != null) {
        message += '\n⚡️ Body: ${prettyJson(options.data)}';
      }
      if (options.queryParameters.isNotEmpty) {
        message +=
            '\n⚡️ Query Parameters: ${prettyJson(options.queryParameters)}';
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
        message += '\n⚡️ Headers: ${prettyJson(response.headers.map)}';
      }
      message += '\n⚡️ Response body: ${prettyJson(response.data)}';
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
        message += '\n⚡️ Headers: ${prettyJson(err.response!.headers.map)}';
      }
      message += '\n⚡️ Body: ${prettyJson(err.response?.data)}';
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
