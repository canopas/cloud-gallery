import '../../../domain/formatter/date_formatter.dart';
import 'package:collection/collection.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';

mixin HomeViewModelHelperMixin {
  List<AppMedia> mergeCommonMedia({
    required List<AppMedia> localMedias,
    required List<AppMedia> googleDriveMedias,
    required List<AppMedia> dropboxMedias,
  }) {
    // If only one list contains media, return it.
    if (googleDriveMedias.isEmpty && dropboxMedias.isEmpty) return localMedias;
    if (localMedias.isEmpty && dropboxMedias.isEmpty) return googleDriveMedias;
    if (localMedias.isEmpty && googleDriveMedias.isEmpty) return dropboxMedias;

    // Convert the lists to mutable lists.
    localMedias = localMedias.toList();
    googleDriveMedias = googleDriveMedias.toList();
    dropboxMedias = dropboxMedias.toList();

    final mergedMedias = <AppMedia>[];

    // Merge common medias.
    for (AppMedia localMedia in localMedias.toList()) {
      for (var googleDriveMedia in googleDriveMedias) {
        if (localMedia.id == googleDriveMedia.id) {
          mergedMedias.add(localMedia.mergeGoogleDriveMedia(googleDriveMedia));
        }
        mergedMedias.add(localMedia);
      }
      for (var dropboxMedia in dropboxMedias) {
        if (localMedia.id == dropboxMedia.id) {
          mergedMedias.add(localMedia.mergeGoogleDriveMedia(dropboxMedia));
        }
        mergedMedias.add(localMedia);
      }
    }

    return mergedMedias;
  }

  Map<DateTime, Map<String, AppMedia>> sortMedias({
    required List<AppMedia> medias,
  }) {
    medias.sort(
      (a, b) => (b.createdTime ?? DateTime.now())
          .compareTo(a.createdTime ?? DateTime.now()),
    );

    final sortedGroupedMap = groupBy<MapEntry<String, AppMedia>, DateTime>(
      medias.map((media) => MapEntry(media.id, media)),
      (e) => e.value.createdTime?.dateOnly ?? DateTime.now().dateOnly,
    );

    return sortedGroupedMap.map((key, value) {
      return MapEntry(
        key,
        Map.fromEntries(value.map((e) => MapEntry(e.key, e.value))),
      );
    });
  }

  Map<DateTime, Map<String, AppMedia>> mediaMapUpdate({
    required Map<DateTime, Map<String, AppMedia>> medias,
    required AppMedia? Function(AppMedia media) update,
  }) {
    final List<AppMedia> updatedMedias = [];

    for (final map in medias.values) {
      for (final media in map.values) {
        final updatedMedia = update(media);
        if (updatedMedia != null) {
          updatedMedias.add(updatedMedia);
        }
      }
    }

    return sortMedias(medias: updatedMedias);
  }
}
