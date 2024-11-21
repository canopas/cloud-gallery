// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppMediaImpl _$$AppMediaImplFromJson(Map<String, dynamic> json) =>
    _$AppMediaImpl(
      id: json['id'] as String,
      driveMediaRefId: json['driveMediaRefId'] as String?,
      name: json['name'] as String?,
      path: json['path'] as String,
      thumbnailLink: json['thumbnailLink'] as String?,
      displayHeight: (json['displayHeight'] as num?)?.toDouble(),
      displayWidth: (json['displayWidth'] as num?)?.toDouble(),
      type: $enumDecode(_$AppMediaTypeEnumMap, json['type']),
      mimeType: json['mimeType'] as String?,
      createdTime: _$JsonConverterFromJson<String, DateTime>(
          json['createdTime'], const DateTimeJsonConverter().fromJson),
      modifiedTime: _$JsonConverterFromJson<String, DateTime>(
          json['modifiedTime'], const DateTimeJsonConverter().fromJson),
      orientation: $enumDecodeNullable(
          _$AppMediaOrientationEnumMap, json['orientation']),
      size: json['size'] as String?,
      videoDuration: _$JsonConverterFromJson<int, Duration>(
          json['videoDuration'], const DurationJsonConverter().fromJson),
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
      'driveMediaRefId': instance.driveMediaRefId,
      'name': instance.name,
      'path': instance.path,
      'thumbnailLink': instance.thumbnailLink,
      'displayHeight': instance.displayHeight,
      'displayWidth': instance.displayWidth,
      'type': _$AppMediaTypeEnumMap[instance.type]!,
      'mimeType': instance.mimeType,
      'createdTime': _$JsonConverterToJson<String, DateTime>(
          instance.createdTime, const DateTimeJsonConverter().toJson),
      'modifiedTime': _$JsonConverterToJson<String, DateTime>(
          instance.modifiedTime, const DateTimeJsonConverter().toJson),
      'orientation': _$AppMediaOrientationEnumMap[instance.orientation],
      'size': instance.size,
      'videoDuration': _$JsonConverterToJson<int, Duration>(
          instance.videoDuration, const DurationJsonConverter().toJson),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'sources':
          instance.sources.map((e) => _$AppMediaSourceEnumMap[e]!).toList(),
    };

const _$AppMediaTypeEnumMap = {
  AppMediaType.other: 'other',
  AppMediaType.image: 'image',
  AppMediaType.video: 'video',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

const _$AppMediaOrientationEnumMap = {
  AppMediaOrientation.landscape: 'landscape',
  AppMediaOrientation.portrait: 'portrait',
};

const _$AppMediaSourceEnumMap = {
  AppMediaSource.local: 'local',
  AppMediaSource.googleDrive: 'google_drive',
  AppMediaSource.dropbox: 'dropbox',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
