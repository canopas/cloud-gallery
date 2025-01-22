import 'dart:convert';
import 'package:dio/dio.dart';
import '../../domain/config.dart';
import '../../models/media_content/media_content.dart';
import '../network/endpoint.dart';
import '../network/urls.dart';

class DropboxCreateFolderEndpoint extends Endpoint {
  final String name;

  const DropboxCreateFolderEndpoint({required this.name});

  @override
  String get baseUrl => BaseURL.dropboxV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/files/create_folder_v2';

  @override
  Object? get data => {"autorename": false, "path": "/$name"};
}

class DropboxListFolderEndpoint extends Endpoint {
  final bool includeDeleted;
  final String? appPropertyTemplateId;
  final bool includeHasExplicitSharedMembers;
  final int limit;
  final bool includeMountedFolders;
  final bool includeNonDownloadableFiles;
  final String folderPath;
  final bool recursive;

  const DropboxListFolderEndpoint({
    this.includeDeleted = false,
    this.includeHasExplicitSharedMembers = false,
    required this.limit,
    this.includeMountedFolders = false,
    this.includeNonDownloadableFiles = false,
    this.recursive = false,
    required this.folderPath,
    this.appPropertyTemplateId,
  });

  @override
  String get baseUrl => BaseURL.dropboxV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/files/list_folder';

  @override
  Object? get data => {
        "include_deleted": includeDeleted,
        "include_has_explicit_shared_members": includeHasExplicitSharedMembers,
        "limit": limit,
        if (appPropertyTemplateId != null)
          'include_property_groups': {
            ".tag": "filter_some",
            "filter_some": [appPropertyTemplateId],
          },
        "include_mounted_folders": includeMountedFolders,
        "include_non_downloadable_files": includeNonDownloadableFiles,
        "path": folderPath,
        "recursive": recursive,
      };
}

class DropboxListFolderContinueEndpoint extends Endpoint {
  final String cursor;

  const DropboxListFolderContinueEndpoint({
    required this.cursor,
  });

  @override
  String get baseUrl => BaseURL.dropboxV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/files/list_folder/continue';

  @override
  Object? get data => {
        "cursor": cursor,
      };
}

class DropboxUploadEndpoint extends Endpoint {
  final String? appPropertyTemplateId;
  final String filePath;
  final String? localRefId;
  final String mode;
  final bool autoRename;
  final bool mute;
  final AppMediaContent content;
  final bool strictConflict;
  final void Function(int chunk, int length)? onProgress;
  final CancelToken? cancellationToken;

  const DropboxUploadEndpoint({
    this.appPropertyTemplateId,
    required this.filePath,
    this.mode = 'add',
    this.autoRename = true,
    this.mute = false,
    this.localRefId,
    this.strictConflict = false,
    this.cancellationToken,
    this.onProgress,
    required this.content,
  });

  @override
  String get baseUrl => BaseURL.dropboxContentV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/files/upload';

  @override
  Map<String, dynamic> get headers => {
        'Dropbox-API-Arg': jsonEncode({
          'path': filePath,
          'mode': mode,
          'autorename': autoRename,
          'mute': mute,
          'strict_conflict': strictConflict,
          if (appPropertyTemplateId != null && localRefId != null)
            'property_groups': [
              {
                "fields": [
                  {
                    "name": ProviderConstants.localRefIdKey,
                    "value": localRefId ?? '',
                  },
                ],
                "template_id": appPropertyTemplateId,
              }
            ],
        }),
        'Content-Type': content.type,
        'Content-Length': content.length,
      };

  @override
  Object? get data => content.stream;

  @override
  CancelToken? get cancelToken => cancellationToken;

  @override
  void Function(int p1, int p2)? get onSendProgress => onProgress;
}

class DropboxStartUploadEndpoint extends Endpoint {
  final AppMediaContent content;
  final void Function(int chunk, int length)? onProgress;
  final CancelToken? cancellationToken;

  const DropboxStartUploadEndpoint({
    this.cancellationToken,
    this.onProgress,
    required this.content,
  });

  @override
  String get baseUrl => BaseURL.dropboxContentV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/files/upload_session/start';

  @override
  Map<String, dynamic> get headers => {
        'Content-Type': content.type,
      };

  @override
  Object? get data => content.stream;

  @override
  CancelToken? get cancelToken => cancellationToken;

  @override
  void Function(int p1, int p2)? get onSendProgress => onProgress;
}

class DropboxAppendUploadEndpoint extends Endpoint {
  final String sessionId;
  final int offset;
  final AppMediaContent content;
  final void Function(int chunk, int length)? onProgress;
  final CancelToken? cancellationToken;

  const DropboxAppendUploadEndpoint({
    required this.sessionId,
    required this.offset,
    this.cancellationToken,
    this.onProgress,
    required this.content,
  });

  @override
  String get baseUrl => BaseURL.dropboxContentV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/files/upload_session/append_v2';

  @override
  Map<String, dynamic> get headers => {
        'Dropbox-API-Arg': jsonEncode({
          'cursor': {
            'session_id': sessionId,
            'offset': offset,
          },
        }),
        'Content-Type': content.type,
      };

  @override
  Object? get data => content.stream;

  @override
  CancelToken? get cancelToken => cancellationToken;

  @override
  void Function(int p1, int p2)? get onSendProgress => onProgress;
}

class DropboxFinishUploadEndpoint extends Endpoint {
  final String? appPropertyTemplateId;
  final String filePath;
  final String? localRefId;
  final String mode;
  final bool autoRename;
  final bool mute;
  final bool strictConflict;

  final String sessionId;
  final int offset;
  final AppMediaContent content;
  final void Function(int chunk, int length)? onProgress;
  final CancelToken? cancellationToken;

  const DropboxFinishUploadEndpoint({
    this.appPropertyTemplateId,
    required this.filePath,
    this.mode = 'add',
    this.autoRename = true,
    this.mute = false,
    this.localRefId,
    this.strictConflict = false,
    this.cancellationToken,
    this.onProgress,
    required this.content,
    required this.sessionId,
    required this.offset,
  });

  @override
  String get baseUrl => BaseURL.dropboxContentV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/files/upload_session/finish';

  @override
  Map<String, dynamic> get headers => {
        'Dropbox-API-Arg': jsonEncode({
          "commit": {
            "autorename": autoRename,
            "mode": mode,
            "mute": mute,
            "path": filePath,
            "strict_conflict": strictConflict,
            if (appPropertyTemplateId != null && localRefId != null)
              'property_groups': [
                {
                  "fields": [
                    {
                      "name": ProviderConstants.localRefIdKey,
                      "value": localRefId ?? '',
                    },
                  ],
                  "template_id": appPropertyTemplateId,
                }
              ],
          },
          "cursor": {
            "offset": offset,
            "session_id": sessionId,
          },
        }),
        'Content-Type': content.type,
      };

  @override
  Object? get data => content.stream;

  @override
  CancelToken? get cancelToken => cancellationToken;

  @override
  void Function(int p1, int p2)? get onSendProgress => onProgress;
}

class DropboxDownloadEndpoint extends DownloadEndpoint {
  final String filePath;
  final String? storagePath;
  final void Function(int chunk, int length)? onProgress;
  final CancelToken? cancellationToken;

  const DropboxDownloadEndpoint({
    required this.filePath,
    this.storagePath,
    this.cancellationToken,
    this.onProgress,
  });

  @override
  String get baseUrl => BaseURL.dropboxContentV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/files/download';

  @override
  Map<String, dynamic> get headers => {
        'Dropbox-API-Arg': jsonEncode({
          'path': filePath,
        }),
      };

  @override
  CancelToken? get cancelToken => cancellationToken;

  @override
  void Function(int p1, int p2)? get onReceiveProgress => onProgress;

  @override
  String? get storePath => storagePath;
}

class DropboxDeleteEndpoint extends Endpoint {
  final String id;
  final CancelToken? cancellationToken;

  const DropboxDeleteEndpoint({
    required this.id,
    this.cancellationToken,
  });

  @override
  String get baseUrl => BaseURL.dropboxV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/files/delete_v2';

  @override
  Map<String, dynamic> get data => {
        'path': id,
      };

  @override
  CancelToken? get cancelToken => cancellationToken;
}

class DropboxUpdateAppPropertyEndpoint extends Endpoint {
  final String id;
  final String appPropertyTemplateId;
  final String localRefId;
  final CancelToken? cancellationToken;

  const DropboxUpdateAppPropertyEndpoint({
    required this.id,
    required this.appPropertyTemplateId,
    required this.localRefId,
    this.cancellationToken,
  });

  @override
  String get baseUrl => BaseURL.dropboxV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/file_properties/properties/overwrite';

  @override
  Map<String, dynamic> get data => {
        "path": id,
        "property_groups": [
          {
            "fields": [
              {
                "name": ProviderConstants.localRefIdKey,
                "value": localRefId,
              }
            ],
            "template_id": appPropertyTemplateId,
          }
        ],
      };

  @override
  CancelToken? get cancelToken => cancellationToken;
}

class DropboxGetFileMetadata extends Endpoint {
  final String id;

  const DropboxGetFileMetadata({required this.id});

  @override
  String get baseUrl => BaseURL.dropboxV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/files/get_metadata';

  @override
  Map<String, dynamic> get data => {
        "include_media_info": true,
        'path': id,
      };
}
