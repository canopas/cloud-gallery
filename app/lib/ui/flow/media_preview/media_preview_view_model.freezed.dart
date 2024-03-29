// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_preview_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MediaPreviewState {
  Object? get error => throw _privateConstructorUsedError;
  int get currentIndex => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MediaPreviewStateCopyWith<MediaPreviewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaPreviewStateCopyWith<$Res> {
  factory $MediaPreviewStateCopyWith(
          MediaPreviewState value, $Res Function(MediaPreviewState) then) =
      _$MediaPreviewStateCopyWithImpl<$Res, MediaPreviewState>;
  @useResult
  $Res call({Object? error, int currentIndex});
}

/// @nodoc
class _$MediaPreviewStateCopyWithImpl<$Res, $Val extends MediaPreviewState>
    implements $MediaPreviewStateCopyWith<$Res> {
  _$MediaPreviewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? currentIndex = null,
  }) {
    return _then(_value.copyWith(
      error: freezed == error ? _value.error : error,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MediaPreviewStateImplCopyWith<$Res>
    implements $MediaPreviewStateCopyWith<$Res> {
  factory _$$MediaPreviewStateImplCopyWith(_$MediaPreviewStateImpl value,
          $Res Function(_$MediaPreviewStateImpl) then) =
      __$$MediaPreviewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Object? error, int currentIndex});
}

/// @nodoc
class __$$MediaPreviewStateImplCopyWithImpl<$Res>
    extends _$MediaPreviewStateCopyWithImpl<$Res, _$MediaPreviewStateImpl>
    implements _$$MediaPreviewStateImplCopyWith<$Res> {
  __$$MediaPreviewStateImplCopyWithImpl(_$MediaPreviewStateImpl _value,
      $Res Function(_$MediaPreviewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? currentIndex = null,
  }) {
    return _then(_$MediaPreviewStateImpl(
      error: freezed == error ? _value.error : error,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$MediaPreviewStateImpl implements _MediaPreviewState {
  const _$MediaPreviewStateImpl({this.error, this.currentIndex = 0});

  @override
  final Object? error;
  @override
  @JsonKey()
  final int currentIndex;

  @override
  String toString() {
    return 'MediaPreviewState(error: $error, currentIndex: $currentIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaPreviewStateImpl &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(error), currentIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaPreviewStateImplCopyWith<_$MediaPreviewStateImpl> get copyWith =>
      __$$MediaPreviewStateImplCopyWithImpl<_$MediaPreviewStateImpl>(
          this, _$identity);
}

abstract class _MediaPreviewState implements MediaPreviewState {
  const factory _MediaPreviewState(
      {final Object? error, final int currentIndex}) = _$MediaPreviewStateImpl;

  @override
  Object? get error;
  @override
  int get currentIndex;
  @override
  @JsonKey(ignore: true)
  _$$MediaPreviewStateImplCopyWith<_$MediaPreviewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
