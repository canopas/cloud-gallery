// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_process.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaProcessImpl _$$MediaProcessImplFromJson(Map<String, dynamic> json) =>
    _$MediaProcessImpl(
      id: json['id'] as String,
      media_id: json['media_id'] as String,
      folder_id: json['folder_id'] as String,
      notification_id: (json['notification_id'] as num).toInt(),
      provider: $enumDecode(_$MediaProviderEnumMap, json['provider']),
      status: $enumDecodeNullable(
              _$MediaQueueProcessStatusEnumMap, json['status']) ??
          MediaQueueProcessStatus.waiting,
      response: const LocalDatabaseAppMediaConverter()
          .fromJson(json['response'] as String?),
      total: (json['total'] as num?)?.toInt() ?? 1,
      extension: json['extension'] as String,
      chunk: (json['chunk'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MediaProcessImplToJson(_$MediaProcessImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_id': instance.media_id,
      'folder_id': instance.folder_id,
      'notification_id': instance.notification_id,
      'provider': _$MediaProviderEnumMap[instance.provider]!,
      'status': _$MediaQueueProcessStatusEnumMap[instance.status]!,
      'response':
          const LocalDatabaseAppMediaConverter().toJson(instance.response),
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
      media_id: json['media_id'] as String,
      notification_id: (json['notification_id'] as num).toInt(),
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
      response: const LocalDatabaseAppMediaConverter()
          .fromJson(json['response'] as String?),
      total: (json['total'] as num?)?.toInt() ?? 1,
      chunk: (json['chunk'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UploadMediaProcessImplToJson(
        _$UploadMediaProcessImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_id': instance.media_id,
      'notification_id': instance.notification_id,
      'folder_id': instance.folder_id,
      'provider': _$MediaProviderEnumMap[instance.provider]!,
      'path': instance.path,
      'mime_type': instance.mime_type,
      'status': _$MediaQueueProcessStatusEnumMap[instance.status]!,
      'upload_using_auto_backup': const LocalDatabaseBoolConverter()
          .toJson(instance.upload_using_auto_backup),
      'response':
          const LocalDatabaseAppMediaConverter().toJson(instance.response),
      'total': instance.total,
      'chunk': instance.chunk,
    };
