// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dropbox_token.freezed.dart';
part 'dropbox_token.g.dart';

@freezed
abstract class DropboxToken with _$DropboxToken {
  const factory DropboxToken({
    required String access_token,
    required String token_type,
    required DateTime expires_in,
    required String refresh_token,
    required String account_id,
    required String scope,
    required String uid,
  }) = _DropboxToken;

  factory DropboxToken.fromJson(Map<String, dynamic> json) =>
      _$DropboxTokenFromJson(json);
}
