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
  bool get loading => throw _privateConstructorUsedError;
  AppMediaContent? get mediaContent => throw _privateConstructorUsedError;
  List<int>? get mediaBytes => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
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
      {bool loading,
      AppMediaContent? mediaContent,
      List<int>? mediaBytes,
      double progress,
      Object? error});

  $AppMediaContentCopyWith<$Res>? get mediaContent;
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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? mediaContent = freezed,
    Object? mediaBytes = freezed,
    Object? progress = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      mediaContent: freezed == mediaContent
          ? _value.mediaContent
          : mediaContent // ignore: cast_nullable_to_non_nullable
              as AppMediaContent?,
      mediaBytes: freezed == mediaBytes
          ? _value.mediaBytes
          : mediaBytes // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AppMediaContentCopyWith<$Res>? get mediaContent {
    if (_value.mediaContent == null) {
      return null;
    }

    return $AppMediaContentCopyWith<$Res>(_value.mediaContent!, (value) {
      return _then(_value.copyWith(mediaContent: value) as $Val);
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
      {bool loading,
      AppMediaContent? mediaContent,
      List<int>? mediaBytes,
      double progress,
      Object? error});

  @override
  $AppMediaContentCopyWith<$Res>? get mediaContent;
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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? mediaContent = freezed,
    Object? mediaBytes = freezed,
    Object? progress = null,
    Object? error = freezed,
  }) {
    return _then(_$NetworkImagePreviewStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      mediaContent: freezed == mediaContent
          ? _value.mediaContent
          : mediaContent // ignore: cast_nullable_to_non_nullable
              as AppMediaContent?,
      mediaBytes: freezed == mediaBytes
          ? _value._mediaBytes
          : mediaBytes // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$NetworkImagePreviewStateImpl implements _NetworkImagePreviewState {
  const _$NetworkImagePreviewStateImpl(
      {this.loading = false,
      this.mediaContent,
      final List<int>? mediaBytes,
      this.progress = 0.0,
      this.error})
      : _mediaBytes = mediaBytes;

  @override
  @JsonKey()
  final bool loading;
  @override
  final AppMediaContent? mediaContent;
  final List<int>? _mediaBytes;
  @override
  List<int>? get mediaBytes {
    final value = _mediaBytes;
    if (value == null) return null;
    if (_mediaBytes is EqualUnmodifiableListView) return _mediaBytes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final double progress;
  @override
  final Object? error;

  @override
  String toString() {
    return 'NetworkImagePreviewState(loading: $loading, mediaContent: $mediaContent, mediaBytes: $mediaBytes, progress: $progress, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkImagePreviewStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.mediaContent, mediaContent) ||
                other.mediaContent == mediaContent) &&
            const DeepCollectionEquality()
                .equals(other._mediaBytes, _mediaBytes) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      mediaContent,
      const DeepCollectionEquality().hash(_mediaBytes),
      progress,
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkImagePreviewStateImplCopyWith<_$NetworkImagePreviewStateImpl>
      get copyWith => __$$NetworkImagePreviewStateImplCopyWithImpl<
          _$NetworkImagePreviewStateImpl>(this, _$identity);
}

abstract class _NetworkImagePreviewState implements NetworkImagePreviewState {
  const factory _NetworkImagePreviewState(
      {final bool loading,
      final AppMediaContent? mediaContent,
      final List<int>? mediaBytes,
      final double progress,
      final Object? error}) = _$NetworkImagePreviewStateImpl;

  @override
  bool get loading;
  @override
  AppMediaContent? get mediaContent;
  @override
  List<int>? get mediaBytes;
  @override
  double get progress;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$NetworkImagePreviewStateImplCopyWith<_$NetworkImagePreviewStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
