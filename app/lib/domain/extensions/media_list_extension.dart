import 'package:data/extensions/iterable_extension.dart';
import 'package:data/models/app_process/app_process.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';

extension MediaListExtension on List<AppMedia> {
  void removeGoogleDriveRefFromMedias({List<String>? removeFromIds}) {
    for (int index = 0; index < length; index++) {
      if (this[index].isGoogleDriveStored &&
          (removeFromIds?.contains(this[index].id) ?? true)) {
        removeAt(index);
      } else if (this[index].isCommonStored &&
          (removeFromIds?.contains(this[index].id) ?? true)) {
        this[index] = this[index].copyWith(
          sources: this[index].sources.toList()
            ..remove(AppMediaSource.googleDrive),
          thumbnailLink: null,
          driveMediaRefId: null,
        );
      }
    }
  }

  void addGoogleDriveRefInMedias(
      {required List<AppProcess> process, List<String>? processIds}) {
    processIds ??= process.map((e) => e.id).toList();
    updateWhere(
      where: (media) => processIds?.contains(media.id) ?? false,
      update: (media) {
        final res = process
            .where((element) => element.id == media.id)
            .first
            .response as AppMedia?;
        if (res == null) return media;
        return media.margeGoogleDriveMedia(res);
      },
    );
  }

  void replaceMediaRefInMedias(
      {required List<AppProcess> process, List<String>? processIds}) {
    processIds ??= process.map((e) => e.id).toList();
    updateWhere(
      where: (media) => processIds?.contains(media.id) ?? false,
      update: (media) {
        final res = process
            .where((element) => element.id == media.id)
            .first
            .response as AppMedia?;

        if (res == null) return media;
        return res;
      },
    );
  }
}
