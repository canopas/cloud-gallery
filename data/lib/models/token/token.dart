// ignore_for_file: non_constant_identifier_names

import '../../extensions/date_time_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token.freezed.dart';
part 'token.g.dart';

class ExpiresInJsonConverter implements JsonConverter<DateTime, int> {
  const ExpiresInJsonConverter();

  @override
  DateTime fromJson(int json) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch + (json * 1000),
    );
    return date;
  }

  @override
  int toJson(DateTime dateTime) {
    return dateTime.secondsSinceEpoch;
  }
}

@freezed
abstract class DropboxToken with _$DropboxToken {
  const factory DropboxToken({
    required String access_token,
    required String token_type,
    @ExpiresInJsonConverter() required DateTime expires_in,
    required String refresh_token,
    required String account_id,
    required String scope,
    required String uid,
  }) = _DropboxToken;

  factory DropboxToken.fromJson(Map<String, dynamic> json) =>
      _$DropboxTokenFromJson(json);
}
