// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../media/media.dart';

part 'media_process.freezed.dart';

part 'media_process.g.dart';

@JsonEnum(valueField: 'value')
enum MediaQueueProcessStatus {
  waiting('waiting'),
  uploading('uploading'),
  downloading('downloading'),
  completed('completed'),
  terminated('terminated'),
  paused('paused'),
  failed('failed');

  final String value;

  const MediaQueueProcessStatus(this.value);

  bool get isRunning =>
      this == MediaQueueProcessStatus.uploading ||
      this == MediaQueueProcessStatus.downloading;

  bool get isWaiting => this == MediaQueueProcessStatus.waiting;

  bool get isCompleted => this == MediaQueueProcessStatus.completed;

  bool get isFailed => this == MediaQueueProcessStatus.failed;

  bool get isPaused => this == MediaQueueProcessStatus.paused;

  bool get isTerminated => this == MediaQueueProcessStatus.terminated;
}

@JsonEnum(valueField: 'value')
enum MediaProvider {
  googleDrive('google-drive'),
  dropbox('dropbox');

  final String value;

  const MediaProvider(this.value);
}

class LocalDatabaseBoolConverter extends JsonConverter<bool, int> {
  const LocalDatabaseBoolConverter();

  @override
  bool fromJson(int json) {
    return json == 1;
  }

  @override
  int toJson(bool object) {
    return object ? 1 : 0;
  }
}

class LocalDatabaseAppMediaConverter extends JsonConverter<AppMedia?, String?> {
  const LocalDatabaseAppMediaConverter();

  @override
  AppMedia? fromJson(String? json) {
    try {
      return json == null ? null : AppMedia.fromJson(jsonDecode(json));
    } catch (e) {
      return null;
    }
  }

  @override
  String? toJson(AppMedia? object) {
    try {
      return object == null ? null : jsonEncode(object.toJson());
    } catch (e) {
      return null;
    }
  }
}

@freezed
class DownloadMediaProcess with _$DownloadMediaProcess {
  const DownloadMediaProcess._();

  const factory DownloadMediaProcess({
    required String id,
    required String name,
    required String media_id,
    required String folder_id,
    required int notification_id,
    required MediaProvider provider,
    @Default(MediaQueueProcessStatus.waiting) MediaQueueProcessStatus status,
    @LocalDatabaseAppMediaConverter() AppMedia? response,
    @Default(1) int total,
    required String extension,
    @Default(0) int chunk,
  }) = _DownloadMediaProcess;

  /// progress 0.0 - 1.0
  double get progress => total == 0 ? 0 : chunk / total;

  /// percentage of the progress 0 - 100
  double get progressPercentage => progress * 100;

  factory DownloadMediaProcess.fromJson(Map<String, dynamic> json) =>
      _$DownloadMediaProcessFromJson(json);
}

@freezed
class UploadMediaProcess with _$UploadMediaProcess {
  const UploadMediaProcess._();

  const factory UploadMediaProcess({
    required String id,
    required String media_id,
    required int notification_id,
    required String folder_id,
    String? upload_session_id,
    required MediaProvider provider,
    required String path,
    String? mime_type,
    @Default(MediaQueueProcessStatus.waiting) MediaQueueProcessStatus status,
    @LocalDatabaseBoolConverter() @Default(false) bool upload_using_auto_backup,
    @LocalDatabaseAppMediaConverter() AppMedia? response,
    @Default(1) int total,
    @Default(0) int chunk,
  }) = _UploadMediaProcess;

  /// progress 0.0 - 1.0
  double get progress => total == 0 ? 0 : chunk / total;

  /// percentage of the progress 0 - 100
  double get progressPercentage => progress * 100;

  factory UploadMediaProcess.fromJson(Map<String, dynamic> json) =>
      _$UploadMediaProcessFromJson(json);
}
