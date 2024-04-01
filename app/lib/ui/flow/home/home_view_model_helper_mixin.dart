import 'package:cloud_gallery/domain/formatter/date_formatter.dart';
import 'package:collection/collection.dart';
import 'package:data/models/media/media.dart';

mixin HomeViewModelHelperMixin {
  List<AppMedia> mergeCommonMedia({
    required List<AppMedia> localMedias,
    required List<AppMedia> googleDriveMedias,
  }) {
    // If one of the lists is empty, return the other list.
    if (googleDriveMedias.isEmpty) return localMedias;
    if (localMedias.isEmpty) return [];

    // Convert the lists to mutable lists.
    localMedias = localMedias.toList();
    googleDriveMedias = googleDriveMedias.toList();

    final mergedMedias = <AppMedia>[];

    // Add common media to mergedMedias and remove them from the lists.
    for (AppMedia localMedia in localMedias.toList()) {
      googleDriveMedias
          .toList()
          .where((googleDriveMedia) => googleDriveMedia.path == localMedia.path)
          .forEach((googleDriveMedia) {
        localMedias.removeWhere((media) => media.id == localMedia.id);

        mergedMedias.add(localMedia.copyWith(
          sources: [AppMediaSource.local, AppMediaSource.googleDrive],
          thumbnailLink: googleDriveMedia.thumbnailLink,
          driveMediaRefId: googleDriveMedia.id,
        ));
      });
    }

    return [...mergedMedias, ...localMedias];
  }

  Map<DateTime, List<AppMedia>> sortMedias({required List<AppMedia> medias}) {
    medias.sort((a, b) => (b.createdTime ?? DateTime.now())
        .compareTo(a.createdTime ?? DateTime.now()));
    return groupBy<AppMedia, DateTime>(
      medias,
      (AppMedia media) =>
          media.createdTime?.dateOnly ?? DateTime.now().dateOnly,
    );
  }

  List<AppMedia> removeGoogleDriveRefFromMedias(
      Map<DateTime, List<AppMedia>> medias) {
    final allMedias = medias.values.expand((element) => element).toList();
    for (int index = 0; index < allMedias.length; index++) {
      if (allMedias[index].isCommonStored) {
        allMedias[index] = allMedias[index].copyWith(
          sources: allMedias[index].sources.toList()
            ..remove(AppMediaSource.googleDrive),
          thumbnailLink: null,
          driveMediaRefId: null,
        );
      } else if (allMedias[index].isGoogleDriveStored) {
        allMedias.removeAt(index);
      }
    }
    return allMedias;
  }
}
