import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import '../apis/dropbox/dropbox_content_endpoints.dart';
import '../apis/network/client.dart';
import '../domain/config.dart';
import '../errors/app_error.dart';
import '../models/album/album.dart';
import '../models/dropbox/account/dropbox_account.dart';
import '../models/media/media.dart';
import '../models/media_content/media_content.dart';
import '../storage/app_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../apis/dropbox/dropbox_auth_endpoints.dart';
import '../storage/provider/preferences_provider.dart';
import 'base/cloud_provider_service.dart';

final dropboxServiceProvider = Provider<DropboxService>((ref) {
  return DropboxService(
    ref.read(dropboxAuthenticatedDioProvider),
    ref.read(AppPreferences.dropboxCurrentUserAccount.notifier),
    ref.read(AppPreferences.dropboxFileIdAppPropertyTemplateId.notifier),
  );
});

class DropboxService extends CloudProviderService {
  final Dio _dropboxAuthenticatedDio;
  final PreferenceNotifier<DropboxAccount?> _dropboxAccountController;
  final PreferenceNotifier<String?>
      _dropboxFileIdAppPropertyTemplateIdController;

  const DropboxService(
    this._dropboxAuthenticatedDio,
    this._dropboxAccountController,
    this._dropboxFileIdAppPropertyTemplateIdController,
  );

  Future<void> setCurrentUserAccount() async {
    final res = await _dropboxAuthenticatedDio
        .req(const DropboxGetUserAccountEndpoint());
    if (res.statusCode == 200) {
      _dropboxAccountController.state = DropboxAccount.fromJson(res.data);
    } else {
      throw SomethingWentWrongError(
        statusCode: res.statusCode,
        message: res.statusMessage,
      );
    }
  }

  //MEDIA ----------------------------------------------------------------------

  Future<void> setFileIdAppPropertyTemplate() async {
    // Get all the app property templates
    final res = await _dropboxAuthenticatedDio
        .req(const DropboxGetAppPropertyTemplate());

    if (res.statusCode == 200) {
      final templateIds = res.data['template_ids'] as List;

      // Find the template id for the app
      String? appTemplateId;
      for (final templateId in templateIds) {
        final res = await _dropboxAuthenticatedDio.req(
          DropboxGetAppPropertiesTemplateDetails(templateId),
        );

        if (res.statusCode == 200 &&
            res.data?['name'] == ProviderConstants.dropboxAppTemplateName) {
          appTemplateId = templateId;
          break;
        } else {
          throw SomethingWentWrongError(
            statusCode: res.statusCode,
            message: res.statusMessage,
          );
        }
      }

      // If the template id is found, set it else create a new one
      if (appTemplateId != null) {
        _dropboxFileIdAppPropertyTemplateIdController.state = appTemplateId;
      } else {
        final res = await _dropboxAuthenticatedDio.req(
          DropboxCreateAppPropertyTemplate(),
        );
        if (res.statusCode == 200) {
          _dropboxFileIdAppPropertyTemplateIdController.state =
              res.data['template_id'];
        } else {
          throw SomethingWentWrongError(
            statusCode: res.statusCode,
            message: res.statusMessage,
          );
        }
      }
    } else {
      throw SomethingWentWrongError(
        statusCode: res.statusCode,
        message: res.statusMessage,
      );
    }
  }

  @override
  Future<List<AppMedia>> getAllMedias({
    required String folder,
  }) async {
    try {
      if (_dropboxFileIdAppPropertyTemplateIdController.state == null) {
        await setFileIdAppPropertyTemplate();
      }
      bool hasMore = true;
      String? nextPageToken;
      final List<AppMedia> medias = [];

      while (hasMore) {
        final response = await _dropboxAuthenticatedDio.req(
          nextPageToken == null
              ? DropboxListFolderEndpoint(
                  folderPath: folder,
                  limit: 2000,
                  appPropertyTemplateId:
                      _dropboxFileIdAppPropertyTemplateIdController.state!,
                )
              : DropboxListFolderContinueEndpoint(cursor: nextPageToken),
        );
        if (response.statusCode == 200) {
          hasMore = response.data['has_more'] == true;
          nextPageToken = response.data['cursor'];
          medias.addAll(
            (response.data['entries'] as List)
                .where(
                  (element) =>
                      element['.tag'] == 'file' &&
                      element['name'] != 'Albums.json',
                )
                .map((e) => AppMedia.fromDropboxJson(json: e))
                .toList(),
          );
        } else {
          throw SomethingWentWrongError(
            statusCode: response.statusCode,
            message: response.statusMessage,
          );
        }
      }

      return medias;
    } catch (e) {
      if (e is DioException &&
          e.response?.statusCode == 409 &&
          e.response?.data?['error']?['path']?['.tag'] == 'not_found') {
        await createFolder(ProviderConstants.backupFolderName);
        return getAllMedias(folder: folder);
      }
      rethrow;
    }
  }

  @override
  Future<GetPaginatedMediasResponse> getPaginatedMedias({
    required String folder,
    String? nextPageToken,
    int pageSize = 30,
  }) async {
    if (_dropboxFileIdAppPropertyTemplateIdController.state == null) {
      await setFileIdAppPropertyTemplate();
    }
    try {
      final response = await _dropboxAuthenticatedDio.req(
        nextPageToken == null
            ? DropboxListFolderEndpoint(
                folderPath: folder,
                limit: pageSize,
                appPropertyTemplateId:
                    _dropboxFileIdAppPropertyTemplateIdController.state!,
              )
            : DropboxListFolderContinueEndpoint(cursor: nextPageToken),
      );
      if (response.statusCode == 200) {
        final files = (response.data['entries'] as List).where(
          (element) =>
              element['.tag'] == 'file' && element['name'] != 'Albums.json',
        );

        final metadataResponses = await Future.wait(
          files.map(
            (e) => _dropboxAuthenticatedDio.req(
              DropboxGetFileMetadata(id: e['id']),
            ),
          ),
        );

        return GetPaginatedMediasResponse(
          medias: files
              .map(
                (e) => AppMedia.fromDropboxJson(
                  json: e,
                  metadataJson: metadataResponses
                      .firstWhereOrNull(
                        (m) => m.statusCode == 200 && m.data['id'] == e['id'],
                      )
                      ?.data,
                ),
              )
              .toList(),
          nextPageToken: response.data['has_more'] == true
              ? response.data['cursor']
              : null,
        );
      }
      throw SomethingWentWrongError(
        statusCode: response.statusCode,
        message: response.statusMessage ?? '',
      );
    } catch (e) {
      if (e is DioException &&
          e.response?.statusCode == 409 &&
          e.response?.data?['error']?['path']?['.tag'] == 'not_found') {
        await createFolder(ProviderConstants.backupFolderName);
        return getPaginatedMedias(
          folder: folder,
          nextPageToken: nextPageToken,
          pageSize: pageSize,
        );
      }
      rethrow;
    }
  }

  Future<AppMedia?> getMedia({
    required String id,
  }) async {
    try {
      final res = await _dropboxAuthenticatedDio.req(
        DropboxGetFileMetadata(id: id),
      );

      if (res.statusCode == 200) {
        return AppMedia.fromDropboxJson(json: res.data, metadataJson: res.data);
      }
      throw SomethingWentWrongError(
        statusCode: res.statusCode,
        message: res.statusMessage ?? '',
      );
    } catch (e) {
      if (e is DioException &&
          (e.response?.statusCode == 409 || e.response?.statusCode == 404)) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<String> createFolder(String folderName) async {
    final response = await _dropboxAuthenticatedDio.req(
      DropboxCreateFolderEndpoint(name: folderName),
    );

    if (response.statusCode == 200) {
      return response.data['metadata']['id'];
    }

    throw SomethingWentWrongError(
      statusCode: response.statusCode,
      message: response.statusMessage,
    );
  }

  @override
  Future<AppMedia> uploadMedia({
    required String folderId,
    required String path,
    String? mimeType,
    String? localRefId,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
  }) async {
    if (_dropboxFileIdAppPropertyTemplateIdController.state == null) {
      await setFileIdAppPropertyTemplate();
    }
    final localFile = File(path);

    final res = await _dropboxAuthenticatedDio.req(
      DropboxUploadEndpoint(
        appPropertyTemplateId:
            _dropboxFileIdAppPropertyTemplateIdController.state!,
        localRefId: localRefId,
        content: AppMediaContent(
          stream: localFile.openRead(),
          length: localFile.lengthSync(),
          type: 'application/octet-stream',
        ),
        filePath:
            "/${ProviderConstants.backupFolderName}/${localFile.path.split('/').last}",
        onProgress: onProgress,
        cancellationToken: cancelToken,
      ),
    );

    if (res.statusCode == 200) {
      // Get the metadata of the uploaded file
      try {
        final metadata = await _dropboxAuthenticatedDio.req(
          DropboxGetFileMetadata(id: res.data['id']),
        );

        if (metadata.statusCode == 200) {
          return AppMedia.fromDropboxJson(
            json: res.data,
            metadataJson: metadata.data,
          );
        }
      } catch (_) {}

      // If metadata is not available, return the uploaded file
      return AppMedia.fromDropboxJson(json: res.data);
    }
    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  Future<String> startUploadSession({
    required String path,
    required int startByte,
    required int endByte,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
  }) async {
    final file = File(path);

    if (file.existsSync() == false) {
      throw SomethingWentWrongError(
        statusCode: 404,
        message: 'File not found',
      );
    }

    final res = await _dropboxAuthenticatedDio.req(
      DropboxStartUploadEndpoint(
        onProgress: onProgress,
        cancellationToken: cancelToken,
        content: AppMediaContent(
          stream: file.openRead(startByte, endByte),
          length: endByte - startByte,
          type: 'application/octet-stream',
        ),
      ),
    );

    if (res.statusCode == 200) {
      return res.data['session_id'];
    }

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  Future<void> appendUploadSession({
    required String sessionId,
    required String path,
    required int startByte,
    required int endByte,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
  }) async {
    final file = File(path);

    if (file.existsSync() == false) {
      throw SomethingWentWrongError(
        statusCode: 404,
        message: 'File not found',
      );
    }

    final res = await _dropboxAuthenticatedDio.req(
      DropboxAppendUploadEndpoint(
        offset: startByte,
        sessionId: sessionId,
        cancellationToken: cancelToken,
        onProgress: onProgress,
        content: AppMediaContent(
          stream: file.openRead(startByte, endByte),
          length: endByte - startByte,
          type: 'application/octet-stream',
        ),
      ),
    );

    if (res.statusCode == 200) return;

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  Future<AppMedia> finishUploadSession({
    required String sessionId,
    required String path,
    required int startByte,
    required int endByte,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
    required String localRefId,
  }) async {
    final file = File(path);

    if (file.existsSync() == false) {
      throw SomethingWentWrongError(
        statusCode: 404,
        message: 'File not found',
      );
    }

    final res = await _dropboxAuthenticatedDio.req(
      DropboxFinishUploadEndpoint(
        filePath:
            "/${ProviderConstants.backupFolderName}/${file.path.split('/').last}",
        localRefId: localRefId,
        appPropertyTemplateId:
            _dropboxFileIdAppPropertyTemplateIdController.state!,
        offset: startByte,
        sessionId: sessionId,
        cancellationToken: cancelToken,
        onProgress: onProgress,
        content: AppMediaContent(
          stream: file.openRead(startByte, endByte),
          length: endByte - startByte,
          type: 'application/octet-stream',
        ),
      ),
    );

    if (res.statusCode == 200) {
      return AppMedia.fromDropboxJson(json: res.data, metadataJson: res.data);
    }

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  @override
  Future<void> downloadMedia({
    required String id,
    required String saveLocation,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
  }) async {
    final res = await _dropboxAuthenticatedDio.downloadReq(
      DropboxDownloadEndpoint(
        filePath: id,
        storagePath: saveLocation,
        cancellationToken: cancelToken,
        onProgress: onProgress,
      ),
    );

    if (res.statusCode == 200) return;

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  Future<void> updateAppProperties({
    required String id,
    required String localRefId,
    CancelToken? cancelToken,
  }) async {
    final res = await _dropboxAuthenticatedDio.req(
      DropboxUpdateAppPropertyEndpoint(
        id: id,
        cancellationToken: cancelToken,
        appPropertyTemplateId:
            _dropboxFileIdAppPropertyTemplateIdController.state!,
        localRefId: localRefId,
      ),
    );

    if (res.statusCode == 200) return;

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  @override
  Future<void> deleteMedia({
    required String id,
    CancelToken? cancelToken,
  }) async {
    final res = await _dropboxAuthenticatedDio.req(
      DropboxDeleteEndpoint(
        id: id,
        cancellationToken: cancelToken,
      ),
    );
    if (res.statusCode == 200) return;

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  // ALBUM ---------------------------------------------------------------------

  Future<List<Album>> getAlbums() async {
    try {
      final res = await _dropboxAuthenticatedDio.req(
        DropboxDownloadEndpoint(
          filePath: "/${ProviderConstants.backupFolderName}/Albums.json",
        ),
      );
      if (res.statusCode != 200 || res.data is! ResponseBody) {
        throw SomethingWentWrongError(
          statusCode: res.statusCode,
          message: res.statusMessage,
        );
      }
      final List<int> bytes = [];
      await for (final chunk in (res.data as ResponseBody).stream) {
        bytes.addAll(chunk);
      }
      final json = jsonDecode(utf8.decode(bytes));
      return json is! List
          ? <Album>[]
          : json.map((e) => Album.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 409) {
        return <Album>[];
      }
      rethrow;
    }
  }

  Future<void> createAlbum(Album album) async {
    final albums = await getAlbums();
    albums.add(album);
    albums.sort((a, b) => b.created_at.compareTo(a.created_at));

    final res = await _dropboxAuthenticatedDio.req(
      DropboxUploadEndpoint(
        mode: 'overwrite',
        autoRename: false,
        content: AppMediaContent(
          stream: Stream.value(utf8.encode(jsonEncode(albums))),
          length: utf8.encode(jsonEncode(albums)).length,
          type: 'application/octet-stream',
        ),
        filePath: "/${ProviderConstants.backupFolderName}/Albums.json",
      ),
    );

    if (res.statusCode == 200) return;

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  Future<void> deleteAlbum(String id) async {
    final albums = await getAlbums();
    albums.removeWhere((a) => a.id == id);

    final res = await _dropboxAuthenticatedDio.req(
      DropboxUploadEndpoint(
        mode: 'overwrite',
        autoRename: false,
        content: AppMediaContent(
          stream: Stream.value(utf8.encode(jsonEncode(albums))),
          length: utf8.encode(jsonEncode(albums)).length,
          type: 'application/octet-stream',
        ),
        filePath: "/${ProviderConstants.backupFolderName}/Albums.json",
      ),
    );

    if (res.statusCode == 200) return;

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  Future<void> updateAlbum(Album album) async {
    final albums = await getAlbums();
    final index = albums.indexWhere((a) => a.id == album.id);
    if (index == -1) {
      throw SomethingWentWrongError(
        statusCode: 404,
        message: 'Album not found',
      );
    }

    albums[index] = album;
    albums.sort((a, b) => b.created_at.compareTo(a.created_at));

    final res = await _dropboxAuthenticatedDio.req(
      DropboxUploadEndpoint(
        mode: 'overwrite',
        autoRename: false,
        content: AppMediaContent(
          stream: Stream.value(utf8.encode(jsonEncode(albums))),
          length: utf8.encode(jsonEncode(albums)).length,
          type: 'application/octet-stream',
        ),
        filePath: "/${ProviderConstants.backupFolderName}/Albums.json",
      ),
    );

    if (res.statusCode == 200) return;

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }
}
