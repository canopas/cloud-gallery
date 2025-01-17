// ignore_for_file: non_constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/json_converters/date_time_json_converter.dart';
import '../media/media.dart';

part 'clean_up.freezed.dart';

part 'clean_up.g.dart';

@freezed
class CleanUpMedia with _$CleanUpMedia {
  const factory CleanUpMedia({
    required String id,
    String? provider_ref_id,
    required AppMediaSource provider,
    @DateTimeJsonConverter() required DateTime created_at,
  }) = _CleanUpMedia;

  factory CleanUpMedia.fromJson(Map<String, dynamic> json) =>
      _$CleanUpMediaFromJson(json);
}
