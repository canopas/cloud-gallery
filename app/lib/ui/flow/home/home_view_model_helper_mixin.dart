import '../../../domain/formatter/date_formatter.dart';
import 'package:collection/collection.dart';
import 'package:data/models/media/media.dart';

mixin HomeViewModelHelperMixin {
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
