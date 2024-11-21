// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_process.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaProcessProgressImpl _$$MediaProcessProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$MediaProcessProgressImpl(
      total: (json['total'] as num).toInt(),
      chunk: (json['chunk'] as num).toInt(),
    );

Map<String, dynamic> _$$MediaProcessProgressImplToJson(
        _$MediaProcessProgressImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'chunk': instance.chunk,
    };
