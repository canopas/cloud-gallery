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
