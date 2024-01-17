// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_screen_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MainScreenViewState {
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MainScreenViewStateCopyWith<MainScreenViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainScreenViewStateCopyWith<$Res> {
  factory $MainScreenViewStateCopyWith(
          MainScreenViewState value, $Res Function(MainScreenViewState) then) =
      _$MainScreenViewStateCopyWithImpl<$Res, MainScreenViewState>;
  @useResult
  $Res call({Object? error});
}

/// @nodoc
class _$MainScreenViewStateCopyWithImpl<$Res, $Val extends MainScreenViewState>
    implements $MainScreenViewStateCopyWith<$Res> {
  _$MainScreenViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MainScreenViewStateImplCopyWith<$Res>
    implements $MainScreenViewStateCopyWith<$Res> {
  factory _$$MainScreenViewStateImplCopyWith(_$MainScreenViewStateImpl value,
          $Res Function(_$MainScreenViewStateImpl) then) =
      __$$MainScreenViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Object? error});
}

/// @nodoc
class __$$MainScreenViewStateImplCopyWithImpl<$Res>
    extends _$MainScreenViewStateCopyWithImpl<$Res, _$MainScreenViewStateImpl>
    implements _$$MainScreenViewStateImplCopyWith<$Res> {
  __$$MainScreenViewStateImplCopyWithImpl(_$MainScreenViewStateImpl _value,
      $Res Function(_$MainScreenViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(_$MainScreenViewStateImpl(
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$MainScreenViewStateImpl implements _MainScreenViewState {
  const _$MainScreenViewStateImpl({this.error});

  @override
  final Object? error;

  @override
  String toString() {
    return 'MainScreenViewState(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MainScreenViewStateImpl &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MainScreenViewStateImplCopyWith<_$MainScreenViewStateImpl> get copyWith =>
      __$$MainScreenViewStateImplCopyWithImpl<_$MainScreenViewStateImpl>(
          this, _$identity);
}

abstract class _MainScreenViewState implements MainScreenViewState {
  const factory _MainScreenViewState({final Object? error}) =
      _$MainScreenViewStateImpl;

  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$MainScreenViewStateImplCopyWith<_$MainScreenViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
