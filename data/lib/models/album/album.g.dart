// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlbumImpl _$$AlbumImplFromJson(Map<String, dynamic> json) => _$AlbumImpl(
      name: json['name'] as String,
      id: json['id'] as String,
      medias:
          (json['medias'] as List<dynamic>).map((e) => e as String).toList(),
      source: $enumDecode(_$AppMediaSourceEnumMap, json['source']),
      created_at:
          const DateTimeJsonConverter().fromJson(json['created_at'] as String),
    );

Map<String, dynamic> _$$AlbumImplToJson(_$AlbumImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'medias': instance.medias,
      'source': _$AppMediaSourceEnumMap[instance.source]!,
      'created_at': const DateTimeJsonConverter().toJson(instance.created_at),
    };

const _$AppMediaSourceEnumMap = {
  AppMediaSource.local: 'local',
  AppMediaSource.googleDrive: 'google_drive',
  AppMediaSource.dropbox: 'dropbox',
};
