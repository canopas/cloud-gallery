import 'package:data/extensions/iterable_extension.dart';
import 'package:data/models/app_process/app_process.dart';
import 'package:data/models/media/media.dart';

extension MediaListHelper on List<AppMedia> {
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

  void addGoogleDriveRefInMedia(
      {required List<AppProcess> process, required List<String> processIds}) {
    updateWhere(
      where: (media) => processIds.contains(media.id),
      update: (media) {
        final res = process
            .where((element) => element.id == media.id)
            .first
            .response as AppMedia?;
        return media.copyWith(
          thumbnailLink: res?.thumbnailLink,
          driveMediaRefId: res?.id,
          sources: media.sources.toList()..add(AppMediaSource.googleDrive),
        );
      },
    );
  }

  void addLocalRefInMedias(
      {required List<AppProcess> process, required List<String> processIds}) {
    updateWhere(
      where: (media) => processIds.contains(media.id),
      update: (media) {
        final res = process
            .where((element) => element.id == media.id)
            .first
            .response as AppMedia?;

        if (res == null) return media;
        return res.copyWith(
          thumbnailLink: media.thumbnailLink,
          driveMediaRefId: media.id,
          sources: res.sources.toList()..add(AppMediaSource.googleDrive),
        );
      },
    );
  }
}
