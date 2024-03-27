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
      thumbnailLink: json['thumbnailLink'] as String?,
      displayHeight: (json['displayHeight'] as num?)?.toDouble(),
      displayWidth: (json['displayWidth'] as num?)?.toDouble(),
      type: $enumDecode(_$AppMediaTypeEnumMap, json['type']),
      mimeType: json['mimeType'] as String?,
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
      modifiedTime: json['modifiedTime'] == null
          ? null
          : DateTime.parse(json['modifiedTime'] as String),
      orientation: $enumDecodeNullable(
          _$AppMediaOrientationEnumMap, json['orientation']),
      size: json['size'] as String?,
      videoDuration: json['videoDuration'] == null
          ? null
          : Duration(microseconds: json['videoDuration'] as int),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      sources: (json['sources'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$AppMediaSourceEnumMap, e))
              .toList() ??
          const [AppMediaSource.local],
    );

Map<String, dynamic> _$$AppMediaImplToJson(_$AppMediaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'thumbnailLink': instance.thumbnailLink,
      'displayHeight': instance.displayHeight,
      'displayWidth': instance.displayWidth,
      'type': _$AppMediaTypeEnumMap[instance.type]!,
      'mimeType': instance.mimeType,
      'createdTime': instance.createdTime?.toIso8601String(),
      'modifiedTime': instance.modifiedTime?.toIso8601String(),
      'orientation': _$AppMediaOrientationEnumMap[instance.orientation],
      'size': instance.size,
      'videoDuration': instance.videoDuration?.inMicroseconds,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'sources':
          instance.sources.map((e) => _$AppMediaSourceEnumMap[e]!).toList(),
    };

const _$AppMediaTypeEnumMap = {
  AppMediaType.image: 'image',
  AppMediaType.video: 'video',
  AppMediaType.other: 'other',
};

const _$AppMediaOrientationEnumMap = {
  AppMediaOrientation.landscape: 'landscape',
  AppMediaOrientation.portrait: 'portrait',
};

const _$AppMediaSourceEnumMap = {
  AppMediaSource.local: 'local',
  AppMediaSource.googleDrive: 'googleDrive',
};
