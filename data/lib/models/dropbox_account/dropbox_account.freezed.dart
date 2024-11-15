// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dropbox_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DropboxAccount _$DropboxAccountFromJson(Map<String, dynamic> json) {
  return _DropboxAccount.fromJson(json);
}

/// @nodoc
mixin _$DropboxAccount {
  String get account_id => throw _privateConstructorUsedError;
  DropboxAccountName get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  bool get email_verified => throw _privateConstructorUsedError;
  bool get disabled => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError;
  String get referral_link => throw _privateConstructorUsedError;
  bool get is_paired => throw _privateConstructorUsedError;
  String? get profile_photo_url => throw _privateConstructorUsedError;
  String? get team_member_id => throw _privateConstructorUsedError;

  /// Serializes this DropboxAccount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DropboxAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DropboxAccountCopyWith<DropboxAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DropboxAccountCopyWith<$Res> {
  factory $DropboxAccountCopyWith(
          DropboxAccount value, $Res Function(DropboxAccount) then) =
      _$DropboxAccountCopyWithImpl<$Res, DropboxAccount>;
  @useResult
  $Res call(
      {String account_id,
      DropboxAccountName name,
      String email,
      bool email_verified,
      bool disabled,
      String country,
      String locale,
      String referral_link,
      bool is_paired,
      String? profile_photo_url,
      String? team_member_id});

  $DropboxAccountNameCopyWith<$Res> get name;
}

/// @nodoc
class _$DropboxAccountCopyWithImpl<$Res, $Val extends DropboxAccount>
    implements $DropboxAccountCopyWith<$Res> {
  _$DropboxAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DropboxAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account_id = null,
    Object? name = null,
    Object? email = null,
    Object? email_verified = null,
    Object? disabled = null,
    Object? country = null,
    Object? locale = null,
    Object? referral_link = null,
    Object? is_paired = null,
    Object? profile_photo_url = freezed,
    Object? team_member_id = freezed,
  }) {
    return _then(_value.copyWith(
      account_id: null == account_id
          ? _value.account_id
          : account_id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as DropboxAccountName,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      email_verified: null == email_verified
          ? _value.email_verified
          : email_verified // ignore: cast_nullable_to_non_nullable
              as bool,
      disabled: null == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      referral_link: null == referral_link
          ? _value.referral_link
          : referral_link // ignore: cast_nullable_to_non_nullable
              as String,
      is_paired: null == is_paired
          ? _value.is_paired
          : is_paired // ignore: cast_nullable_to_non_nullable
              as bool,
      profile_photo_url: freezed == profile_photo_url
          ? _value.profile_photo_url
          : profile_photo_url // ignore: cast_nullable_to_non_nullable
              as String?,
      team_member_id: freezed == team_member_id
          ? _value.team_member_id
          : team_member_id // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of DropboxAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DropboxAccountNameCopyWith<$Res> get name {
    return $DropboxAccountNameCopyWith<$Res>(_value.name, (value) {
      return _then(_value.copyWith(name: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DropboxAccountImplCopyWith<$Res>
    implements $DropboxAccountCopyWith<$Res> {
  factory _$$DropboxAccountImplCopyWith(_$DropboxAccountImpl value,
          $Res Function(_$DropboxAccountImpl) then) =
      __$$DropboxAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String account_id,
      DropboxAccountName name,
      String email,
      bool email_verified,
      bool disabled,
      String country,
      String locale,
      String referral_link,
      bool is_paired,
      String? profile_photo_url,
      String? team_member_id});

  @override
  $DropboxAccountNameCopyWith<$Res> get name;
}

/// @nodoc
class __$$DropboxAccountImplCopyWithImpl<$Res>
    extends _$DropboxAccountCopyWithImpl<$Res, _$DropboxAccountImpl>
    implements _$$DropboxAccountImplCopyWith<$Res> {
  __$$DropboxAccountImplCopyWithImpl(
      _$DropboxAccountImpl _value, $Res Function(_$DropboxAccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of DropboxAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account_id = null,
    Object? name = null,
    Object? email = null,
    Object? email_verified = null,
    Object? disabled = null,
    Object? country = null,
    Object? locale = null,
    Object? referral_link = null,
    Object? is_paired = null,
    Object? profile_photo_url = freezed,
    Object? team_member_id = freezed,
  }) {
    return _then(_$DropboxAccountImpl(
      account_id: null == account_id
          ? _value.account_id
          : account_id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as DropboxAccountName,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      email_verified: null == email_verified
          ? _value.email_verified
          : email_verified // ignore: cast_nullable_to_non_nullable
              as bool,
      disabled: null == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      referral_link: null == referral_link
          ? _value.referral_link
          : referral_link // ignore: cast_nullable_to_non_nullable
              as String,
      is_paired: null == is_paired
          ? _value.is_paired
          : is_paired // ignore: cast_nullable_to_non_nullable
              as bool,
      profile_photo_url: freezed == profile_photo_url
          ? _value.profile_photo_url
          : profile_photo_url // ignore: cast_nullable_to_non_nullable
              as String?,
      team_member_id: freezed == team_member_id
          ? _value.team_member_id
          : team_member_id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DropboxAccountImpl implements _DropboxAccount {
  const _$DropboxAccountImpl(
      {required this.account_id,
      required this.name,
      required this.email,
      required this.email_verified,
      required this.disabled,
      required this.country,
      required this.locale,
      required this.referral_link,
      required this.is_paired,
      this.profile_photo_url,
      this.team_member_id});

  factory _$DropboxAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$DropboxAccountImplFromJson(json);

  @override
  final String account_id;
  @override
  final DropboxAccountName name;
  @override
  final String email;
  @override
  final bool email_verified;
  @override
  final bool disabled;
  @override
  final String country;
  @override
  final String locale;
  @override
  final String referral_link;
  @override
  final bool is_paired;
  @override
  final String? profile_photo_url;
  @override
  final String? team_member_id;

  @override
  String toString() {
    return 'DropboxAccount(account_id: $account_id, name: $name, email: $email, email_verified: $email_verified, disabled: $disabled, country: $country, locale: $locale, referral_link: $referral_link, is_paired: $is_paired, profile_photo_url: $profile_photo_url, team_member_id: $team_member_id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DropboxAccountImpl &&
            (identical(other.account_id, account_id) ||
                other.account_id == account_id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.email_verified, email_verified) ||
                other.email_verified == email_verified) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.referral_link, referral_link) ||
                other.referral_link == referral_link) &&
            (identical(other.is_paired, is_paired) ||
                other.is_paired == is_paired) &&
            (identical(other.profile_photo_url, profile_photo_url) ||
                other.profile_photo_url == profile_photo_url) &&
            (identical(other.team_member_id, team_member_id) ||
                other.team_member_id == team_member_id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      account_id,
      name,
      email,
      email_verified,
      disabled,
      country,
      locale,
      referral_link,
      is_paired,
      profile_photo_url,
      team_member_id);

  /// Create a copy of DropboxAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DropboxAccountImplCopyWith<_$DropboxAccountImpl> get copyWith =>
      __$$DropboxAccountImplCopyWithImpl<_$DropboxAccountImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DropboxAccountImplToJson(
      this,
    );
  }
}

abstract class _DropboxAccount implements DropboxAccount {
  const factory _DropboxAccount(
      {required final String account_id,
      required final DropboxAccountName name,
      required final String email,
      required final bool email_verified,
      required final bool disabled,
      required final String country,
      required final String locale,
      required final String referral_link,
      required final bool is_paired,
      final String? profile_photo_url,
      final String? team_member_id}) = _$DropboxAccountImpl;

  factory _DropboxAccount.fromJson(Map<String, dynamic> json) =
      _$DropboxAccountImpl.fromJson;

  @override
  String get account_id;
  @override
  DropboxAccountName get name;
  @override
  String get email;
  @override
  bool get email_verified;
  @override
  bool get disabled;
  @override
  String get country;
  @override
  String get locale;
  @override
  String get referral_link;
  @override
  bool get is_paired;
  @override
  String? get profile_photo_url;
  @override
  String? get team_member_id;

  /// Create a copy of DropboxAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DropboxAccountImplCopyWith<_$DropboxAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DropboxAccountName _$DropboxAccountNameFromJson(Map<String, dynamic> json) {
  return _DropboxAccountName.fromJson(json);
}

/// @nodoc
mixin _$DropboxAccountName {
  String get abbreviated_name => throw _privateConstructorUsedError;
  String get display_name => throw _privateConstructorUsedError;
  String get familiar_name => throw _privateConstructorUsedError;
  String get given_name => throw _privateConstructorUsedError;
  String get surname => throw _privateConstructorUsedError;

  /// Serializes this DropboxAccountName to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DropboxAccountName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DropboxAccountNameCopyWith<DropboxAccountName> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DropboxAccountNameCopyWith<$Res> {
  factory $DropboxAccountNameCopyWith(
          DropboxAccountName value, $Res Function(DropboxAccountName) then) =
      _$DropboxAccountNameCopyWithImpl<$Res, DropboxAccountName>;
  @useResult
  $Res call(
      {String abbreviated_name,
      String display_name,
      String familiar_name,
      String given_name,
      String surname});
}

/// @nodoc
class _$DropboxAccountNameCopyWithImpl<$Res, $Val extends DropboxAccountName>
    implements $DropboxAccountNameCopyWith<$Res> {
  _$DropboxAccountNameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DropboxAccountName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? abbreviated_name = null,
    Object? display_name = null,
    Object? familiar_name = null,
    Object? given_name = null,
    Object? surname = null,
  }) {
    return _then(_value.copyWith(
      abbreviated_name: null == abbreviated_name
          ? _value.abbreviated_name
          : abbreviated_name // ignore: cast_nullable_to_non_nullable
              as String,
      display_name: null == display_name
          ? _value.display_name
          : display_name // ignore: cast_nullable_to_non_nullable
              as String,
      familiar_name: null == familiar_name
          ? _value.familiar_name
          : familiar_name // ignore: cast_nullable_to_non_nullable
              as String,
      given_name: null == given_name
          ? _value.given_name
          : given_name // ignore: cast_nullable_to_non_nullable
              as String,
      surname: null == surname
          ? _value.surname
          : surname // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DropboxAccountNameImplCopyWith<$Res>
    implements $DropboxAccountNameCopyWith<$Res> {
  factory _$$DropboxAccountNameImplCopyWith(_$DropboxAccountNameImpl value,
          $Res Function(_$DropboxAccountNameImpl) then) =
      __$$DropboxAccountNameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String abbreviated_name,
      String display_name,
      String familiar_name,
      String given_name,
      String surname});
}

/// @nodoc
class __$$DropboxAccountNameImplCopyWithImpl<$Res>
    extends _$DropboxAccountNameCopyWithImpl<$Res, _$DropboxAccountNameImpl>
    implements _$$DropboxAccountNameImplCopyWith<$Res> {
  __$$DropboxAccountNameImplCopyWithImpl(_$DropboxAccountNameImpl _value,
      $Res Function(_$DropboxAccountNameImpl) _then)
      : super(_value, _then);

  /// Create a copy of DropboxAccountName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? abbreviated_name = null,
    Object? display_name = null,
    Object? familiar_name = null,
    Object? given_name = null,
    Object? surname = null,
  }) {
    return _then(_$DropboxAccountNameImpl(
      abbreviated_name: null == abbreviated_name
          ? _value.abbreviated_name
          : abbreviated_name // ignore: cast_nullable_to_non_nullable
              as String,
      display_name: null == display_name
          ? _value.display_name
          : display_name // ignore: cast_nullable_to_non_nullable
              as String,
      familiar_name: null == familiar_name
          ? _value.familiar_name
          : familiar_name // ignore: cast_nullable_to_non_nullable
              as String,
      given_name: null == given_name
          ? _value.given_name
          : given_name // ignore: cast_nullable_to_non_nullable
              as String,
      surname: null == surname
          ? _value.surname
          : surname // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DropboxAccountNameImpl implements _DropboxAccountName {
  const _$DropboxAccountNameImpl(
      {required this.abbreviated_name,
      required this.display_name,
      required this.familiar_name,
      required this.given_name,
      required this.surname});

  factory _$DropboxAccountNameImpl.fromJson(Map<String, dynamic> json) =>
      _$$DropboxAccountNameImplFromJson(json);

  @override
  final String abbreviated_name;
  @override
  final String display_name;
  @override
  final String familiar_name;
  @override
  final String given_name;
  @override
  final String surname;

  @override
  String toString() {
    return 'DropboxAccountName(abbreviated_name: $abbreviated_name, display_name: $display_name, familiar_name: $familiar_name, given_name: $given_name, surname: $surname)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DropboxAccountNameImpl &&
            (identical(other.abbreviated_name, abbreviated_name) ||
                other.abbreviated_name == abbreviated_name) &&
            (identical(other.display_name, display_name) ||
                other.display_name == display_name) &&
            (identical(other.familiar_name, familiar_name) ||
                other.familiar_name == familiar_name) &&
            (identical(other.given_name, given_name) ||
                other.given_name == given_name) &&
            (identical(other.surname, surname) || other.surname == surname));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, abbreviated_name, display_name,
      familiar_name, given_name, surname);

  /// Create a copy of DropboxAccountName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DropboxAccountNameImplCopyWith<_$DropboxAccountNameImpl> get copyWith =>
      __$$DropboxAccountNameImplCopyWithImpl<_$DropboxAccountNameImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DropboxAccountNameImplToJson(
      this,
    );
  }
}

abstract class _DropboxAccountName implements DropboxAccountName {
  const factory _DropboxAccountName(
      {required final String abbreviated_name,
      required final String display_name,
      required final String familiar_name,
      required final String given_name,
      required final String surname}) = _$DropboxAccountNameImpl;

  factory _DropboxAccountName.fromJson(Map<String, dynamic> json) =
      _$DropboxAccountNameImpl.fromJson;

  @override
  String get abbreviated_name;
  @override
  String get display_name;
  @override
  String get familiar_name;
  @override
  String get given_name;
  @override
  String get surname;

  /// Create a copy of DropboxAccountName
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DropboxAccountNameImplCopyWith<_$DropboxAccountNameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
