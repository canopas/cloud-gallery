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
  bool get notificationsPermissionStatus => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;
  GoogleSignInAccount? get googleAccount => throw _privateConstructorUsedError;

  /// Create a copy of AccountsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {bool notificationsPermissionStatus,
      String? version,
      Object? error,
      GoogleSignInAccount? googleAccount});
}

/// @nodoc
class _$AccountsStateCopyWithImpl<$Res, $Val extends AccountsState>
    implements $AccountsStateCopyWith<$Res> {
  _$AccountsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationsPermissionStatus = null,
    Object? version = freezed,
    Object? error = freezed,
    Object? googleAccount = freezed,
  }) {
    return _then(_value.copyWith(
      notificationsPermissionStatus: null == notificationsPermissionStatus
          ? _value.notificationsPermissionStatus
          : notificationsPermissionStatus // ignore: cast_nullable_to_non_nullable
              as bool,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error ? _value.error : error,
      googleAccount: freezed == googleAccount
          ? _value.googleAccount
          : googleAccount // ignore: cast_nullable_to_non_nullable
              as GoogleSignInAccount?,
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
      {bool notificationsPermissionStatus,
      String? version,
      Object? error,
      GoogleSignInAccount? googleAccount});
}

/// @nodoc
class __$$AccountsStateImplCopyWithImpl<$Res>
    extends _$AccountsStateCopyWithImpl<$Res, _$AccountsStateImpl>
    implements _$$AccountsStateImplCopyWith<$Res> {
  __$$AccountsStateImplCopyWithImpl(
      _$AccountsStateImpl _value, $Res Function(_$AccountsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationsPermissionStatus = null,
    Object? version = freezed,
    Object? error = freezed,
    Object? googleAccount = freezed,
  }) {
    return _then(_$AccountsStateImpl(
      notificationsPermissionStatus: null == notificationsPermissionStatus
          ? _value.notificationsPermissionStatus
          : notificationsPermissionStatus // ignore: cast_nullable_to_non_nullable
              as bool,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error ? _value.error : error,
      googleAccount: freezed == googleAccount
          ? _value.googleAccount
          : googleAccount // ignore: cast_nullable_to_non_nullable
              as GoogleSignInAccount?,
    ));
  }
}

/// @nodoc

class _$AccountsStateImpl implements _AccountsState {
  const _$AccountsStateImpl(
      {this.notificationsPermissionStatus = true,
      this.version,
      this.error,
      this.googleAccount});

  @override
  @JsonKey()
  final bool notificationsPermissionStatus;
  @override
  final String? version;
  @override
  final Object? error;
  @override
  final GoogleSignInAccount? googleAccount;

  @override
  String toString() {
    return 'AccountsState(notificationsPermissionStatus: $notificationsPermissionStatus, version: $version, error: $error, googleAccount: $googleAccount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountsStateImpl &&
            (identical(other.notificationsPermissionStatus,
                    notificationsPermissionStatus) ||
                other.notificationsPermissionStatus ==
                    notificationsPermissionStatus) &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.googleAccount, googleAccount) ||
                other.googleAccount == googleAccount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, notificationsPermissionStatus,
      version, const DeepCollectionEquality().hash(error), googleAccount);

  /// Create a copy of AccountsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountsStateImplCopyWith<_$AccountsStateImpl> get copyWith =>
      __$$AccountsStateImplCopyWithImpl<_$AccountsStateImpl>(this, _$identity);
}

abstract class _AccountsState implements AccountsState {
  const factory _AccountsState(
      {final bool notificationsPermissionStatus,
      final String? version,
      final Object? error,
      final GoogleSignInAccount? googleAccount}) = _$AccountsStateImpl;

  @override
  bool get notificationsPermissionStatus;
  @override
  String? get version;
  @override
  Object? get error;
  @override
  GoogleSignInAccount? get googleAccount;

  /// Create a copy of AccountsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountsStateImplCopyWith<_$AccountsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
