// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_process.freezed.dart';

part 'media_process.g.dart';

@JsonEnum(valueField: 'value')
enum MediaQueueProcessStatus {
  waiting('waiting'),
  uploading('uploading'),
  deleting('deleting'),
  downloading('downloading'),
  completed('completed'),
  terminated('terminated'),
  failed('failed');

  final String value;

  const MediaQueueProcessStatus(this.value);

  bool get isRunning =>
      this == MediaQueueProcessStatus.uploading ||
      this == MediaQueueProcessStatus.deleting ||
      this == MediaQueueProcessStatus.downloading;

  bool get isWaiting => this == MediaQueueProcessStatus.waiting;

  bool get isCompleted => this == MediaQueueProcessStatus.completed;

  bool get isFailed => this == MediaQueueProcessStatus.failed;

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

@freezed
class DownloadMediaProcess with _$DownloadMediaProcess {
  const factory DownloadMediaProcess({
    required String id,
    required String folder_id,
    required MediaProvider provider,
    @Default(MediaQueueProcessStatus.waiting) MediaQueueProcessStatus status,
    @Default(1) int total,
    required String extension,
    @Default(0) int chunk,
  }) = _MediaProcess;

  factory DownloadMediaProcess.fromJson(Map<String, dynamic> json) =>
      _$DownloadMediaProcessFromJson(json);
}

@freezed
class UploadMediaProcess with _$UploadMediaProcess {
  const factory UploadMediaProcess({
    required String id,
    required String folder_id,
    required MediaProvider provider,
    required String path,
     String? mime_type,
    @Default(MediaQueueProcessStatus.waiting) MediaQueueProcessStatus status,
    @LocalDatabaseBoolConverter() @Default(false) bool upload_using_auto_backup,
    @Default(1) int total,
    @Default(0) int chunk,
  }) = _UploadMediaProcess;

  factory UploadMediaProcess.fromJson(Map<String, dynamic> json) =>
      _$UploadMediaProcessFromJson(json);
}

@freezed
class MediaProcessProgress with _$MediaProcessProgress {
  const MediaProcessProgress._();

  const factory MediaProcessProgress({
    required int total,
    required int chunk,
  }) = _MediaProcessProgress;

  /// progress 0.0 - 1.0
  double get progress => total == 0 ? 0 : chunk / total;

  /// percentage of the progress 0 - 100
  double get progressPercentage => progress * 100;

  factory MediaProcessProgress.fromJson(Map<String, dynamic> json) =>
      _$MediaProcessProgressFromJson(json);
}
