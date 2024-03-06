// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounts_screen_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AccountsState {
  String? get version => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;
  GoogleSignInAccount? get googleAccount => throw _privateConstructorUsedError;
  bool get autoBackUp => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountsStateCopyWith<AccountsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountsStateCopyWith<$Res> {
  factory $AccountsStateCopyWith(
          AccountsState value, $Res Function(AccountsState) then) =
      _$AccountsStateCopyWithImpl<$Res, AccountsState>;
  @useResult
  $Res call(
      {String? version,
      Object? error,
      GoogleSignInAccount? googleAccount,
      bool autoBackUp});
}

/// @nodoc
class _$AccountsStateCopyWithImpl<$Res, $Val extends AccountsState>
    implements $AccountsStateCopyWith<$Res> {
  _$AccountsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = freezed,
    Object? error = freezed,
    Object? googleAccount = freezed,
    Object? autoBackUp = null,
  }) {
    return _then(_value.copyWith(
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error ? _value.error : error,
      googleAccount: freezed == googleAccount
          ? _value.googleAccount
          : googleAccount // ignore: cast_nullable_to_non_nullable
              as GoogleSignInAccount?,
      autoBackUp: null == autoBackUp
          ? _value.autoBackUp
          : autoBackUp // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountsStateImplCopyWith<$Res>
    implements $AccountsStateCopyWith<$Res> {
  factory _$$AccountsStateImplCopyWith(
          _$AccountsStateImpl value, $Res Function(_$AccountsStateImpl) then) =
      __$$AccountsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? version,
      Object? error,
      GoogleSignInAccount? googleAccount,
      bool autoBackUp});
}

/// @nodoc
class __$$AccountsStateImplCopyWithImpl<$Res>
    extends _$AccountsStateCopyWithImpl<$Res, _$AccountsStateImpl>
    implements _$$AccountsStateImplCopyWith<$Res> {
  __$$AccountsStateImplCopyWithImpl(
      _$AccountsStateImpl _value, $Res Function(_$AccountsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = freezed,
    Object? error = freezed,
    Object? googleAccount = freezed,
    Object? autoBackUp = null,
  }) {
    return _then(_$AccountsStateImpl(
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error ? _value.error : error,
      googleAccount: freezed == googleAccount
          ? _value.googleAccount
          : googleAccount // ignore: cast_nullable_to_non_nullable
              as GoogleSignInAccount?,
      autoBackUp: null == autoBackUp
          ? _value.autoBackUp
          : autoBackUp // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AccountsStateImpl implements _AccountsState {
  const _$AccountsStateImpl(
      {this.version, this.error, this.googleAccount, this.autoBackUp = false});

  @override
  final String? version;
  @override
  final Object? error;
  @override
  final GoogleSignInAccount? googleAccount;
  @override
  @JsonKey()
  final bool autoBackUp;

  @override
  String toString() {
    return 'AccountsState(version: $version, error: $error, googleAccount: $googleAccount, autoBackUp: $autoBackUp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountsStateImpl &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.googleAccount, googleAccount) ||
                other.googleAccount == googleAccount) &&
            (identical(other.autoBackUp, autoBackUp) ||
                other.autoBackUp == autoBackUp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, version,
      const DeepCollectionEquality().hash(error), googleAccount, autoBackUp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountsStateImplCopyWith<_$AccountsStateImpl> get copyWith =>
      __$$AccountsStateImplCopyWithImpl<_$AccountsStateImpl>(this, _$identity);
}

abstract class _AccountsState implements AccountsState {
  const factory _AccountsState(
      {final String? version,
      final Object? error,
      final GoogleSignInAccount? googleAccount,
      final bool autoBackUp}) = _$AccountsStateImpl;

  @override
  String? get version;
  @override
  Object? get error;
  @override
  GoogleSignInAccount? get googleAccount;
  @override
  bool get autoBackUp;
  @override
  @JsonKey(ignore: true)
  _$$AccountsStateImplCopyWith<_$AccountsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
