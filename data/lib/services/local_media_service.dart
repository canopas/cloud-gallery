import 'dart:io';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import '../errors/app_error.dart';

final localMediaServiceProvider = Provider<LocalMediaService>(
  (ref) => const LocalMediaService(),
);

class LocalMediaService {
  const LocalMediaService();

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

  Future<AppMedia?> saveMedia(AppMedia media, Uint8List bytes) async {
    final extension = media.mimeType?.trim().isNotEmpty ?? false
        ? media.mimeType!.split('/').last
        : media.type.isVideo
            ? 'mp4'
            : 'jpg';
    AssetEntity? asset;
    if (media.type.isVideo) {
      final tempDir = await getTemporaryDirectory();
      final tempVideoFile = File('${tempDir.path}/temp_video');
      await tempVideoFile.writeAsBytes(bytes);
      asset = await PhotoManager.editor.saveVideo(
        tempVideoFile,
        title: "${media.name ?? DateTime.now()}_gd_cloud_gallery.$extension",
      );
    } else if (media.type.isImage) {
      asset = await PhotoManager.editor.saveImage(bytes,
          title: "${media.name ?? DateTime.now()}_gd_cloud_gallery.$extension");
    }
    return asset != null ? AppMedia.fromAssetEntity(asset) : null;
  }
}
