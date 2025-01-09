// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/json_converters/date_time_json_converter.dart';
import '../media/media.dart';

part 'album.freezed.dart';

part 'album.g.dart';

@freezed
class Album with _$Album {
  const factory Album({
    required String name,
    required String id,
    required List<String> medias,
    required AppMediaSource source,
    @DateTimeJsonConverter() required DateTime created_at,
  }) = _Album;

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
}
