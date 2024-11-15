// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dropbox_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DropboxAccountImpl _$$DropboxAccountImplFromJson(Map<String, dynamic> json) =>
    _$DropboxAccountImpl(
      account_id: json['account_id'] as String,
      name: DropboxAccountName.fromJson(json['name'] as Map<String, dynamic>),
      email: json['email'] as String,
      email_verified: json['email_verified'] as bool,
      disabled: json['disabled'] as bool,
      country: json['country'] as String,
      locale: json['locale'] as String,
      referral_link: json['referral_link'] as String,
      is_paired: json['is_paired'] as bool,
      profile_photo_url: json['profile_photo_url'] as String?,
      team_member_id: json['team_member_id'] as String?,
    );

Map<String, dynamic> _$$DropboxAccountImplToJson(
        _$DropboxAccountImpl instance) =>
    <String, dynamic>{
      'account_id': instance.account_id,
      'name': instance.name,
      'email': instance.email,
      'email_verified': instance.email_verified,
      'disabled': instance.disabled,
      'country': instance.country,
      'locale': instance.locale,
      'referral_link': instance.referral_link,
      'is_paired': instance.is_paired,
      'profile_photo_url': instance.profile_photo_url,
      'team_member_id': instance.team_member_id,
    };

_$DropboxAccountNameImpl _$$DropboxAccountNameImplFromJson(
        Map<String, dynamic> json) =>
    _$DropboxAccountNameImpl(
      abbreviated_name: json['abbreviated_name'] as String,
      display_name: json['display_name'] as String,
      familiar_name: json['familiar_name'] as String,
      given_name: json['given_name'] as String,
      surname: json['surname'] as String,
    );

Map<String, dynamic> _$$DropboxAccountNameImplToJson(
        _$DropboxAccountNameImpl instance) =>
    <String, dynamic>{
      'abbreviated_name': instance.abbreviated_name,
      'display_name': instance.display_name,
      'familiar_name': instance.familiar_name,
      'given_name': instance.given_name,
      'surname': instance.surname,
    };
