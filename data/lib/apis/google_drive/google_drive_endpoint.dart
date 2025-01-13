import 'dart:convert';
import '../../domain/config.dart';
import '../network/endpoint.dart';
import '../../models/media_content/media_content.dart';
import 'package:dio/dio.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http_parser/http_parser.dart';
import '../network/urls.dart';

class GoogleDriveCreateFolderEndpoint extends Endpoint {
  final String name;

  const GoogleDriveCreateFolderEndpoint({required this.name});

  @override
  String get baseUrl => BaseURL.googleDriveV3;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  Object? get data => {
        'name': name,
        'mimeType': 'application/vnd.google-apps.folder',
      };

  @override
  String get path => '/files';
}

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
        'Content-Type': content.type,
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
        'fields':
            'id, name, description, mimeType, thumbnailLink, webContentLink, createdTime, modifiedTime, size, imageMediaMetadata, videoMediaMetadata, appProperties',
      };

  @override
  void Function(int p1, int p2)? get onSendProgress => onProgress;
}

class GoogleDriveStartUploadEndpoint extends Endpoint {
  final drive.File request;
  final CancelToken? cancellationToken;

  const GoogleDriveStartUploadEndpoint({
    required this.request,
    this.cancellationToken,
  });

  @override
  String get baseUrl => BaseURL.googleDriveUploadV3;

  @override
  CancelToken? get cancelToken => cancellationToken;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  Object? get data => request.toJson();

  @override
  String get path => '/files';

  @override
  Map<String, dynamic>? get queryParameters => {
        'uploadType': 'resumable',
      };
}

class GoogleDriveAppendUploadEndpoint extends Endpoint {
  final String uploadId;
  final AppMediaContent content;
  final CancelToken? cancellationToken;
  final void Function(int chunk, int length)? onProgress;

  const GoogleDriveAppendUploadEndpoint({
    required this.uploadId,
    required this.content,
    this.cancellationToken,
    this.onProgress,
  });

  @override
  String get baseUrl => BaseURL.googleDriveUploadV3;

  @override
  CancelToken? get cancelToken => cancellationToken;

  @override
  HttpMethod get method => HttpMethod.put;

  @override
  Map<String, dynamic> get headers => {
        'Content-Type': content.type,
        'Content-Length': content.length.toString(),
        'Content-Range': content.range,
      };

  @override
  Object? get data => content.stream;

  @override
  String get path => '/files';

  @override
  Map<String, dynamic>? get queryParameters => {
        'upload_id': uploadId,
        'uploadType': 'resumable',
      };

  @override
  void Function(int p1, int p2)? get onSendProgress => onProgress;
}

class GoogleDriveContentUpdateEndpoint extends Endpoint {
  final AppMediaContent content;
  final String id;
  final CancelToken? cancellationToken;
  final void Function(int chunk, int length)? onProgress;

  const GoogleDriveContentUpdateEndpoint({
    required this.content,
    required this.id,
    this.cancellationToken,
    this.onProgress,
  });

  @override
  String get baseUrl => BaseURL.googleDriveUploadV3;

  @override
  CancelToken? get cancelToken => cancellationToken;

  @override
  HttpMethod get method => HttpMethod.patch;

  @override
  Map<String, dynamic> get headers => {
        'Content-Type': content.type,
        'Content-Length': content.length.toString(),
      };

  @override
  Object? get data => content.stream;

  @override
  String get path => '/files/$id';

  @override
  Map<String, dynamic>? get queryParameters => {
        'uploadType': 'media',
        'fields':
            'id, name, description, mimeType, thumbnailLink, webContentLink, createdTime, modifiedTime, size, imageMediaMetadata, videoMediaMetadata, appProperties',
      };

  @override
  void Function(int p1, int p2)? get onSendProgress => onProgress;
}

class GoogleDriveDownloadEndpoint extends DownloadEndpoint {
  final String id;

  final void Function(int received, int total)? onProgress;

  final String? saveLocation;

  final CancelToken? cancellationToken;

  const GoogleDriveDownloadEndpoint({
    required this.id,
    this.cancellationToken,
    this.onProgress,
    this.saveLocation,
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

class GoogleDriveDeleteEndpoint extends Endpoint {
  final String id;

  const GoogleDriveDeleteEndpoint({required this.id});

  @override
  String get baseUrl => BaseURL.googleDriveV3;

  @override
  String get path => '/files/$id';

  @override
  HttpMethod get method => HttpMethod.delete;
}

class GoogleDriveListEndpoint extends Endpoint {
  final String? orderBy;
  final String fields;
  final String? q;
  final int? pageSize;
  final String? pageToken;

  const GoogleDriveListEndpoint({
    this.orderBy = 'createdTime desc',
    this.pageSize,
    this.pageToken,
    this.q,
    this.fields =
        'nextPageToken, files(id, name, description, mimeType, thumbnailLink, webContentLink, createdTime, modifiedTime, size, imageMediaMetadata, videoMediaMetadata, appProperties)',
  });

  @override
  String get baseUrl => BaseURL.googleDriveV3;

  @override
  String get path => '/files';

  @override
  HttpMethod get method => HttpMethod.get;

  @override
  Map<String, dynamic>? get queryParameters => {
        if (orderBy != null) 'orderBy': orderBy,
        if (pageSize != null) 'pageSize': pageSize,
        if (pageToken != null) 'pageToken': pageToken,
        if (q != null) 'q': q,
        'fields': fields,
      };
}

class GoogleDriveGetEndpoint extends Endpoint {
  final String fields;
  final String id;

  const GoogleDriveGetEndpoint({
    required this.id,
    this.fields =
        'id, name, description, mimeType, thumbnailLink, webContentLink, createdTime, modifiedTime, size, imageMediaMetadata, videoMediaMetadata, appProperties',
  });

  @override
  String get baseUrl => BaseURL.googleDriveV3;

  @override
  String get path => '/files/$id';

  @override
  HttpMethod get method => HttpMethod.get;

  @override
  Map<String, dynamic>? get queryParameters => {
        'fields': fields,
      };
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
