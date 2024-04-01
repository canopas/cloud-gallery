import 'package:collection/collection.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
}
