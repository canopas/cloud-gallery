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
  return _DownloadMediaProcess.fromJson(json);
}

/// @nodoc
mixin _$DownloadMediaProcess {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get media_id => throw _privateConstructorUsedError;
  String get folder_id => throw _privateConstructorUsedError;
  int get notification_id => throw _privateConstructorUsedError;
  MediaProvider get provider => throw _privateConstructorUsedError;
  MediaQueueProcessStatus get status => throw _privateConstructorUsedError;
  @LocalDatabaseAppMediaConverter()
  AppMedia? get response => throw _privateConstructorUsedError;
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
      String name,
      String media_id,
      String folder_id,
      int notification_id,
      MediaProvider provider,
      MediaQueueProcessStatus status,
      @LocalDatabaseAppMediaConverter() AppMedia? response,
      int total,
      String extension,
      int chunk});

  $AppMediaCopyWith<$Res>? get response;
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
    Object? name = null,
    Object? media_id = null,
    Object? folder_id = null,
    Object? notification_id = null,
    Object? provider = null,
    Object? status = null,
    Object? response = freezed,
    Object? total = null,
    Object? extension = null,
    Object? chunk = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      media_id: null == media_id
          ? _value.media_id
          : media_id // ignore: cast_nullable_to_non_nullable
              as String,
      folder_id: null == folder_id
          ? _value.folder_id
          : folder_id // ignore: cast_nullable_to_non_nullable
              as String,
      notification_id: null == notification_id
          ? _value.notification_id
          : notification_id // ignore: cast_nullable_to_non_nullable
              as int,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as MediaProvider,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MediaQueueProcessStatus,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as AppMedia?,
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

  /// Create a copy of DownloadMediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppMediaCopyWith<$Res>? get response {
    if (_value.response == null) {
      return null;
    }

    return $AppMediaCopyWith<$Res>(_value.response!, (value) {
      return _then(_value.copyWith(response: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DownloadMediaProcessImplCopyWith<$Res>
    implements $DownloadMediaProcessCopyWith<$Res> {
  factory _$$DownloadMediaProcessImplCopyWith(_$DownloadMediaProcessImpl value,
          $Res Function(_$DownloadMediaProcessImpl) then) =
      __$$DownloadMediaProcessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String media_id,
      String folder_id,
      int notification_id,
      MediaProvider provider,
      MediaQueueProcessStatus status,
      @LocalDatabaseAppMediaConverter() AppMedia? response,
      int total,
      String extension,
      int chunk});

  @override
  $AppMediaCopyWith<$Res>? get response;
}

/// @nodoc
class __$$DownloadMediaProcessImplCopyWithImpl<$Res>
    extends _$DownloadMediaProcessCopyWithImpl<$Res, _$DownloadMediaProcessImpl>
    implements _$$DownloadMediaProcessImplCopyWith<$Res> {
  __$$DownloadMediaProcessImplCopyWithImpl(_$DownloadMediaProcessImpl _value,
      $Res Function(_$DownloadMediaProcessImpl) _then)
      : super(_value, _then);

  /// Create a copy of DownloadMediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? media_id = null,
    Object? folder_id = null,
    Object? notification_id = null,
    Object? provider = null,
    Object? status = null,
    Object? response = freezed,
    Object? total = null,
    Object? extension = null,
    Object? chunk = null,
  }) {
    return _then(_$DownloadMediaProcessImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      media_id: null == media_id
          ? _value.media_id
          : media_id // ignore: cast_nullable_to_non_nullable
              as String,
      folder_id: null == folder_id
          ? _value.folder_id
          : folder_id // ignore: cast_nullable_to_non_nullable
              as String,
      notification_id: null == notification_id
          ? _value.notification_id
          : notification_id // ignore: cast_nullable_to_non_nullable
              as int,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as MediaProvider,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MediaQueueProcessStatus,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as AppMedia?,
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
class _$DownloadMediaProcessImpl extends _DownloadMediaProcess {
  const _$DownloadMediaProcessImpl(
      {required this.id,
      required this.name,
      required this.media_id,
      required this.folder_id,
      required this.notification_id,
      required this.provider,
      this.status = MediaQueueProcessStatus.waiting,
      @LocalDatabaseAppMediaConverter() this.response,
      this.total = 1,
      required this.extension,
      this.chunk = 0})
      : super._();

  factory _$DownloadMediaProcessImpl.fromJson(Map<String, dynamic> json) =>
      _$$DownloadMediaProcessImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String media_id;
  @override
  final String folder_id;
  @override
  final int notification_id;
  @override
  final MediaProvider provider;
  @override
  @JsonKey()
  final MediaQueueProcessStatus status;
  @override
  @LocalDatabaseAppMediaConverter()
  final AppMedia? response;
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
    return 'DownloadMediaProcess(id: $id, name: $name, media_id: $media_id, folder_id: $folder_id, notification_id: $notification_id, provider: $provider, status: $status, response: $response, total: $total, extension: $extension, chunk: $chunk)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadMediaProcessImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.media_id, media_id) ||
                other.media_id == media_id) &&
            (identical(other.folder_id, folder_id) ||
                other.folder_id == folder_id) &&
            (identical(other.notification_id, notification_id) ||
                other.notification_id == notification_id) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.extension, extension) ||
                other.extension == extension) &&
            (identical(other.chunk, chunk) || other.chunk == chunk));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, media_id, folder_id,
      notification_id, provider, status, response, total, extension, chunk);

  /// Create a copy of DownloadMediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadMediaProcessImplCopyWith<_$DownloadMediaProcessImpl>
      get copyWith =>
          __$$DownloadMediaProcessImplCopyWithImpl<_$DownloadMediaProcessImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DownloadMediaProcessImplToJson(
      this,
    );
  }
}

abstract class _DownloadMediaProcess extends DownloadMediaProcess {
  const factory _DownloadMediaProcess(
      {required final String id,
      required final String name,
      required final String media_id,
      required final String folder_id,
      required final int notification_id,
      required final MediaProvider provider,
      final MediaQueueProcessStatus status,
      @LocalDatabaseAppMediaConverter() final AppMedia? response,
      final int total,
      required final String extension,
      final int chunk}) = _$DownloadMediaProcessImpl;
  const _DownloadMediaProcess._() : super._();

  factory _DownloadMediaProcess.fromJson(Map<String, dynamic> json) =
      _$DownloadMediaProcessImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get media_id;
  @override
  String get folder_id;
  @override
  int get notification_id;
  @override
  MediaProvider get provider;
  @override
  MediaQueueProcessStatus get status;
  @override
  @LocalDatabaseAppMediaConverter()
  AppMedia? get response;
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
  _$$DownloadMediaProcessImplCopyWith<_$DownloadMediaProcessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UploadMediaProcess _$UploadMediaProcessFromJson(Map<String, dynamic> json) {
  return _UploadMediaProcess.fromJson(json);
}

/// @nodoc
mixin _$UploadMediaProcess {
  String get id => throw _privateConstructorUsedError;
  String get media_id => throw _privateConstructorUsedError;
  int get notification_id => throw _privateConstructorUsedError;
  String get folder_id => throw _privateConstructorUsedError;
  String? get upload_session_id => throw _privateConstructorUsedError;
  MediaProvider get provider => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  String? get mime_type => throw _privateConstructorUsedError;
  MediaQueueProcessStatus get status => throw _privateConstructorUsedError;
  @LocalDatabaseBoolConverter()
  bool get upload_using_auto_backup => throw _privateConstructorUsedError;
  @LocalDatabaseAppMediaConverter()
  AppMedia? get response => throw _privateConstructorUsedError;
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
      String media_id,
      int notification_id,
      String folder_id,
      String? upload_session_id,
      MediaProvider provider,
      String path,
      String? mime_type,
      MediaQueueProcessStatus status,
      @LocalDatabaseBoolConverter() bool upload_using_auto_backup,
      @LocalDatabaseAppMediaConverter() AppMedia? response,
      int total,
      int chunk});

  $AppMediaCopyWith<$Res>? get response;
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
    Object? media_id = null,
    Object? notification_id = null,
    Object? folder_id = null,
    Object? upload_session_id = freezed,
    Object? provider = null,
    Object? path = null,
    Object? mime_type = freezed,
    Object? status = null,
    Object? upload_using_auto_backup = null,
    Object? response = freezed,
    Object? total = null,
    Object? chunk = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      media_id: null == media_id
          ? _value.media_id
          : media_id // ignore: cast_nullable_to_non_nullable
              as String,
      notification_id: null == notification_id
          ? _value.notification_id
          : notification_id // ignore: cast_nullable_to_non_nullable
              as int,
      folder_id: null == folder_id
          ? _value.folder_id
          : folder_id // ignore: cast_nullable_to_non_nullable
              as String,
      upload_session_id: freezed == upload_session_id
          ? _value.upload_session_id
          : upload_session_id // ignore: cast_nullable_to_non_nullable
              as String?,
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
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as AppMedia?,
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

  /// Create a copy of UploadMediaProcess
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppMediaCopyWith<$Res>? get response {
    if (_value.response == null) {
      return null;
    }

    return $AppMediaCopyWith<$Res>(_value.response!, (value) {
      return _then(_value.copyWith(response: value) as $Val);
    });
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
      String media_id,
      int notification_id,
      String folder_id,
      String? upload_session_id,
      MediaProvider provider,
      String path,
      String? mime_type,
      MediaQueueProcessStatus status,
      @LocalDatabaseBoolConverter() bool upload_using_auto_backup,
      @LocalDatabaseAppMediaConverter() AppMedia? response,
      int total,
      int chunk});

  @override
  $AppMediaCopyWith<$Res>? get response;
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
    Object? media_id = null,
    Object? notification_id = null,
    Object? folder_id = null,
    Object? upload_session_id = freezed,
    Object? provider = null,
    Object? path = null,
    Object? mime_type = freezed,
    Object? status = null,
    Object? upload_using_auto_backup = null,
    Object? response = freezed,
    Object? total = null,
    Object? chunk = null,
  }) {
    return _then(_$UploadMediaProcessImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      media_id: null == media_id
          ? _value.media_id
          : media_id // ignore: cast_nullable_to_non_nullable
              as String,
      notification_id: null == notification_id
          ? _value.notification_id
          : notification_id // ignore: cast_nullable_to_non_nullable
              as int,
      folder_id: null == folder_id
          ? _value.folder_id
          : folder_id // ignore: cast_nullable_to_non_nullable
              as String,
      upload_session_id: freezed == upload_session_id
          ? _value.upload_session_id
          : upload_session_id // ignore: cast_nullable_to_non_nullable
              as String?,
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
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as AppMedia?,
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
class _$UploadMediaProcessImpl extends _UploadMediaProcess {
  const _$UploadMediaProcessImpl(
      {required this.id,
      required this.media_id,
      required this.notification_id,
      required this.folder_id,
      this.upload_session_id,
      required this.provider,
      required this.path,
      this.mime_type,
      this.status = MediaQueueProcessStatus.waiting,
      @LocalDatabaseBoolConverter() this.upload_using_auto_backup = false,
      @LocalDatabaseAppMediaConverter() this.response,
      this.total = 1,
      this.chunk = 0})
      : super._();

  factory _$UploadMediaProcessImpl.fromJson(Map<String, dynamic> json) =>
      _$$UploadMediaProcessImplFromJson(json);

  @override
  final String id;
  @override
  final String media_id;
  @override
  final int notification_id;
  @override
  final String folder_id;
  @override
  final String? upload_session_id;
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
  @LocalDatabaseAppMediaConverter()
  final AppMedia? response;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int chunk;

  @override
  String toString() {
    return 'UploadMediaProcess(id: $id, media_id: $media_id, notification_id: $notification_id, folder_id: $folder_id, upload_session_id: $upload_session_id, provider: $provider, path: $path, mime_type: $mime_type, status: $status, upload_using_auto_backup: $upload_using_auto_backup, response: $response, total: $total, chunk: $chunk)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadMediaProcessImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.media_id, media_id) ||
                other.media_id == media_id) &&
            (identical(other.notification_id, notification_id) ||
                other.notification_id == notification_id) &&
            (identical(other.folder_id, folder_id) ||
                other.folder_id == folder_id) &&
            (identical(other.upload_session_id, upload_session_id) ||
                other.upload_session_id == upload_session_id) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.mime_type, mime_type) ||
                other.mime_type == mime_type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(
                    other.upload_using_auto_backup, upload_using_auto_backup) ||
                other.upload_using_auto_backup == upload_using_auto_backup) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.chunk, chunk) || other.chunk == chunk));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      media_id,
      notification_id,
      folder_id,
      upload_session_id,
      provider,
      path,
      mime_type,
      status,
      upload_using_auto_backup,
      response,
      total,
      chunk);

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

abstract class _UploadMediaProcess extends UploadMediaProcess {
  const factory _UploadMediaProcess(
      {required final String id,
      required final String media_id,
      required final int notification_id,
      required final String folder_id,
      final String? upload_session_id,
      required final MediaProvider provider,
      required final String path,
      final String? mime_type,
      final MediaQueueProcessStatus status,
      @LocalDatabaseBoolConverter() final bool upload_using_auto_backup,
      @LocalDatabaseAppMediaConverter() final AppMedia? response,
      final int total,
      final int chunk}) = _$UploadMediaProcessImpl;
  const _UploadMediaProcess._() : super._();

  factory _UploadMediaProcess.fromJson(Map<String, dynamic> json) =
      _$UploadMediaProcessImpl.fromJson;

  @override
  String get id;
  @override
  String get media_id;
  @override
  int get notification_id;
  @override
  String get folder_id;
  @override
  String? get upload_session_id;
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
  @LocalDatabaseAppMediaConverter()
  AppMedia? get response;
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
