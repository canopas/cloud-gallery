import 'package:dio/dio.dart';
import '../models/media/media.dart';

abstract class CloudProviderService {
  const CloudProviderService();

  Future<String?> createFolder(String folderName);

  Future<String?> getBackUpFolderId();

  Future<AppMedia> uploadMedia({
    required String folderId,
    required String path,
    String? mimeType,
    String? description,
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
}
