// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dropbox_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiDropboxEntityImpl _$$ApiDropboxEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiDropboxEntityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      path_lower: json['path_lower'] as String,
      path_display: json['path_display'] as String,
      type: $enumDecode(_$ApiDropboxEntityTypeEnumMap, json['.tag'],
          unknownValue: ApiDropboxEntityType.unknown),
    );

Map<String, dynamic> _$$ApiDropboxEntityImplToJson(
        _$ApiDropboxEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path_lower': instance.path_lower,
      'path_display': instance.path_display,
      '.tag': _$ApiDropboxEntityTypeEnumMap[instance.type]!,
    };

const _$ApiDropboxEntityTypeEnumMap = {
  ApiDropboxEntityType.folder: 'folder',
  ApiDropboxEntityType.unknown: 'unknown',
};
