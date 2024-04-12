import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media_content/media_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import '../errors/app_error.dart';

final localMediaServiceProvider = Provider<LocalMediaService>(
  (ref) => const LocalMediaService(),
);

class LocalMediaService {
  const LocalMediaService();


  Future<bool> isLocalFileExist({required AppMediaType type, required String id}) async {
     return await AssetEntity(id: id, typeInt: type.index, width: 0, height: 0).isLocallyAvailable();
  }

  Future<bool> requestPermission() async {
    final state = await PhotoManager.requestPermissionExtend();
    return state.hasAccess;
  }

  Future<int> getMediaCount() async {
    return await PhotoManager.getAssetCount(
      filterOption: FilterOptionGroup(
        orders: [const OrderOption(type: OrderOptionType.createDate)],
      ),
    );
  }

  Future<List<AppMedia>> getLocalMedia(
      {required int start, required int end}) async {
    try {
      final assets = await PhotoManager.getAssetListRange(
        start: start,
        end: end,
        filterOption: FilterOptionGroup(
          orders: [const OrderOption(type: OrderOptionType.createDate)],
        ),
      );
      final files = await Future.wait(
        assets.map(
          (asset) => AppMedia.fromAssetEntity(asset),
        ),
      );
      return files.whereNotNull().toList();
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  Future<List<String>> deleteMedias(List<String> medias) async {
    try {
      return await PhotoManager.editor.deleteWithIds(medias);
    } catch (e) {
      throw AppError.fromError(e);
    }
  }

  Future<AppMedia?> saveMedia({
    required AppMediaType type,
    required String? mimeType,
    required AppMediaContent content,
    required void Function(int total, int chunk) onProgress,
  }) async {
    try {
      final extension = mimeType?.trim().isNotEmpty ?? false
          ? mimeType!.split('/').last
          : type.isVideo
              ? 'mp4'
              : 'jpg';

      AssetEntity? asset;

      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
          '${tempDir.path}${DateTime.now()}_gd_cloud_gallery_temp.$extension');
      await tempFile.create();

      int chunkLength = 0;

      StreamSubscription<List<int>> subscription =
          content.stream.listen((chunk) {
        chunkLength += chunk.length;
        onProgress(content.length ?? 0, chunkLength);
        tempFile.writeAsBytesSync(chunk, mode: FileMode.append);
      });
      await subscription.asFuture();
      subscription.cancel();

      if (type.isVideo) {
        asset = await PhotoManager.editor.saveVideo(
          tempFile,
          title: "${DateTime.now()}_gd_cloud_gallery.$extension",
        );
      } else if (type.isImage) {
        asset = await PhotoManager.editor.saveImageWithPath(
          tempFile.path,
          title: "${DateTime.now()}_gd_cloud_gallery.$extension",
        );
      }
      await tempFile.delete();
      return asset != null ? AppMedia.fromAssetEntity(asset) : null;
    } catch (e) {
      throw AppError.fromError(e);
    }
  }
}
