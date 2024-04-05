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
  Object? get response => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
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
      Object? response,
      double progress});

  $AppMediaCopyWith<$Res> get media;
}

/// @nodoc
class _$AppProcessCopyWithImpl<$Res, $Val extends AppProcess>
    implements $AppProcessCopyWith<$Res> {
  _$AppProcessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? media = null,
    Object? status = null,
    Object? response = freezed,
    Object? progress = null,
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
      response: freezed == response ? _value.response : response,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AppMediaCopyWith<$Res> get media {
    return $AppMediaCopyWith<$Res>(_value.media, (value) {
      return _then(_value.copyWith(media: value) as $Val);
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
      Object? response,
      double progress});

  @override
  $AppMediaCopyWith<$Res> get media;
}

/// @nodoc
class __$$AppProcessImplCopyWithImpl<$Res>
    extends _$AppProcessCopyWithImpl<$Res, _$AppProcessImpl>
    implements _$$AppProcessImplCopyWith<$Res> {
  __$$AppProcessImplCopyWithImpl(
      _$AppProcessImpl _value, $Res Function(_$AppProcessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? media = null,
    Object? status = null,
    Object? response = freezed,
    Object? progress = null,
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
      response: freezed == response ? _value.response : response,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$AppProcessImpl implements _AppProcess {
  const _$AppProcessImpl(
      {required this.id,
      required this.media,
      required this.status,
      this.response,
      this.progress = 0});

  @override
  final String id;
  @override
  final AppMedia media;
  @override
  final AppProcessStatus status;
  @override
  final Object? response;
  @override
  @JsonKey()
  final double progress;

  @override
  String toString() {
    return 'AppProcess(id: $id, media: $media, status: $status, response: $response, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppProcessImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.media, media) || other.media == media) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.response, response) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, media, status,
      const DeepCollectionEquality().hash(response), progress);

  @JsonKey(ignore: true)
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
      final Object? response,
      final double progress}) = _$AppProcessImpl;

  @override
  String get id;
  @override
  AppMedia get media;
  @override
  AppProcessStatus get status;
  @override
  Object? get response;
  @override
  double get progress;
  @override
  @JsonKey(ignore: true)
  _$$AppProcessImplCopyWith<_$AppProcessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
