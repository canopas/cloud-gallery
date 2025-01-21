// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clean_up.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CleanUpMedia _$CleanUpMediaFromJson(Map<String, dynamic> json) {
  return _CleanUpMedia.fromJson(json);
}

/// @nodoc
mixin _$CleanUpMedia {
  String get id => throw _privateConstructorUsedError;
  String? get provider_ref_id => throw _privateConstructorUsedError;
  AppMediaSource get provider => throw _privateConstructorUsedError;
  @DateTimeJsonConverter()
  DateTime get created_at => throw _privateConstructorUsedError;

  /// Serializes this CleanUpMedia to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CleanUpMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CleanUpMediaCopyWith<CleanUpMedia> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CleanUpMediaCopyWith<$Res> {
  factory $CleanUpMediaCopyWith(
          CleanUpMedia value, $Res Function(CleanUpMedia) then) =
      _$CleanUpMediaCopyWithImpl<$Res, CleanUpMedia>;
  @useResult
  $Res call(
      {String id,
      String? provider_ref_id,
      AppMediaSource provider,
      @DateTimeJsonConverter() DateTime created_at});
}

/// @nodoc
class _$CleanUpMediaCopyWithImpl<$Res, $Val extends CleanUpMedia>
    implements $CleanUpMediaCopyWith<$Res> {
  _$CleanUpMediaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CleanUpMedia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? provider_ref_id = freezed,
    Object? provider = null,
    Object? created_at = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      provider_ref_id: freezed == provider_ref_id
          ? _value.provider_ref_id
          : provider_ref_id // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as AppMediaSource,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CleanUpMediaImplCopyWith<$Res>
    implements $CleanUpMediaCopyWith<$Res> {
  factory _$$CleanUpMediaImplCopyWith(
          _$CleanUpMediaImpl value, $Res Function(_$CleanUpMediaImpl) then) =
      __$$CleanUpMediaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? provider_ref_id,
      AppMediaSource provider,
      @DateTimeJsonConverter() DateTime created_at});
}

/// @nodoc
class __$$CleanUpMediaImplCopyWithImpl<$Res>
    extends _$CleanUpMediaCopyWithImpl<$Res, _$CleanUpMediaImpl>
    implements _$$CleanUpMediaImplCopyWith<$Res> {
  __$$CleanUpMediaImplCopyWithImpl(
      _$CleanUpMediaImpl _value, $Res Function(_$CleanUpMediaImpl) _then)
      : super(_value, _then);

  /// Create a copy of CleanUpMedia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? provider_ref_id = freezed,
    Object? provider = null,
    Object? created_at = null,
  }) {
    return _then(_$CleanUpMediaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      provider_ref_id: freezed == provider_ref_id
          ? _value.provider_ref_id
          : provider_ref_id // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as AppMediaSource,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CleanUpMediaImpl implements _CleanUpMedia {
  const _$CleanUpMediaImpl(
      {required this.id,
      this.provider_ref_id,
      required this.provider,
      @DateTimeJsonConverter() required this.created_at});

  factory _$CleanUpMediaImpl.fromJson(Map<String, dynamic> json) =>
      _$$CleanUpMediaImplFromJson(json);

  @override
  final String id;
  @override
  final String? provider_ref_id;
  @override
  final AppMediaSource provider;
  @override
  @DateTimeJsonConverter()
  final DateTime created_at;

  @override
  String toString() {
    return 'CleanUpMedia(id: $id, provider_ref_id: $provider_ref_id, provider: $provider, created_at: $created_at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CleanUpMediaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.provider_ref_id, provider_ref_id) ||
                other.provider_ref_id == provider_ref_id) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, provider_ref_id, provider, created_at);

  /// Create a copy of CleanUpMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CleanUpMediaImplCopyWith<_$CleanUpMediaImpl> get copyWith =>
      __$$CleanUpMediaImplCopyWithImpl<_$CleanUpMediaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CleanUpMediaImplToJson(
      this,
    );
  }
}

abstract class _CleanUpMedia implements CleanUpMedia {
  const factory _CleanUpMedia(
          {required final String id,
          final String? provider_ref_id,
          required final AppMediaSource provider,
          @DateTimeJsonConverter() required final DateTime created_at}) =
      _$CleanUpMediaImpl;

  factory _CleanUpMedia.fromJson(Map<String, dynamic> json) =
      _$CleanUpMediaImpl.fromJson;

  @override
  String get id;
  @override
  String? get provider_ref_id;
  @override
  AppMediaSource get provider;
  @override
  @DateTimeJsonConverter()
  DateTime get created_at;

  /// Create a copy of CleanUpMedia
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CleanUpMediaImplCopyWith<_$CleanUpMediaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
