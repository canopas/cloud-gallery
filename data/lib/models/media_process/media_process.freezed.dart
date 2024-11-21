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

/// @nodoc
mixin _$MediaProcess {
  String get id => throw _privateConstructorUsedError;
  String get folder_id => throw _privateConstructorUsedError;
  AppMediaSource get source => throw _privateConstructorUsedError;
  String get local_path => throw _privateConstructorUsedError;
  MediaQueueProcessStatus get status => throw _privateConstructorUsedError;
  bool get uploading_using_auto_backup => throw _privateConstructorUsedError;
  Object? get response => throw _privateConstructorUsedError;
  MediaProcessProgress? get progress => throw _privateConstructorUsedError;

  /// Create a copy of MediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaProcessCopyWith<MediaProcess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaProcessCopyWith<$Res> {
  factory $MediaProcessCopyWith(
          MediaProcess value, $Res Function(MediaProcess) then) =
      _$MediaProcessCopyWithImpl<$Res, MediaProcess>;
  @useResult
  $Res call(
      {String id,
      String folder_id,
      AppMediaSource source,
      String local_path,
      MediaQueueProcessStatus status,
      bool uploading_using_auto_backup,
      Object? response,
      MediaProcessProgress? progress});

  $MediaProcessProgressCopyWith<$Res>? get progress;
}

/// @nodoc
class _$MediaProcessCopyWithImpl<$Res, $Val extends MediaProcess>
    implements $MediaProcessCopyWith<$Res> {
  _$MediaProcessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? folder_id = null,
    Object? source = null,
    Object? local_path = null,
    Object? status = null,
    Object? uploading_using_auto_backup = null,
    Object? response = freezed,
    Object? progress = freezed,
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
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as AppMediaSource,
      local_path: null == local_path
          ? _value.local_path
          : local_path // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MediaQueueProcessStatus,
      uploading_using_auto_backup: null == uploading_using_auto_backup
          ? _value.uploading_using_auto_backup
          : uploading_using_auto_backup // ignore: cast_nullable_to_non_nullable
              as bool,
      response: freezed == response ? _value.response : response,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as MediaProcessProgress?,
    ) as $Val);
  }

  /// Create a copy of MediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MediaProcessProgressCopyWith<$Res>? get progress {
    if (_value.progress == null) {
      return null;
    }

    return $MediaProcessProgressCopyWith<$Res>(_value.progress!, (value) {
      return _then(_value.copyWith(progress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MediaProcessImplCopyWith<$Res>
    implements $MediaProcessCopyWith<$Res> {
  factory _$$MediaProcessImplCopyWith(
          _$MediaProcessImpl value, $Res Function(_$MediaProcessImpl) then) =
      __$$MediaProcessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String folder_id,
      AppMediaSource source,
      String local_path,
      MediaQueueProcessStatus status,
      bool uploading_using_auto_backup,
      Object? response,
      MediaProcessProgress? progress});

  @override
  $MediaProcessProgressCopyWith<$Res>? get progress;
}

/// @nodoc
class __$$MediaProcessImplCopyWithImpl<$Res>
    extends _$MediaProcessCopyWithImpl<$Res, _$MediaProcessImpl>
    implements _$$MediaProcessImplCopyWith<$Res> {
  __$$MediaProcessImplCopyWithImpl(
      _$MediaProcessImpl _value, $Res Function(_$MediaProcessImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? folder_id = null,
    Object? source = null,
    Object? local_path = null,
    Object? status = null,
    Object? uploading_using_auto_backup = null,
    Object? response = freezed,
    Object? progress = freezed,
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
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as AppMediaSource,
      local_path: null == local_path
          ? _value.local_path
          : local_path // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MediaQueueProcessStatus,
      uploading_using_auto_backup: null == uploading_using_auto_backup
          ? _value.uploading_using_auto_backup
          : uploading_using_auto_backup // ignore: cast_nullable_to_non_nullable
              as bool,
      response: freezed == response ? _value.response : response,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as MediaProcessProgress?,
    ));
  }
}

/// @nodoc

class _$MediaProcessImpl implements _MediaProcess {
  const _$MediaProcessImpl(
      {required this.id,
      required this.folder_id,
      required this.source,
      required this.local_path,
      required this.status,
      this.uploading_using_auto_backup = false,
      this.response,
      this.progress = null});

  @override
  final String id;
  @override
  final String folder_id;
  @override
  final AppMediaSource source;
  @override
  final String local_path;
  @override
  final MediaQueueProcessStatus status;
  @override
  @JsonKey()
  final bool uploading_using_auto_backup;
  @override
  final Object? response;
  @override
  @JsonKey()
  final MediaProcessProgress? progress;

  @override
  String toString() {
    return 'MediaProcess(id: $id, folder_id: $folder_id, source: $source, local_path: $local_path, status: $status, uploading_using_auto_backup: $uploading_using_auto_backup, response: $response, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaProcessImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.folder_id, folder_id) ||
                other.folder_id == folder_id) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.local_path, local_path) ||
                other.local_path == local_path) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.uploading_using_auto_backup,
                    uploading_using_auto_backup) ||
                other.uploading_using_auto_backup ==
                    uploading_using_auto_backup) &&
            const DeepCollectionEquality().equals(other.response, response) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      folder_id,
      source,
      local_path,
      status,
      uploading_using_auto_backup,
      const DeepCollectionEquality().hash(response),
      progress);

  /// Create a copy of MediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaProcessImplCopyWith<_$MediaProcessImpl> get copyWith =>
      __$$MediaProcessImplCopyWithImpl<_$MediaProcessImpl>(this, _$identity);
}

abstract class _MediaProcess implements MediaProcess {
  const factory _MediaProcess(
      {required final String id,
      required final String folder_id,
      required final AppMediaSource source,
      required final String local_path,
      required final MediaQueueProcessStatus status,
      final bool uploading_using_auto_backup,
      final Object? response,
      final MediaProcessProgress? progress}) = _$MediaProcessImpl;

  @override
  String get id;
  @override
  String get folder_id;
  @override
  AppMediaSource get source;
  @override
  String get local_path;
  @override
  MediaQueueProcessStatus get status;
  @override
  bool get uploading_using_auto_backup;
  @override
  Object? get response;
  @override
  MediaProcessProgress? get progress;

  /// Create a copy of MediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaProcessImplCopyWith<_$MediaProcessImpl> get copyWith =>
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
