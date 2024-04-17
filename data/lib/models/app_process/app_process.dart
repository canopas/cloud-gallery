import 'package:freezed_annotation/freezed_annotation.dart';

import '../media/media.dart';

part 'app_process.freezed.dart';

enum AppProcessStatus {
  waiting,
  uploading,
  deleting,
  downloading,
  success,
  terminated,
  failed;

  bool get isProcessing =>
      this == AppProcessStatus.uploading ||
      this == AppProcessStatus.deleting ||
      this == AppProcessStatus.downloading;

  bool get isWaiting => this == AppProcessStatus.waiting;

  bool get isSuccess => this == AppProcessStatus.success;

  bool get isFailed => this == AppProcessStatus.failed;

  bool get isTerminated => this == AppProcessStatus.terminated;
}

@freezed
class AppProcess with _$AppProcess {
  const factory AppProcess({
    required String id,
    required AppMedia media,
    required AppProcessStatus status,
    Object? response,
    @Default(null)
    AppProcessProgress? progress,
  }) = _AppProcess;
}

@freezed
class AppProcessProgress with _$AppProcessProgress {
  const factory AppProcessProgress({required int total, required int chunk}) =
      _AppProcessProgress;
}

extension AppProcessProgressExtension on AppProcessProgress {
  /// Get the percentage of the progress 0.0 - 1.0
  double get percentageInPoint => total == 0 ? 0 : chunk / total;

  /// Get the percentage of the progress 0 - 100
  double get percentage => percentageInPoint*100;
}