// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dropbox_account.freezed.dart';
part 'dropbox_account.g.dart';

@freezed
class DropboxAccount with _$DropboxAccount {
  const factory DropboxAccount({
    required String account_id,
    required DropboxAccountName name,
    required String email,
    required bool email_verified,
    required bool disabled,
    required String country,
    required String locale,
    required String referral_link,
    required bool is_paired,
    String? profile_photo_url,
    String? team_member_id,
  }) = _DropboxAccount;

  factory DropboxAccount.fromJson(Map<String, dynamic> json) =>
      _$DropboxAccountFromJson(json);
}

@freezed
class DropboxAccountName with _$DropboxAccountName {
  const factory DropboxAccountName({
    required String abbreviated_name,
    required String display_name,
    required String familiar_name,
    required String given_name,
    required String surname,
  }) = _DropboxAccountName;

  factory DropboxAccountName.fromJson(Map<String, dynamic> json) =>
      _$DropboxAccountNameFromJson(json);
}
