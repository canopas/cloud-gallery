
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

final localMediaServiceProvider = Provider<LocalMediaService>(
  (ref) => const LocalMediaService(),
);

class LocalMediaService {
  const LocalMediaService();

  Future<List<AssetEntity>> getAssets() async {
    await PhotoManager.requestPermissionExtend();
    final imageCount = await PhotoManager.getAssetCount();
    final assets = await PhotoManager.getAssetListRange(start: 0, end: imageCount);
    return assets;
  }
}
