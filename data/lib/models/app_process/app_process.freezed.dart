// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_process.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppProcess {
  String get id => throw _privateConstructorUsedError;
  AppMedia get media => throw _privateConstructorUsedError;
  AppProcessStatus get status => throw _privateConstructorUsedError;
  bool get isFromAutoBackup => throw _privateConstructorUsedError;
  Object? get response => throw _privateConstructorUsedError;
  AppProcessProgress? get progress => throw _privateConstructorUsedError;

  /// Create a copy of AppProcess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppProcessCopyWith<AppProcess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppProcessCopyWith<$Res> {
  factory $AppProcessCopyWith(
          AppProcess value, $Res Function(AppProcess) then) =
      _$AppProcessCopyWithImpl<$Res, AppProcess>;
  @useResult
  $Res call(
      {String id,
      AppMedia media,
      AppProcessStatus status,
      bool isFromAutoBackup,
      Object? response,
      AppProcessProgress? progress});

  $AppMediaCopyWith<$Res> get media;
  $AppProcessProgressCopyWith<$Res>? get progress;
}

/// @nodoc
class _$AppProcessCopyWithImpl<$Res, $Val extends AppProcess>
    implements $AppProcessCopyWith<$Res> {
  _$AppProcessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppProcess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? media = null,
    Object? status = null,
    Object? isFromAutoBackup = null,
    Object? response = freezed,
    Object? progress = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as AppMedia,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AppProcessStatus,
      isFromAutoBackup: null == isFromAutoBackup
          ? _value.isFromAutoBackup
          : isFromAutoBackup // ignore: cast_nullable_to_non_nullable
              as bool,
      response: freezed == response ? _value.response : response,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as AppProcessProgress?,
    ) as $Val);
  }

  /// Create a copy of AppProcess
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppMediaCopyWith<$Res> get media {
    return $AppMediaCopyWith<$Res>(_value.media, (value) {
      return _then(_value.copyWith(media: value) as $Val);
    });
  }

  /// Create a copy of AppProcess
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppProcessProgressCopyWith<$Res>? get progress {
    if (_value.progress == null) {
      return null;
    }

    return $AppProcessProgressCopyWith<$Res>(_value.progress!, (value) {
      return _then(_value.copyWith(progress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppProcessImplCopyWith<$Res>
    implements $AppProcessCopyWith<$Res> {
  factory _$$AppProcessImplCopyWith(
          _$AppProcessImpl value, $Res Function(_$AppProcessImpl) then) =
      __$$AppProcessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      AppMedia media,
      AppProcessStatus status,
      bool isFromAutoBackup,
      Object? response,
      AppProcessProgress? progress});

  @override
  $AppMediaCopyWith<$Res> get media;
  @override
  $AppProcessProgressCopyWith<$Res>? get progress;
}

/// @nodoc
class __$$AppProcessImplCopyWithImpl<$Res>
    extends _$AppProcessCopyWithImpl<$Res, _$AppProcessImpl>
    implements _$$AppProcessImplCopyWith<$Res> {
  __$$AppProcessImplCopyWithImpl(
      _$AppProcessImpl _value, $Res Function(_$AppProcessImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppProcess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? media = null,
    Object? status = null,
    Object? isFromAutoBackup = null,
    Object? response = freezed,
    Object? progress = freezed,
  }) {
    return _then(_$AppProcessImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as AppMedia,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AppProcessStatus,
      isFromAutoBackup: null == isFromAutoBackup
          ? _value.isFromAutoBackup
          : isFromAutoBackup // ignore: cast_nullable_to_non_nullable
              as bool,
      response: freezed == response ? _value.response : response,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as AppProcessProgress?,
    ));
  }
}

/// @nodoc

class _$AppProcessImpl implements _AppProcess {
  const _$AppProcessImpl(
      {required this.id,
      required this.media,
      required this.status,
      this.isFromAutoBackup = false,
      this.response,
      this.progress = null});

  @override
  final String id;
  @override
  final AppMedia media;
  @override
  final AppProcessStatus status;
  @override
  @JsonKey()
  final bool isFromAutoBackup;
  @override
  final Object? response;
  @override
  @JsonKey()
  final AppProcessProgress? progress;

  @override
  String toString() {
    return 'AppProcess(id: $id, media: $media, status: $status, isFromAutoBackup: $isFromAutoBackup, response: $response, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppProcessImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.media, media) || other.media == media) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isFromAutoBackup, isFromAutoBackup) ||
                other.isFromAutoBackup == isFromAutoBackup) &&
            const DeepCollectionEquality().equals(other.response, response) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      media,
      status,
      isFromAutoBackup,
      const DeepCollectionEquality().hash(response),
      progress);

  /// Create a copy of AppProcess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppProcessImplCopyWith<_$AppProcessImpl> get copyWith =>
      __$$AppProcessImplCopyWithImpl<_$AppProcessImpl>(this, _$identity);
}

abstract class _AppProcess implements AppProcess {
  const factory _AppProcess(
      {required final String id,
      required final AppMedia media,
      required final AppProcessStatus status,
      final bool isFromAutoBackup,
      final Object? response,
      final AppProcessProgress? progress}) = _$AppProcessImpl;

  @override
  String get id;
  @override
  AppMedia get media;
  @override
  AppProcessStatus get status;
  @override
  bool get isFromAutoBackup;
  @override
  Object? get response;
  @override
  AppProcessProgress? get progress;

  /// Create a copy of AppProcess
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppProcessImplCopyWith<_$AppProcessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AppProcessProgress {
  int get total => throw _privateConstructorUsedError;
  int get chunk => throw _privateConstructorUsedError;

  /// Create a copy of AppProcessProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppProcessProgressCopyWith<AppProcessProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppProcessProgressCopyWith<$Res> {
  factory $AppProcessProgressCopyWith(
          AppProcessProgress value, $Res Function(AppProcessProgress) then) =
      _$AppProcessProgressCopyWithImpl<$Res, AppProcessProgress>;
  @useResult
  $Res call({int total, int chunk});
}

/// @nodoc
class _$AppProcessProgressCopyWithImpl<$Res, $Val extends AppProcessProgress>
    implements $AppProcessProgressCopyWith<$Res> {
  _$AppProcessProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppProcessProgress
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
abstract class _$$AppProcessProgressImplCopyWith<$Res>
    implements $AppProcessProgressCopyWith<$Res> {
  factory _$$AppProcessProgressImplCopyWith(_$AppProcessProgressImpl value,
          $Res Function(_$AppProcessProgressImpl) then) =
      __$$AppProcessProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, int chunk});
}

/// @nodoc
class __$$AppProcessProgressImplCopyWithImpl<$Res>
    extends _$AppProcessProgressCopyWithImpl<$Res, _$AppProcessProgressImpl>
    implements _$$AppProcessProgressImplCopyWith<$Res> {
  __$$AppProcessProgressImplCopyWithImpl(_$AppProcessProgressImpl _value,
      $Res Function(_$AppProcessProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppProcessProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? chunk = null,
  }) {
    return _then(_$AppProcessProgressImpl(
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

class _$AppProcessProgressImpl implements _AppProcessProgress {
  const _$AppProcessProgressImpl({required this.total, required this.chunk});

  @override
  final int total;
  @override
  final int chunk;

  @override
  String toString() {
    return 'AppProcessProgress(total: $total, chunk: $chunk)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppProcessProgressImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.chunk, chunk) || other.chunk == chunk));
  }

  @override
  int get hashCode => Object.hash(runtimeType, total, chunk);

  /// Create a copy of AppProcessProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppProcessProgressImplCopyWith<_$AppProcessProgressImpl> get copyWith =>
      __$$AppProcessProgressImplCopyWithImpl<_$AppProcessProgressImpl>(
          this, _$identity);
}

abstract class _AppProcessProgress implements AppProcessProgress {
  const factory _AppProcessProgress(
      {required final int total,
      required final int chunk}) = _$AppProcessProgressImpl;

  @override
  int get total;
  @override
  int get chunk;

  /// Create a copy of AppProcessProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppProcessProgressImplCopyWith<_$AppProcessProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
