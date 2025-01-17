// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clean_up.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CleanUpMediaImpl _$$CleanUpMediaImplFromJson(Map<String, dynamic> json) =>
    _$CleanUpMediaImpl(
      id: json['id'] as String,
      provider_ref_id: json['provider_ref_id'] as String?,
      provider: $enumDecode(_$AppMediaSourceEnumMap, json['provider']),
      created_at:
          const DateTimeJsonConverter().fromJson(json['created_at'] as String),
    );

Map<String, dynamic> _$$CleanUpMediaImplToJson(_$CleanUpMediaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'provider_ref_id': instance.provider_ref_id,
      'provider': _$AppMediaSourceEnumMap[instance.provider]!,
      'created_at': const DateTimeJsonConverter().toJson(instance.created_at),
    };

const _$AppMediaSourceEnumMap = {
  AppMediaSource.local: 'local',
  AppMediaSource.googleDrive: 'google_drive',
  AppMediaSource.dropbox: 'dropbox',
};
