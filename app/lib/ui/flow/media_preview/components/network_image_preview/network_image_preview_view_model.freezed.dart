// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_image_preview_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NetworkImagePreviewState {
  AppMedia get media => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  double? get progress => throw _privateConstructorUsedError;
  String? get filePath => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  /// Create a copy of NetworkImagePreviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetworkImagePreviewStateCopyWith<NetworkImagePreviewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkImagePreviewStateCopyWith<$Res> {
  factory $NetworkImagePreviewStateCopyWith(NetworkImagePreviewState value,
          $Res Function(NetworkImagePreviewState) then) =
      _$NetworkImagePreviewStateCopyWithImpl<$Res, NetworkImagePreviewState>;
  @useResult
  $Res call(
      {AppMedia media,
      bool loading,
      double? progress,
      String? filePath,
      Object? error});

  $AppMediaCopyWith<$Res> get media;
}

/// @nodoc
class _$NetworkImagePreviewStateCopyWithImpl<$Res,
        $Val extends NetworkImagePreviewState>
    implements $NetworkImagePreviewStateCopyWith<$Res> {
  _$NetworkImagePreviewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NetworkImagePreviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? media = null,
    Object? loading = null,
    Object? progress = freezed,
    Object? filePath = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as AppMedia,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double?,
      filePath: freezed == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }

  /// Create a copy of NetworkImagePreviewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppMediaCopyWith<$Res> get media {
    return $AppMediaCopyWith<$Res>(_value.media, (value) {
      return _then(_value.copyWith(media: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NetworkImagePreviewStateImplCopyWith<$Res>
    implements $NetworkImagePreviewStateCopyWith<$Res> {
  factory _$$NetworkImagePreviewStateImplCopyWith(
          _$NetworkImagePreviewStateImpl value,
          $Res Function(_$NetworkImagePreviewStateImpl) then) =
      __$$NetworkImagePreviewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AppMedia media,
      bool loading,
      double? progress,
      String? filePath,
      Object? error});

  @override
  $AppMediaCopyWith<$Res> get media;
}

/// @nodoc
class __$$NetworkImagePreviewStateImplCopyWithImpl<$Res>
    extends _$NetworkImagePreviewStateCopyWithImpl<$Res,
        _$NetworkImagePreviewStateImpl>
    implements _$$NetworkImagePreviewStateImplCopyWith<$Res> {
  __$$NetworkImagePreviewStateImplCopyWithImpl(
      _$NetworkImagePreviewStateImpl _value,
      $Res Function(_$NetworkImagePreviewStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NetworkImagePreviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? media = null,
    Object? loading = null,
    Object? progress = freezed,
    Object? filePath = freezed,
    Object? error = freezed,
  }) {
    return _then(_$NetworkImagePreviewStateImpl(
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as AppMedia,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double?,
      filePath: freezed == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$NetworkImagePreviewStateImpl implements _NetworkImagePreviewState {
  const _$NetworkImagePreviewStateImpl(
      {required this.media,
      this.loading = false,
      this.progress,
      this.filePath,
      this.error});

  @override
  final AppMedia media;
  @override
  @JsonKey()
  final bool loading;
  @override
  final double? progress;
  @override
  final String? filePath;
  @override
  final Object? error;

  @override
  String toString() {
    return 'NetworkImagePreviewState(media: $media, loading: $loading, progress: $progress, filePath: $filePath, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkImagePreviewStateImpl &&
            (identical(other.media, media) || other.media == media) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, media, loading, progress,
      filePath, const DeepCollectionEquality().hash(error));

  /// Create a copy of NetworkImagePreviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkImagePreviewStateImplCopyWith<_$NetworkImagePreviewStateImpl>
      get copyWith => __$$NetworkImagePreviewStateImplCopyWithImpl<
          _$NetworkImagePreviewStateImpl>(this, _$identity);
}

abstract class _NetworkImagePreviewState implements NetworkImagePreviewState {
  const factory _NetworkImagePreviewState(
      {required final AppMedia media,
      final bool loading,
      final double? progress,
      final String? filePath,
      final Object? error}) = _$NetworkImagePreviewStateImpl;

  @override
  AppMedia get media;
  @override
  bool get loading;
  @override
  double? get progress;
  @override
  String? get filePath;
  @override
  Object? get error;

  /// Create a copy of NetworkImagePreviewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkImagePreviewStateImplCopyWith<_$NetworkImagePreviewStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
