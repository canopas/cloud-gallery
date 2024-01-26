import 'package:data/models/media/media.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

final localMediaServiceProvider = Provider<LocalMediaService>(
  (ref) => const LocalMediaService(),
);

class LocalMediaService {
  const LocalMediaService();

  Future<List<AppMedia>> getAssets() async {
    await PhotoManager.requestPermissionExtend();
    final imageCount = await PhotoManager.getAssetCount();
    if(imageCount == 0)  return [];
    final assets = await PhotoManager.getAssetListRange(start: 0, end: imageCount);

    List<AppMedia> medias = [];

    for (final asset in assets) {
      final file = await asset.file;
      if (file == null) continue;
      final media = AppMedia(
        id: asset.id,
        name: asset.title,
        path: file.path,
        displayHeight: asset.height.toDouble(),
        displayWidth: asset.width.toDouble(),
        type: AppMediaType.image,
        mimeType: asset.type.toString(),
        createdTime: asset.createDateTime,
        modifiedTime: asset.modifiedDateTime,
        orientation: asset.orientation == 90 || asset.orientation == 270
            ? AppMediaOrientation.landscape
            : AppMediaOrientation.portrait,
        latitude: asset.latitude,
        longitude: asset.longitude,
      );
      medias.add(media);
    }
    return medias;
  }
}
