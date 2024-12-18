// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlbumImpl _$$AlbumImplFromJson(Map<String, dynamic> json) => _$AlbumImpl(
      name: json['name'] as String,
      path: json['path'] as String,
      id: json['id'] as String,
      provider: $enumDecode(_$MediaProviderEnumMap, json['provider']),
    );

Map<String, dynamic> _$$AlbumImplToJson(_$AlbumImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'id': instance.id,
      'provider': _$MediaProviderEnumMap[instance.provider]!,
    };

const _$MediaProviderEnumMap = {
  MediaProvider.googleDrive: 'google-drive',
  MediaProvider.dropbox: 'dropbox',
};
