import 'package:collection/collection.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

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
    return await PhotoManager.getAssetCount();
  }

  Future<List<AppMedia>> getMedia(
      {required int start, required int end}) async {
    final assets = await PhotoManager.getAssetListRange(start: start, end: end);
    final files = await Future.wait(
      assets.map(
        (asset) async {
          final file = await asset.originFile;
          if (file == null) return null;
          return AppMedia(
            id: asset.id,
            path: file.path,
            type: asset.type == AssetType.image
                ? AppMediaType.image
                : AppMediaType.video,
            createdTime: asset.createDateTime,
            latitude: asset.latitude,
            longitude: asset.longitude,
            isLocal: true,
            orientation: asset.orientation == 90 || asset.orientation == 270
                ? AppMediaOrientation.landscape
                : AppMediaOrientation.portrait,
            modifiedTime: asset.modifiedDateTime,
            displayHeight: asset.size.height,
            displayWidth: asset.size.width,
          );
        },
      ),
    );
    return files.whereNotNull().toList();
  }
}
