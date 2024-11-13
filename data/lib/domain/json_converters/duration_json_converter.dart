import 'package:freezed_annotation/freezed_annotation.dart';

class DurationJsonConverter implements JsonConverter<Duration, int> {
  const DurationJsonConverter();

  @override
  Duration fromJson(int json) {
    return Duration(milliseconds: json);
  }

  @override
  int toJson(Duration object) {
    return object.inMilliseconds;
  }
}
