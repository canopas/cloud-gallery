// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'albums_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AlbumsState {
  bool get loading => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  /// Create a copy of AlbumsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlbumsStateCopyWith<AlbumsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlbumsStateCopyWith<$Res> {
  factory $AlbumsStateCopyWith(
          AlbumsState value, $Res Function(AlbumsState) then) =
      _$AlbumsStateCopyWithImpl<$Res, AlbumsState>;
  @useResult
  $Res call({bool loading, Object? error});
}

/// @nodoc
class _$AlbumsStateCopyWithImpl<$Res, $Val extends AlbumsState>
    implements $AlbumsStateCopyWith<$Res> {
  _$AlbumsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlbumsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlbumsStateImplCopyWith<$Res>
    implements $AlbumsStateCopyWith<$Res> {
  factory _$$AlbumsStateImplCopyWith(
          _$AlbumsStateImpl value, $Res Function(_$AlbumsStateImpl) then) =
      __$$AlbumsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool loading, Object? error});
}

/// @nodoc
class __$$AlbumsStateImplCopyWithImpl<$Res>
    extends _$AlbumsStateCopyWithImpl<$Res, _$AlbumsStateImpl>
    implements _$$AlbumsStateImplCopyWith<$Res> {
  __$$AlbumsStateImplCopyWithImpl(
      _$AlbumsStateImpl _value, $Res Function(_$AlbumsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlbumsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? error = freezed,
  }) {
    return _then(_$AlbumsStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$AlbumsStateImpl implements _AlbumsState {
  const _$AlbumsStateImpl({this.loading = false, this.error});

  @override
  @JsonKey()
  final bool loading;
  @override
  final Object? error;

  @override
  String toString() {
    return 'AlbumsState(loading: $loading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlbumsStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, loading, const DeepCollectionEquality().hash(error));

  /// Create a copy of AlbumsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlbumsStateImplCopyWith<_$AlbumsStateImpl> get copyWith =>
      __$$AlbumsStateImplCopyWithImpl<_$AlbumsStateImpl>(this, _$identity);
}

abstract class _AlbumsState implements AlbumsState {
  const factory _AlbumsState({final bool loading, final Object? error}) =
      _$AlbumsStateImpl;

  @override
  bool get loading;
  @override
  Object? get error;

  /// Create a copy of AlbumsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlbumsStateImplCopyWith<_$AlbumsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
