import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:googleapis/drive/v3.dart' as drive show Media;

part 'media_content.freezed.dart';

@freezed
class AppMediaContent with _$AppMediaContent {
  const factory AppMediaContent({
    required Stream<List<int>> stream,
    required int? length,
    String? range,
    required String type,
  }) = _AppMediaContent;

  factory AppMediaContent.fromGoogleDrive(drive.Media media) => AppMediaContent(
        stream: media.stream,
        length: media.length,
        type: media.contentType,
      );
}
