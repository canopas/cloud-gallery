// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dropbox_token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DropboxToken _$DropboxTokenFromJson(Map<String, dynamic> json) {
  return _DropboxToken.fromJson(json);
}

/// @nodoc
mixin _$DropboxToken {
  String get access_token => throw _privateConstructorUsedError;
  String get token_type => throw _privateConstructorUsedError;
  DateTime get expires_in => throw _privateConstructorUsedError;
  String get refresh_token => throw _privateConstructorUsedError;
  String get account_id => throw _privateConstructorUsedError;
  String get scope => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;

  /// Serializes this DropboxToken to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DropboxToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DropboxTokenCopyWith<DropboxToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DropboxTokenCopyWith<$Res> {
  factory $DropboxTokenCopyWith(
          DropboxToken value, $Res Function(DropboxToken) then) =
      _$DropboxTokenCopyWithImpl<$Res, DropboxToken>;
  @useResult
  $Res call(
      {String access_token,
      String token_type,
      DateTime expires_in,
      String refresh_token,
      String account_id,
      String scope,
      String uid});
}

/// @nodoc
class _$DropboxTokenCopyWithImpl<$Res, $Val extends DropboxToken>
    implements $DropboxTokenCopyWith<$Res> {
  _$DropboxTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DropboxToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? access_token = null,
    Object? token_type = null,
    Object? expires_in = null,
    Object? refresh_token = null,
    Object? account_id = null,
    Object? scope = null,
    Object? uid = null,
  }) {
    return _then(_value.copyWith(
      access_token: null == access_token
          ? _value.access_token
          : access_token // ignore: cast_nullable_to_non_nullable
              as String,
      token_type: null == token_type
          ? _value.token_type
          : token_type // ignore: cast_nullable_to_non_nullable
              as String,
      expires_in: null == expires_in
          ? _value.expires_in
          : expires_in // ignore: cast_nullable_to_non_nullable
              as DateTime,
      refresh_token: null == refresh_token
          ? _value.refresh_token
          : refresh_token // ignore: cast_nullable_to_non_nullable
              as String,
      account_id: null == account_id
          ? _value.account_id
          : account_id // ignore: cast_nullable_to_non_nullable
              as String,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DropboxTokenImplCopyWith<$Res>
    implements $DropboxTokenCopyWith<$Res> {
  factory _$$DropboxTokenImplCopyWith(
          _$DropboxTokenImpl value, $Res Function(_$DropboxTokenImpl) then) =
      __$$DropboxTokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String access_token,
      String token_type,
      DateTime expires_in,
      String refresh_token,
      String account_id,
      String scope,
      String uid});
}

/// @nodoc
class __$$DropboxTokenImplCopyWithImpl<$Res>
    extends _$DropboxTokenCopyWithImpl<$Res, _$DropboxTokenImpl>
    implements _$$DropboxTokenImplCopyWith<$Res> {
  __$$DropboxTokenImplCopyWithImpl(
      _$DropboxTokenImpl _value, $Res Function(_$DropboxTokenImpl) _then)
      : super(_value, _then);

  /// Create a copy of DropboxToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? access_token = null,
    Object? token_type = null,
    Object? expires_in = null,
    Object? refresh_token = null,
    Object? account_id = null,
    Object? scope = null,
    Object? uid = null,
  }) {
    return _then(_$DropboxTokenImpl(
      access_token: null == access_token
          ? _value.access_token
          : access_token // ignore: cast_nullable_to_non_nullable
              as String,
      token_type: null == token_type
          ? _value.token_type
          : token_type // ignore: cast_nullable_to_non_nullable
              as String,
      expires_in: null == expires_in
          ? _value.expires_in
          : expires_in // ignore: cast_nullable_to_non_nullable
              as DateTime,
      refresh_token: null == refresh_token
          ? _value.refresh_token
          : refresh_token // ignore: cast_nullable_to_non_nullable
              as String,
      account_id: null == account_id
          ? _value.account_id
          : account_id // ignore: cast_nullable_to_non_nullable
              as String,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DropboxTokenImpl implements _DropboxToken {
  const _$DropboxTokenImpl(
      {required this.access_token,
      required this.token_type,
      required this.expires_in,
      required this.refresh_token,
      required this.account_id,
      required this.scope,
      required this.uid});

  factory _$DropboxTokenImpl.fromJson(Map<String, dynamic> json) =>
      _$$DropboxTokenImplFromJson(json);

  @override
  final String access_token;
  @override
  final String token_type;
  @override
  final DateTime expires_in;
  @override
  final String refresh_token;
  @override
  final String account_id;
  @override
  final String scope;
  @override
  final String uid;

  @override
  String toString() {
    return 'DropboxToken(access_token: $access_token, token_type: $token_type, expires_in: $expires_in, refresh_token: $refresh_token, account_id: $account_id, scope: $scope, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DropboxTokenImpl &&
            (identical(other.access_token, access_token) ||
                other.access_token == access_token) &&
            (identical(other.token_type, token_type) ||
                other.token_type == token_type) &&
            (identical(other.expires_in, expires_in) ||
                other.expires_in == expires_in) &&
            (identical(other.refresh_token, refresh_token) ||
                other.refresh_token == refresh_token) &&
            (identical(other.account_id, account_id) ||
                other.account_id == account_id) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            (identical(other.uid, uid) || other.uid == uid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, access_token, token_type,
      expires_in, refresh_token, account_id, scope, uid);

  /// Create a copy of DropboxToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DropboxTokenImplCopyWith<_$DropboxTokenImpl> get copyWith =>
      __$$DropboxTokenImplCopyWithImpl<_$DropboxTokenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DropboxTokenImplToJson(
      this,
    );
  }
}

abstract class _DropboxToken implements DropboxToken {
  const factory _DropboxToken(
      {required final String access_token,
      required final String token_type,
      required final DateTime expires_in,
      required final String refresh_token,
      required final String account_id,
      required final String scope,
      required final String uid}) = _$DropboxTokenImpl;

  factory _DropboxToken.fromJson(Map<String, dynamic> json) =
      _$DropboxTokenImpl.fromJson;

  @override
  String get access_token;
  @override
  String get token_type;
  @override
  DateTime get expires_in;
  @override
  String get refresh_token;
  @override
  String get account_id;
  @override
  String get scope;
  @override
  String get uid;

  /// Create a copy of DropboxToken
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DropboxTokenImplCopyWith<_$DropboxTokenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
