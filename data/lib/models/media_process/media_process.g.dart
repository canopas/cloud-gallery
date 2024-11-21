// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_process.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaProcessImpl _$$MediaProcessImplFromJson(Map<String, dynamic> json) =>
    _$MediaProcessImpl(
      id: json['id'] as String,
      folder_id: json['folder_id'] as String,
      provider: $enumDecode(_$MediaProviderEnumMap, json['provider']),
      status: $enumDecodeNullable(
              _$MediaQueueProcessStatusEnumMap, json['status']) ??
          MediaQueueProcessStatus.waiting,
      total: (json['total'] as num?)?.toInt() ?? 1,
      extension: json['extension'] as String,
      chunk: (json['chunk'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MediaProcessImplToJson(_$MediaProcessImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'folder_id': instance.folder_id,
      'provider': _$MediaProviderEnumMap[instance.provider]!,
      'status': _$MediaQueueProcessStatusEnumMap[instance.status]!,
      'total': instance.total,
      'extension': instance.extension,
      'chunk': instance.chunk,
    };

const _$MediaProviderEnumMap = {
  MediaProvider.googleDrive: 'google-drive',
  MediaProvider.dropbox: 'dropbox',
};

const _$MediaQueueProcessStatusEnumMap = {
  MediaQueueProcessStatus.waiting: 'waiting',
  MediaQueueProcessStatus.uploading: 'uploading',
  MediaQueueProcessStatus.deleting: 'deleting',
  MediaQueueProcessStatus.downloading: 'downloading',
  MediaQueueProcessStatus.completed: 'completed',
  MediaQueueProcessStatus.terminated: 'terminated',
  MediaQueueProcessStatus.failed: 'failed',
};

_$UploadMediaProcessImpl _$$UploadMediaProcessImplFromJson(
        Map<String, dynamic> json) =>
    _$UploadMediaProcessImpl(
      id: json['id'] as String,
      folder_id: json['folder_id'] as String,
      provider: $enumDecode(_$MediaProviderEnumMap, json['provider']),
      path: json['path'] as String,
      mime_type: json['mime_type'] as String?,
      status: $enumDecodeNullable(
              _$MediaQueueProcessStatusEnumMap, json['status']) ??
          MediaQueueProcessStatus.waiting,
      upload_using_auto_backup: json['upload_using_auto_backup'] == null
          ? false
          : const LocalDatabaseBoolConverter()
              .fromJson((json['upload_using_auto_backup'] as num).toInt()),
      total: (json['total'] as num?)?.toInt() ?? 1,
      chunk: (json['chunk'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UploadMediaProcessImplToJson(
        _$UploadMediaProcessImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'folder_id': instance.folder_id,
      'provider': _$MediaProviderEnumMap[instance.provider]!,
      'path': instance.path,
      'mime_type': instance.mime_type,
      'status': _$MediaQueueProcessStatusEnumMap[instance.status]!,
      'upload_using_auto_backup': const LocalDatabaseBoolConverter()
          .toJson(instance.upload_using_auto_backup),
      'total': instance.total,
      'chunk': instance.chunk,
    };

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
