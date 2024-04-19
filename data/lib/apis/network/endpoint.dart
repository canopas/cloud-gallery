import 'package:dio/dio.dart';

enum HttpMethod { get, post, put, delete, patch }

abstract class Endpoint {
  const Endpoint();

  HttpMethod get method => HttpMethod.get;

  String get path;

  String get baseUrl;

  Map<String, dynamic>? get queryParameters => null;

  Map<String, dynamic> get headers => const {};

  Object? get data => null;

  String? get contentType => null;

  ResponseType get responseType => ResponseType.json;

  CancelToken? get cancelToken => null;

  void Function(int, int)? get onReceiveProgress => null;

  void Function(int, int)? get onSendProgress => null;
}

abstract class DownloadEndpoint extends Endpoint {
  const DownloadEndpoint();
  @override
  ResponseType get responseType => ResponseType.stream;

  String? get storePath;
}
