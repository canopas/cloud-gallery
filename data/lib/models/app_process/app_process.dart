import 'package:freezed_annotation/freezed_annotation.dart';

import '../media/media.dart';

part 'app_process.freezed.dart';

enum AppProcessStatus {
  waiting,
  upload,
  uploadSuccess,
  uploadFailed,
  delete,
  deleteSuccess,
  deleteFailed,
  download,
  downloadSuccess,
  downloadFailed;

  bool get isProcessing =>
      this == AppProcessStatus.upload ||
      this == AppProcessStatus.delete ||
      this == AppProcessStatus.download;

  bool get isWaiting => this == AppProcessStatus.waiting;
}

@freezed
class AppProcess with _$AppProcess {
  const factory AppProcess({
    required String id,
    required AppMedia media,
    required AppProcessStatus status,
    Object? response,
    @Default(0) double progress,
  }) = _AppProcess;
}

