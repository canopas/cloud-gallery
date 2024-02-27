import 'package:freezed_annotation/freezed_annotation.dart';

part 'media.freezed.dart';

part 'media.g.dart';

enum AppMediaType { image, video }

enum AppMediaOrientation { landscape, portrait }

@freezed
class AppMedia with _$AppMedia {
  const factory AppMedia({
    required String id,
    String? name,
    required String path,
    double? displayHeight,
    double? displayWidth,
    required AppMediaType type,
    String? mimeType,
    DateTime? createdTime,
    DateTime? modifiedTime,
    AppMediaOrientation? orientation,
    required double? latitude,
    required double? longitude,
    @Default(false) bool isLocal,
  }) = _AppMedia;

  factory AppMedia.fromJson(Map<String, dynamic> json) =>
      _$AppMediaFromJson(json);
}

