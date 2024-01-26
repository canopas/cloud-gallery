// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppMediaImpl _$$AppMediaImplFromJson(Map<String, dynamic> json) =>
    _$AppMediaImpl(
      id: json['id'] as String,
      name: json['name'] as String?,
      path: json['path'] as String,
      displayHeight: (json['displayHeight'] as num?)?.toDouble(),
      displayWidth: (json['displayWidth'] as num?)?.toDouble(),
      type: $enumDecode(_$AppMediaTypeEnumMap, json['type']),
      mimeType: json['mimeType'] as String?,
      createdTime: DateTime.parse(json['createdTime'] as String),
      modifiedTime: json['modifiedTime'] == null
          ? null
          : DateTime.parse(json['modifiedTime'] as String),
      orientation: $enumDecodeNullable(
          _$AppMediaOrientationEnumMap, json['orientation']),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isLocal: json['isLocal'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppMediaImplToJson(_$AppMediaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'displayHeight': instance.displayHeight,
      'displayWidth': instance.displayWidth,
      'type': _$AppMediaTypeEnumMap[instance.type]!,
      'mimeType': instance.mimeType,
      'createdTime': instance.createdTime.toIso8601String(),
      'modifiedTime': instance.modifiedTime?.toIso8601String(),
      'orientation': _$AppMediaOrientationEnumMap[instance.orientation],
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isLocal': instance.isLocal,
    };

const _$AppMediaTypeEnumMap = {
  AppMediaType.image: 'image',
  AppMediaType.video: 'video',
};

const _$AppMediaOrientationEnumMap = {
  AppMediaOrientation.landscape: 'landscape',
  AppMediaOrientation.portrait: 'portrait',
};
