// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_process.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DownloadMediaProcess _$DownloadMediaProcessFromJson(Map<String, dynamic> json) {
  return _MediaProcess.fromJson(json);
}

/// @nodoc
mixin _$DownloadMediaProcess {
  String get id => throw _privateConstructorUsedError;
  String get folder_id => throw _privateConstructorUsedError;
  MediaProvider get provider => throw _privateConstructorUsedError;
  MediaQueueProcessStatus get status => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  String get extension => throw _privateConstructorUsedError;
  int get chunk => throw _privateConstructorUsedError;

  /// Serializes this DownloadMediaProcess to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DownloadMediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DownloadMediaProcessCopyWith<DownloadMediaProcess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadMediaProcessCopyWith<$Res> {
  factory $DownloadMediaProcessCopyWith(DownloadMediaProcess value,
          $Res Function(DownloadMediaProcess) then) =
      _$DownloadMediaProcessCopyWithImpl<$Res, DownloadMediaProcess>;
  @useResult
  $Res call(
      {String id,
      String folder_id,
      MediaProvider provider,
      MediaQueueProcessStatus status,
      int total,
      String extension,
      int chunk});
}

/// @nodoc
class _$DownloadMediaProcessCopyWithImpl<$Res,
        $Val extends DownloadMediaProcess>
    implements $DownloadMediaProcessCopyWith<$Res> {
  _$DownloadMediaProcessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DownloadMediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? folder_id = null,
    Object? provider = null,
    Object? status = null,
    Object? total = null,
    Object? extension = null,
    Object? chunk = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      folder_id: null == folder_id
          ? _value.folder_id
          : folder_id // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as MediaProvider,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MediaQueueProcessStatus,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      extension: null == extension
          ? _value.extension
          : extension // ignore: cast_nullable_to_non_nullable
              as String,
      chunk: null == chunk
          ? _value.chunk
          : chunk // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MediaProcessImplCopyWith<$Res>
    implements $DownloadMediaProcessCopyWith<$Res> {
  factory _$$MediaProcessImplCopyWith(
          _$MediaProcessImpl value, $Res Function(_$MediaProcessImpl) then) =
      __$$MediaProcessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String folder_id,
      MediaProvider provider,
      MediaQueueProcessStatus status,
      int total,
      String extension,
      int chunk});
}

/// @nodoc
class __$$MediaProcessImplCopyWithImpl<$Res>
    extends _$DownloadMediaProcessCopyWithImpl<$Res, _$MediaProcessImpl>
    implements _$$MediaProcessImplCopyWith<$Res> {
  __$$MediaProcessImplCopyWithImpl(
      _$MediaProcessImpl _value, $Res Function(_$MediaProcessImpl) _then)
      : super(_value, _then);

  /// Create a copy of DownloadMediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? folder_id = null,
    Object? provider = null,
    Object? status = null,
    Object? total = null,
    Object? extension = null,
    Object? chunk = null,
  }) {
    return _then(_$MediaProcessImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      folder_id: null == folder_id
          ? _value.folder_id
          : folder_id // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as MediaProvider,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MediaQueueProcessStatus,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      extension: null == extension
          ? _value.extension
          : extension // ignore: cast_nullable_to_non_nullable
              as String,
      chunk: null == chunk
          ? _value.chunk
          : chunk // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaProcessImpl implements _MediaProcess {
  const _$MediaProcessImpl(
      {required this.id,
      required this.folder_id,
      required this.provider,
      this.status = MediaQueueProcessStatus.waiting,
      this.total = 1,
      required this.extension,
      this.chunk = 0});

  factory _$MediaProcessImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaProcessImplFromJson(json);

  @override
  final String id;
  @override
  final String folder_id;
  @override
  final MediaProvider provider;
  @override
  @JsonKey()
  final MediaQueueProcessStatus status;
  @override
  @JsonKey()
  final int total;
  @override
  final String extension;
  @override
  @JsonKey()
  final int chunk;

  @override
  String toString() {
    return 'DownloadMediaProcess(id: $id, folder_id: $folder_id, provider: $provider, status: $status, total: $total, extension: $extension, chunk: $chunk)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaProcessImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.folder_id, folder_id) ||
                other.folder_id == folder_id) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.extension, extension) ||
                other.extension == extension) &&
            (identical(other.chunk, chunk) || other.chunk == chunk));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, folder_id, provider, status, total, extension, chunk);

  /// Create a copy of DownloadMediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaProcessImplCopyWith<_$MediaProcessImpl> get copyWith =>
      __$$MediaProcessImplCopyWithImpl<_$MediaProcessImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaProcessImplToJson(
      this,
    );
  }
}

abstract class _MediaProcess implements DownloadMediaProcess {
  const factory _MediaProcess(
      {required final String id,
      required final String folder_id,
      required final MediaProvider provider,
      final MediaQueueProcessStatus status,
      final int total,
      required final String extension,
      final int chunk}) = _$MediaProcessImpl;

  factory _MediaProcess.fromJson(Map<String, dynamic> json) =
      _$MediaProcessImpl.fromJson;

  @override
  String get id;
  @override
  String get folder_id;
  @override
  MediaProvider get provider;
  @override
  MediaQueueProcessStatus get status;
  @override
  int get total;
  @override
  String get extension;
  @override
  int get chunk;

  /// Create a copy of DownloadMediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaProcessImplCopyWith<_$MediaProcessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UploadMediaProcess _$UploadMediaProcessFromJson(Map<String, dynamic> json) {
  return _UploadMediaProcess.fromJson(json);
}

/// @nodoc
mixin _$UploadMediaProcess {
  String get id => throw _privateConstructorUsedError;
  String get folder_id => throw _privateConstructorUsedError;
  MediaProvider get provider => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  String? get mime_type => throw _privateConstructorUsedError;
  MediaQueueProcessStatus get status => throw _privateConstructorUsedError;
  @LocalDatabaseBoolConverter()
  bool get upload_using_auto_backup => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get chunk => throw _privateConstructorUsedError;

  /// Serializes this UploadMediaProcess to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UploadMediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UploadMediaProcessCopyWith<UploadMediaProcess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadMediaProcessCopyWith<$Res> {
  factory $UploadMediaProcessCopyWith(
          UploadMediaProcess value, $Res Function(UploadMediaProcess) then) =
      _$UploadMediaProcessCopyWithImpl<$Res, UploadMediaProcess>;
  @useResult
  $Res call(
      {String id,
      String folder_id,
      MediaProvider provider,
      String path,
      String? mime_type,
      MediaQueueProcessStatus status,
      @LocalDatabaseBoolConverter() bool upload_using_auto_backup,
      int total,
      int chunk});
}

/// @nodoc
class _$UploadMediaProcessCopyWithImpl<$Res, $Val extends UploadMediaProcess>
    implements $UploadMediaProcessCopyWith<$Res> {
  _$UploadMediaProcessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadMediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? folder_id = null,
    Object? provider = null,
    Object? path = null,
    Object? mime_type = freezed,
    Object? status = null,
    Object? upload_using_auto_backup = null,
    Object? total = null,
    Object? chunk = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      folder_id: null == folder_id
          ? _value.folder_id
          : folder_id // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as MediaProvider,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      mime_type: freezed == mime_type
          ? _value.mime_type
          : mime_type // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MediaQueueProcessStatus,
      upload_using_auto_backup: null == upload_using_auto_backup
          ? _value.upload_using_auto_backup
          : upload_using_auto_backup // ignore: cast_nullable_to_non_nullable
              as bool,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      chunk: null == chunk
          ? _value.chunk
          : chunk // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UploadMediaProcessImplCopyWith<$Res>
    implements $UploadMediaProcessCopyWith<$Res> {
  factory _$$UploadMediaProcessImplCopyWith(_$UploadMediaProcessImpl value,
          $Res Function(_$UploadMediaProcessImpl) then) =
      __$$UploadMediaProcessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String folder_id,
      MediaProvider provider,
      String path,
      String? mime_type,
      MediaQueueProcessStatus status,
      @LocalDatabaseBoolConverter() bool upload_using_auto_backup,
      int total,
      int chunk});
}

/// @nodoc
class __$$UploadMediaProcessImplCopyWithImpl<$Res>
    extends _$UploadMediaProcessCopyWithImpl<$Res, _$UploadMediaProcessImpl>
    implements _$$UploadMediaProcessImplCopyWith<$Res> {
  __$$UploadMediaProcessImplCopyWithImpl(_$UploadMediaProcessImpl _value,
      $Res Function(_$UploadMediaProcessImpl) _then)
      : super(_value, _then);

  /// Create a copy of UploadMediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? folder_id = null,
    Object? provider = null,
    Object? path = null,
    Object? mime_type = freezed,
    Object? status = null,
    Object? upload_using_auto_backup = null,
    Object? total = null,
    Object? chunk = null,
  }) {
    return _then(_$UploadMediaProcessImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      folder_id: null == folder_id
          ? _value.folder_id
          : folder_id // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as MediaProvider,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      mime_type: freezed == mime_type
          ? _value.mime_type
          : mime_type // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MediaQueueProcessStatus,
      upload_using_auto_backup: null == upload_using_auto_backup
          ? _value.upload_using_auto_backup
          : upload_using_auto_backup // ignore: cast_nullable_to_non_nullable
              as bool,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      chunk: null == chunk
          ? _value.chunk
          : chunk // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UploadMediaProcessImpl implements _UploadMediaProcess {
  const _$UploadMediaProcessImpl(
      {required this.id,
      required this.folder_id,
      required this.provider,
      required this.path,
      this.mime_type,
      this.status = MediaQueueProcessStatus.waiting,
      @LocalDatabaseBoolConverter() this.upload_using_auto_backup = false,
      this.total = 1,
      this.chunk = 0});

  factory _$UploadMediaProcessImpl.fromJson(Map<String, dynamic> json) =>
      _$$UploadMediaProcessImplFromJson(json);

  @override
  final String id;
  @override
  final String folder_id;
  @override
  final MediaProvider provider;
  @override
  final String path;
  @override
  final String? mime_type;
  @override
  @JsonKey()
  final MediaQueueProcessStatus status;
  @override
  @JsonKey()
  @LocalDatabaseBoolConverter()
  final bool upload_using_auto_backup;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int chunk;

  @override
  String toString() {
    return 'UploadMediaProcess(id: $id, folder_id: $folder_id, provider: $provider, path: $path, mime_type: $mime_type, status: $status, upload_using_auto_backup: $upload_using_auto_backup, total: $total, chunk: $chunk)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadMediaProcessImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.folder_id, folder_id) ||
                other.folder_id == folder_id) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.mime_type, mime_type) ||
                other.mime_type == mime_type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(
                    other.upload_using_auto_backup, upload_using_auto_backup) ||
                other.upload_using_auto_backup == upload_using_auto_backup) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.chunk, chunk) || other.chunk == chunk));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, folder_id, provider, path,
      mime_type, status, upload_using_auto_backup, total, chunk);

  /// Create a copy of UploadMediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadMediaProcessImplCopyWith<_$UploadMediaProcessImpl> get copyWith =>
      __$$UploadMediaProcessImplCopyWithImpl<_$UploadMediaProcessImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UploadMediaProcessImplToJson(
      this,
    );
  }
}

abstract class _UploadMediaProcess implements UploadMediaProcess {
  const factory _UploadMediaProcess(
      {required final String id,
      required final String folder_id,
      required final MediaProvider provider,
      required final String path,
      final String? mime_type,
      final MediaQueueProcessStatus status,
      @LocalDatabaseBoolConverter() final bool upload_using_auto_backup,
      final int total,
      final int chunk}) = _$UploadMediaProcessImpl;

  factory _UploadMediaProcess.fromJson(Map<String, dynamic> json) =
      _$UploadMediaProcessImpl.fromJson;

  @override
  String get id;
  @override
  String get folder_id;
  @override
  MediaProvider get provider;
  @override
  String get path;
  @override
  String? get mime_type;
  @override
  MediaQueueProcessStatus get status;
  @override
  @LocalDatabaseBoolConverter()
  bool get upload_using_auto_backup;
  @override
  int get total;
  @override
  int get chunk;

  /// Create a copy of UploadMediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadMediaProcessImplCopyWith<_$UploadMediaProcessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MediaProcessProgress _$MediaProcessProgressFromJson(Map<String, dynamic> json) {
  return _MediaProcessProgress.fromJson(json);
}

/// @nodoc
mixin _$MediaProcessProgress {
  int get total => throw _privateConstructorUsedError;
  int get chunk => throw _privateConstructorUsedError;

  /// Serializes this MediaProcessProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MediaProcessProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaProcessProgressCopyWith<MediaProcessProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaProcessProgressCopyWith<$Res> {
  factory $MediaProcessProgressCopyWith(MediaProcessProgress value,
          $Res Function(MediaProcessProgress) then) =
      _$MediaProcessProgressCopyWithImpl<$Res, MediaProcessProgress>;
  @useResult
  $Res call({int total, int chunk});
}

/// @nodoc
class _$MediaProcessProgressCopyWithImpl<$Res,
        $Val extends MediaProcessProgress>
    implements $MediaProcessProgressCopyWith<$Res> {
  _$MediaProcessProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaProcessProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? chunk = null,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      chunk: null == chunk
          ? _value.chunk
          : chunk // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MediaProcessProgressImplCopyWith<$Res>
    implements $MediaProcessProgressCopyWith<$Res> {
  factory _$$MediaProcessProgressImplCopyWith(_$MediaProcessProgressImpl value,
          $Res Function(_$MediaProcessProgressImpl) then) =
      __$$MediaProcessProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, int chunk});
}

/// @nodoc
class __$$MediaProcessProgressImplCopyWithImpl<$Res>
    extends _$MediaProcessProgressCopyWithImpl<$Res, _$MediaProcessProgressImpl>
    implements _$$MediaProcessProgressImplCopyWith<$Res> {
  __$$MediaProcessProgressImplCopyWithImpl(_$MediaProcessProgressImpl _value,
      $Res Function(_$MediaProcessProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaProcessProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? chunk = null,
  }) {
    return _then(_$MediaProcessProgressImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      chunk: null == chunk
          ? _value.chunk
          : chunk // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaProcessProgressImpl extends _MediaProcessProgress {
  const _$MediaProcessProgressImpl({required this.total, required this.chunk})
      : super._();

  factory _$MediaProcessProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaProcessProgressImplFromJson(json);

  @override
  final int total;
  @override
  final int chunk;

  @override
  String toString() {
    return 'MediaProcessProgress(total: $total, chunk: $chunk)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaProcessProgressImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.chunk, chunk) || other.chunk == chunk));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, total, chunk);

  /// Create a copy of MediaProcessProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaProcessProgressImplCopyWith<_$MediaProcessProgressImpl>
      get copyWith =>
          __$$MediaProcessProgressImplCopyWithImpl<_$MediaProcessProgressImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaProcessProgressImplToJson(
      this,
    );
  }
}

abstract class _MediaProcessProgress extends MediaProcessProgress {
  const factory _MediaProcessProgress(
      {required final int total,
      required final int chunk}) = _$MediaProcessProgressImpl;
  const _MediaProcessProgress._() : super._();

  factory _MediaProcessProgress.fromJson(Map<String, dynamic> json) =
      _$MediaProcessProgressImpl.fromJson;

  @override
  int get total;
  @override
  int get chunk;

  /// Create a copy of MediaProcessProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaProcessProgressImplCopyWith<_$MediaProcessProgressImpl>
      get copyWith => throw _privateConstructorUsedError;
}
