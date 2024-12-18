import 'package:freezed_annotation/freezed_annotation.dart';
import '../media_process/media_process.dart';

part 'album_model.freezed.dart';

part 'album_model.g.dart';

@freezed
class Album with _$Album {
  const factory Album({
    required String name,
    required String path,
    required String id,
    required MediaProvider provider,
  }) = _Album;

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
}
