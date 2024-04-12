import 'package:cloud_gallery/domain/extensions/media_list_extension.dart';
import 'package:cloud_gallery/domain/formatter/date_formatter.dart';
import 'package:collection/collection.dart';
import 'package:data/models/app_process/app_process.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';

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
          .where((googleDriveMedia) => googleDriveMedia.path == localMedia.id)
          .forEach((googleDriveMedia) {
        localMedias.removeWhere((media) => media.id == localMedia.id);

        mergedMedias.add(localMedia.mergeGoogleDriveMedia(googleDriveMedia));
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

  Map<DateTime, List<AppMedia>> removeGoogleDriveRefFromMediaMap(
      {required Map<DateTime, List<AppMedia>> medias,
      List<String>? removeFromIds}) {
    return medias.map((key, value) {
      return MapEntry(key,
          value..removeGoogleDriveRefFromMedias(removeFromIds: removeFromIds));
    });
  }

  Map<DateTime, List<AppMedia>> addGoogleDriveRefInMediaMap({
    required Map<DateTime, List<AppMedia>> medias,
    required List<AppProcess> process,
  }) {
    final processIds = process.map((e) => e.id).toList();
    return medias.map((key, value) {
      return MapEntry(
          key,
          value
            ..addGoogleDriveRefInMedias(
                process: process, processIds: processIds));
    });
  }

  Map<DateTime, List<AppMedia>> replaceMediaRefInMediaMap({
    required Map<DateTime, List<AppMedia>> medias,
    required List<AppProcess> process,
  }) {
    final processIds = process.map((e) => e.id).toList();
    return medias.map((key, value) {
      return MapEntry(
          key,
          value
            ..replaceMediaRefInMedias(
                process: process, processIds: processIds));
    });
  }
}
