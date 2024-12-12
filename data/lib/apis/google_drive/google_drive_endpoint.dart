import 'dart:convert';
import '../../domain/config.dart';
import '../network/endpoint.dart';
import '../../models/media_content/media_content.dart';
import 'package:dio/dio.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http_parser/http_parser.dart';
import '../network/urls.dart';

class GoogleDriveUploadEndpoint extends Endpoint {
  final drive.File request;
  final AppMediaContent content;
  final CancelToken? cancellationToken;
  final void Function(int chunk, int length)? onProgress;

  const GoogleDriveUploadEndpoint({
    required this.request,
    required this.content,
    this.cancellationToken,
    this.onProgress,
  });

  @override
  String get baseUrl => BaseURL.googleDriveUploadV3;

  @override
  CancelToken? get cancelToken => cancellationToken;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  Map<String, dynamic> get headers => {
        'Content-Type': content.contentType,
        'Content-Length': content.length.toString(),
      };

  @override
  Object? get data => FormData.fromMap(
        {
          'metadata': MultipartFile.fromString(
            json.encode(request.toJson()),
            contentType: MediaType.parse("application/json; charset=UTF-8"),
          ),
          'media': MultipartFile.fromStream(
            () => content.stream,
            content.length ?? 0,
          ),
        },
      );

  @override
  String get path => '/files';

  @override
  Map<String, dynamic>? get queryParameters => {
        'uploadType': 'multipart',
      };

  @override
  void Function(int p1, int p2)? get onSendProgress => onProgress;
}

class GoogleDriveDownloadEndpoint extends DownloadEndpoint {
  final String id;

  final void Function(int received, int total)? onProgress;

  final String saveLocation;

  final CancelToken? cancellationToken;

  const GoogleDriveDownloadEndpoint({
    required this.id,
    this.cancellationToken,
    this.onProgress,
    required this.saveLocation,
  });

  @override
  String get baseUrl => BaseURL.googleDriveV3;

  @override
  String get path => '/files/$id';

  @override
  Map<String, dynamic>? get queryParameters => {
        'alt': 'media',
      };

  @override
  CancelToken? get cancelToken => cancellationToken;

  @override
  void Function(int p1, int p2)? get onReceiveProgress => onProgress;

  @override
  String? get storePath => saveLocation;
}

class GoogleDriveUpdateAppPropertiesEndpoint extends Endpoint {
  final String id;
  final String localFileId;

  const GoogleDriveUpdateAppPropertiesEndpoint({
    required this.id,
    required this.localFileId,
  });

  @override
  String get baseUrl => BaseURL.googleDriveV3;

  @override
  String get path => '/files/$id';

  @override
  HttpMethod get method => HttpMethod.patch;

  @override
  Object? get data => {
        "appProperties": {
          ProviderConstants.localRefIdKey: localFileId,
        },
      };
}
