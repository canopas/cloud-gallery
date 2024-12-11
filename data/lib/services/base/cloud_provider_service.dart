import 'package:dio/dio.dart';
import '../../models/media/media.dart';

abstract class CloudProviderService {
  const CloudProviderService();

  Future<String?> createFolder(String folderName);

  Future<AppMedia> uploadMedia({
    required String folderId,
    required String path,
    String? mimeType,
    String? localRefId,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
  });

  Future<void> downloadMedia({
    required String id,
    required String saveLocation,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onProgress,
  });

  Future<void> deleteMedia({
    required String id,
    CancelToken? cancelToken,
  });

  Future<GetPaginatedMediasResponse> getPaginatedMedias({
    required String folder,
    String? nextPageToken,
    int pageSize = 30,
  });

  Future<List<AppMedia>> getAllMedias({
    required String folder,
  });
}

class GetPaginatedMediasResponse {
  final List<AppMedia> medias;
  final String? nextPageToken;

  const GetPaginatedMediasResponse({
    required this.medias,
    this.nextPageToken,
  });
}
