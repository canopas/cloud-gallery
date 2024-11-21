import 'dart:convert';
import 'package:dio/dio.dart';
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
  final bool includeHasExplicitSharedMembers;
  final bool includeMediaInfo;
  final bool includeMountedFolders;
  final bool includeNonDownloadableFiles;
  final String folderPath;
  final bool recursive;

  const DropboxListFolderEndpoint({
    this.includeDeleted = false,
    this.includeHasExplicitSharedMembers = false,
    this.includeMediaInfo = false,
    this.includeMountedFolders = false,
    this.includeNonDownloadableFiles = false,
    this.recursive = false,
    required this.folderPath,
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
        "include_media_info": includeMediaInfo,
        "include_mounted_folders": includeMountedFolders,
        "include_non_downloadable_files": includeNonDownloadableFiles,
        "path": folderPath,
        "recursive": recursive,
      };
}

class DropboxUploadEndpoint extends Endpoint {
  final String filePath;
  final String mode;
  final bool autoRename;
  final bool mute;
  final bool strictConflict;
  final Stream<List<int>> contentStream;
  final void Function(int chunk, int length)? onProgress;
  final CancelToken? cancellationToken;

  const DropboxUploadEndpoint({
    required this.filePath,
    this.mode = 'add',
    this.autoRename = true,
    this.mute = false,
    this.strictConflict = false,
    this.cancellationToken,
    this.onProgress,
    required this.contentStream,
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
        }),
        'Content-Type': 'application/octet-stream',
      };

  @override
  Object? get data => contentStream;

  @override
  CancelToken? get cancelToken => cancellationToken;

  @override
  void Function(int p1, int p2)? get onSendProgress => onProgress;
}

class DropboxDownloadEndpoint extends DownloadEndpoint {
  final String filePath;
  final String storagePath;
  final void Function(int chunk, int length)? onProgress;
  final CancelToken? cancellationToken;

  const DropboxDownloadEndpoint({
    required this.filePath,
    required this.storagePath,
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

