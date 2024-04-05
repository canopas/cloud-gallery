import 'package:cloud_gallery/domain/formatter/date_formatter.dart';
import 'package:collection/collection.dart';
import 'package:data/extensions/iterable_extension.dart';
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

  Map<DateTime, List<AppMedia>> removeGoogleDriveRefFromMedias(
      {required Map<DateTime, List<AppMedia>> medias,
      List<String>? removeFromIds}) {
    return medias.map((key, mediaList) {
      for (int index = 0; index < mediaList.length; index++) {
        if (mediaList[index].isGoogleDriveStored &&
            (removeFromIds?.contains(mediaList[index].driveMediaRefId) ??
                true)) {
          mediaList.removeAt(index);
        } else if (mediaList[index].isCommonStored &&
            (removeFromIds?.contains(mediaList[index].driveMediaRefId) ??
                true)) {
          mediaList[index] = mediaList[index].copyWith(
            sources: mediaList[index].sources.toList()
              ..remove(AppMediaSource.googleDrive),
            thumbnailLink: null,
            driveMediaRefId: null,
          );
        }
      }
      return MapEntry(key, mediaList);
    });
  }

  Map<DateTime, List<AppMedia>> addGoogleDriveRefInMedias(
      {required Map<DateTime, List<AppMedia>> medias,
      required List<AppMediaProcess> event,
      required List<String> uploadSuccessIds}) {
    return medias.map((key, value) {
      return MapEntry(
          key,
          value
              .updateWhere(
                where: (media) => uploadSuccessIds.contains(media.id),
                update: (media) {
                  final res = event
                      .where((element) => element.mediaId == media.id)
                      .first
                      .response as AppMedia?;
                  return media.copyWith(
                    thumbnailLink: res?.thumbnailLink,
                    driveMediaRefId: res?.id,
                    sources: media.sources.toList()
                      ..add(AppMediaSource.googleDrive),
                  );
                },
              )
              .toList());
    });
  }
}