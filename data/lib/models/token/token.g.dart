// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DropboxTokenImpl _$$DropboxTokenImplFromJson(Map<String, dynamic> json) =>
    _$DropboxTokenImpl(
      access_token: json['access_token'] as String,
      token_type: json['token_type'] as String,
      expires_in: const ExpiresInJsonConverter()
          .fromJson((json['expires_in'] as num).toInt()),
      refresh_token: json['refresh_token'] as String,
      account_id: json['account_id'] as String,
      scope: json['scope'] as String,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$$DropboxTokenImplToJson(_$DropboxTokenImpl instance) =>
    <String, dynamic>{
      'access_token': instance.access_token,
      'token_type': instance.token_type,
      'expires_in': const ExpiresInJsonConverter().toJson(instance.expires_in),
      'refresh_token': instance.refresh_token,
      'account_id': instance.account_id,
      'scope': instance.scope,
      'uid': instance.uid,
    };