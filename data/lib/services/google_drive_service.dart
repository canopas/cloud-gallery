import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import '../apis/google_drive/google_drive_endpoint.dart';
import '../apis/network/client.dart';
import '../domain/config.dart';
import '../models/album/album.dart';
import '../models/media/media.dart';
import '../models/media_content/media_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import '../errors/app_error.dart';
import 'base/cloud_provider_service.dart';

final googleDriveServiceProvider = Provider<GoogleDriveService>(
  (ref) => GoogleDriveService(
    ref.read(googleAuthenticatedDioProvider),
  ),
);

class GoogleDriveService extends CloudProviderService {
  final Dio _client;

  GoogleDriveService(this._client);

  // FOLDERS -------------------------------------------------------------------

  Future<String?> getBackUpFolderId() async {
    final res = await _client.req(
      GoogleDriveListEndpoint(
        q: "name='${ProviderConstants.backupFolderName}' and trashed=false and mimeType='application/vnd.google-apps.folder'",
        pageSize: 1,
      ),
    );

    if (res.statusCode == 200) {
      final body = drive.FileList.fromJson(res.data);
      if (body.files?.isNotEmpty ?? false) {
        return body.files?.first.id;
      } else {
        final createRes = await _client.req(
          GoogleDriveCreateFolderEndpoint(
            name: ProviderConstants.backupFolderName,
          ),
        );

        if (createRes.statusCode == 200) {
          return drive.File.fromJson(createRes.data).id;
        }

        throw SomethingWentWrongError(
          statusCode: createRes.statusCode,
          message: createRes.statusMessage,
        );
      }
    }

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  @override
  Future<String?> createFolder(String folderName) async {
    final res = await _client.req(
      GoogleDriveCreateFolderEndpoint(name: folderName),
    );

    if (res.statusCode == 200) {
      return drive.File.fromJson(res.data).id;
    }

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  // MEDIA ---------------------------------------------------------------------

  @override
  Future<List<AppMedia>> getAllMedias({
    required String folder,
  }) async {
    bool hasMore = true;
    String? pageToken;
    final List<AppMedia> medias = [];

    while (hasMore) {
      final res = await _client.req(
        GoogleDriveListEndpoint(
          q: "'$folder' in parents and trashed=false and name!='${ProviderConstants.albumFileName}'",
          pageSize: 1000,
          pageToken: pageToken,
        ),
      );

      if (res.statusCode == 200) {
        final body = drive.FileList.fromJson(res.data);
        hasMore = body.nextPageToken != null;
        pageToken = body.nextPageToken;
        medias.addAll(
          body.files
                  ?.map(
                    (e) => AppMedia.fromGoogleDriveFile(e),
                  )
                  .toList() ??
              <AppMedia>[],
        );
      } else {
        throw SomethingWentWrongError(
          statusCode: res.statusCode,
          message: res.statusMessage,
        );
      }
    }

    return medias;
  }

  @override
  Future<GetPaginatedMediasResponse> getPaginatedMedias({
    required String folder,
    String? nextPageToken,
    int pageSize = 30,
  }) async {
    final res = await _client.req(
      GoogleDriveListEndpoint(
        q: "'$folder' in parents and trashed=false and name!='${ProviderConstants.albumFileName}'",
        pageSize: pageSize,
        pageToken: nextPageToken,
      ),
    );

    if (res.statusCode == 200) {
      final body = drive.FileList.fromJson(res.data);
      return GetPaginatedMediasResponse(
        nextPageToken: body.nextPageToken,
        medias: body.files
                ?.map(
                  (e) => AppMedia.fromGoogleDriveFile(e),
                )
                .toList() ??
            <AppMedia>[],
      );
    }

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  Future<AppMedia?> getMedia({
    required String id,
  }) async {
    try {
      final res = await _client.req(GoogleDriveGetEndpoint(id: id));

      if (res.statusCode == 200) {
        return AppMedia.fromGoogleDriveFile(drive.File.fromJson(res.data));
      }

      throw SomethingWentWrongError(
        statusCode: res.statusCode,
        message: res.statusMessage,
      );
    } catch (e) {
      if (e is DioException &&
          (e.response?.statusCode == 404 || e.response?.statusCode == 409)) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteMedia({
    required String id,
    CancelToken? cancelToken,
  }) async {
    final res = await _client.req(GoogleDriveDeleteEndpoint(id: id));

    if (res.statusCode == 200 || res.statusCode == 204) return;

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  @override
  Future<AppMedia> uploadMedia({
    required String folderId,
    required String path,
    String? localRefId,
    String? mimeType,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
  }) async {
    final localFile = File(path);
    final file = drive.File(
      name: localFile.path.split('/').last,
      mimeType: mimeType,
      appProperties: {
        ProviderConstants.localRefIdKey: localRefId,
      },
      parents: [folderId],
    );

    final res = await _client.req(
      GoogleDriveUploadEndpoint(
        request: file,
        content: AppMediaContent(
          stream: localFile.openRead(),
          length: localFile.lengthSync(),
          type: 'application/octet-stream',
        ),
        onProgress: onProgress,
        cancellationToken: cancelToken,
      ),
    );

    if (res.statusCode == 200) {
      return AppMedia.fromGoogleDriveFile(drive.File.fromJson(res.data));
    }

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  Future<String> startUploadSession({
    required String folderId,
    required String path,
    String? localRefId,
    String? mimeType,
    CancelToken? cancelToken,
  }) async {
    final localFile = File(path);
    final file = drive.File(
      name: localFile.path.split('/').last,
      mimeType: mimeType,
      appProperties: {
        ProviderConstants.localRefIdKey: localRefId,
      },
      parents: [folderId],
    );
    final res =
        await _client.req(GoogleDriveStartUploadEndpoint(request: file));

    if (res.statusCode == 200) {
      return Uri.parse(res.headers.value('location')!)
          .queryParameters['upload_id']!;
    }

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  Future<AppMedia?> appendUploadSession({
    required String uploadId,
    required String path,
    required int startByte,
    required int endByte,
    CancelToken? cancelToken,
    void Function(int, int)? onProgress,
  }) async {
    final File file = File(path);

    if (!file.existsSync()) {
      throw SomethingWentWrongError(
        statusCode: 404,
        message: 'File not found',
      );
    }

    try {
      final res = await _client.req(
        GoogleDriveAppendUploadEndpoint(
          uploadId: uploadId,
          content: AppMediaContent(
            stream: file.openRead(startByte, endByte),
            length: endByte - startByte,
            type: 'application/octet-stream',
            range: 'bytes $startByte-${endByte - 1}/${file.lengthSync()}',
          ),
          onProgress: onProgress,
          cancellationToken: cancelToken,
        ),
      );

      if (res.statusCode == 200) {
        return AppMedia.fromGoogleDriveFile(drive.File.fromJson(res.data));
      } else if (res.statusCode == 308) {
        return null;
      }

      throw SomethingWentWrongError(
        statusCode: res.statusCode,
        message: res.statusMessage,
      );
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 308) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<void> downloadMedia({
    required String id,
    required String saveLocation,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
  }) async {
    final res = await _client.downloadReq(
      GoogleDriveDownloadEndpoint(
        id: id,
        cancellationToken: cancelToken,
        saveLocation: saveLocation,
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
    final res = await _client.req(
      GoogleDriveUpdateAppPropertiesEndpoint(
        id: id,
        localFileId: localRefId,
      ),
    );

    if (res.statusCode == 200) return;

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  //ALBUMS ---------------------------------------------------------------------

  Future<List<Album>> getAlbums({required String folderId}) async {
    final res = await _client.req(
      GoogleDriveListEndpoint(
        q: "'$folderId' in parents and trashed=false and name='${ProviderConstants.albumFileName}'",
        pageSize: 1,
      ),
    );

    if (res.statusCode == 200) {
      final body = drive.FileList.fromJson(res.data);
      if ((body.files ?? []).isNotEmpty) {
        final res = await _client.req(
          GoogleDriveDownloadEndpoint(id: body.files!.first.id!),
        );
        if (res.statusCode == 200) {
          final List<int> bytes = [];
          await for (final chunk in (res.data as ResponseBody).stream) {
            bytes.addAll(chunk);
          }
          final json = jsonDecode(utf8.decode(bytes));
          return json is! List
              ? <Album>[]
              : json.map((e) => Album.fromJson(e)).toList();
        }

        throw SomethingWentWrongError(
          statusCode: res.statusCode,
          message: res.statusMessage,
        );
      }
      return <Album>[];
    }

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  Future<void> createAlbum({
    required String folderId,
    required Album newAlbum,
  }) async {
    // Fetch the album file
    final listRes = await _client.req(
      GoogleDriveListEndpoint(
        q: "'$folderId' in parents and trashed=false and name='${ProviderConstants.albumFileName}'",
        pageSize: 1,
      ),
    );

    if (listRes.statusCode != 200) {
      throw SomethingWentWrongError(
        statusCode: listRes.statusCode,
        message: listRes.statusMessage,
      );
    }

    final body = drive.FileList.fromJson(listRes.data);

    if ((body.files ?? []).isNotEmpty) {
      // Download the album file if it exists
      final res = await _client.req(
        GoogleDriveDownloadEndpoint(id: body.files!.first.id!),
      );

      if (res.statusCode != 200) {
        throw SomethingWentWrongError(
          statusCode: res.statusCode,
          message: res.statusMessage,
        );
      }

      // Convert the downloaded album file to a list of albums
      final List<int> bytes = [];
      await for (final chunk in (res.data as ResponseBody).stream) {
        bytes.addAll(chunk);
      }
      final json = jsonDecode(utf8.decode(bytes));
      final albums = json is! List
          ? <Album>[]
          : json.map((e) => Album.fromJson(e)).toList();

      // Attach the new album to the list of albums
      albums.add(newAlbum);
      albums.sort((a, b) => a.created_at.compareTo(b.created_at));

      // Update the album file with the new list of albums
      final updateRes = await _client.req(
        GoogleDriveContentUpdateEndpoint(
          id: body.files!.first.id!,
          content: AppMediaContent(
            stream: Stream.value(
              Uint8List.fromList(utf8.encode(jsonEncode(albums))),
            ),
            length: utf8.encode(jsonEncode(albums)).length,
            type: 'application/json',
          ),
        ),
      );

      if (updateRes.statusCode == 200) return;

      throw SomethingWentWrongError(
        statusCode: updateRes.statusCode,
        message: updateRes.statusMessage,
      );
    }

    // Create a new album file if it doesn't exist
    final res = await _client.req(
      GoogleDriveUploadEndpoint(
        request: drive.File(
          name: ProviderConstants.albumFileName,
          mimeType: 'application/json',
          parents: [folderId],
        ),
        content: AppMediaContent(
          stream: Stream.value(
            Uint8List.fromList(utf8.encode(jsonEncode([newAlbum.toJson()]))),
          ),
          length: utf8.encode(jsonEncode([newAlbum.toJson()])).length,
          type: 'application/json',
        ),
      ),
    );

    if (res.statusCode == 200) return;

    throw SomethingWentWrongError(
      statusCode: res.statusCode,
      message: res.statusMessage,
    );
  }

  Future<void> updateAlbum({
    required String folderId,
    required Album album,
  }) async {
    // Fetch the album file
    final listRes = await _client.req(
      GoogleDriveListEndpoint(
        q: "'$folderId' in parents and trashed=false and name='${ProviderConstants.albumFileName}'",
        pageSize: 1,
      ),
    );

    if (listRes.statusCode != 200) {
      throw SomethingWentWrongError(
        statusCode: listRes.statusCode,
        message: listRes.statusMessage,
      );
    }

    final body = drive.FileList.fromJson(listRes.data);

    if ((body.files ?? []).isNotEmpty) {
      // Download the album file if it exists
      final res = await _client.req(
        GoogleDriveDownloadEndpoint(id: body.files!.first.id!),
      );

      if (res.statusCode != 200) {
        throw SomethingWentWrongError(
          statusCode: res.statusCode,
          message: res.statusMessage,
        );
      }

      // Convert the downloaded album file to a list of albums
      final List<int> bytes = [];
      await for (final chunk in (res.data as ResponseBody).stream) {
        bytes.addAll(chunk);
      }
      final json = jsonDecode(utf8.decode(bytes));
      final albums = json is! List
          ? <Album>[]
          : json.map((e) => Album.fromJson(e)).toList();

      // Attach the new album to the list of albums
      if (albums.where((element) => element.id == album.id).isEmpty) {
        throw SomethingWentWrongError(
          message: 'Album not found',
        );
      }

      albums.removeWhere((element) => element.id == album.id);
      albums.add(album);
      albums.sort((a, b) => a.created_at.compareTo(b.created_at));

      // Update the album file with the new list of albums
      final updateRes = await _client.req(
        GoogleDriveContentUpdateEndpoint(
          id: body.files!.first.id!,
          content: AppMediaContent(
            stream: Stream.value(
              Uint8List.fromList(utf8.encode(jsonEncode(albums))),
            ),
            length: utf8.encode(jsonEncode(albums)).length,
            type: 'application/json',
          ),
        ),
      );

      if (updateRes.statusCode == 200) return;

      throw SomethingWentWrongError(
        statusCode: updateRes.statusCode,
        message: updateRes.statusMessage,
      );
    }

    throw SomethingWentWrongError(
      message: 'Album file not found',
    );
  }

  Future<void> removeAlbum({
    required String folderId,
    required String id,
  }) async {
    // Fetch the album file
    final listRes = await _client.req(
      GoogleDriveListEndpoint(
        q: "'$folderId' in parents and trashed=false and name='${ProviderConstants.albumFileName}'",
        pageSize: 1,
      ),
    );

    if (listRes.statusCode != 200) {
      throw SomethingWentWrongError(
        statusCode: listRes.statusCode,
        message: listRes.statusMessage,
      );
    }

    final body = drive.FileList.fromJson(listRes.data);

    if ((body.files ?? []).isNotEmpty) {
      // Download the album file if it exists
      final res = await _client.req(
        GoogleDriveDownloadEndpoint(id: body.files!.first.id!),
      );

      if (res.statusCode != 200) {
        throw SomethingWentWrongError(
          statusCode: res.statusCode,
          message: res.statusMessage,
        );
      }

      // Convert the downloaded album file to a list of albums
      final List<int> bytes = [];
      await for (final chunk in (res.data as ResponseBody).stream) {
        bytes.addAll(chunk);
      }
      final json = jsonDecode(utf8.decode(bytes));
      final albums = json is! List
          ? <Album>[]
          : json.map((e) => Album.fromJson(e)).toList();

      // Attach the new album to the list of albums
      albums.removeWhere((element) => element.id == id);

      // Update the album file with the new list of albums
      final updateRes = await _client.req(
        GoogleDriveContentUpdateEndpoint(
          id: body.files!.first.id!,
          content: AppMediaContent(
            stream: Stream.value(
              Uint8List.fromList(utf8.encode(jsonEncode(albums))),
            ),
            length: utf8.encode(jsonEncode(albums)).length,
            type: 'application/json',
          ),
        ),
      );

      if (updateRes.statusCode == 200) return;

      throw SomethingWentWrongError(
        statusCode: updateRes.statusCode,
        message: updateRes.statusMessage,
      );
    }

    throw SomethingWentWrongError(
      message: 'Album file not found',
    );
  }
}
