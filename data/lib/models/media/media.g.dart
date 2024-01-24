// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaImpl _$$MediaImplFromJson(Map<String, dynamic> json) => _$MediaImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      size: (json['size'] as num).toDouble(),
      mimeType: json['mimeType'] as String?,
      createdTime: DateTime.parse(json['createdTime'] as String),
      modifiedTime: json['modifiedTime'] == null
          ? null
          : DateTime.parse(json['modifiedTime'] as String),
    );

Map<String, dynamic> _$$MediaImplToJson(_$MediaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'size': instance.size,
      'mimeType': instance.mimeType,
      'createdTime': instance.createdTime.toIso8601String(),
      'modifiedTime': instance.modifiedTime?.toIso8601String(),
    };
