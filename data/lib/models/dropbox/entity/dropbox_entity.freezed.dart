// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dropbox_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiDropboxEntity _$ApiDropboxEntityFromJson(Map<String, dynamic> json) {
  return _ApiDropboxEntity.fromJson(json);
}

/// @nodoc
mixin _$ApiDropboxEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get path_lower => throw _privateConstructorUsedError;
  String get path_display => throw _privateConstructorUsedError;
  @JsonKey(name: '.tag', unknownEnumValue: ApiDropboxEntityType.unknown)
  ApiDropboxEntityType get type => throw _privateConstructorUsedError;

  /// Serializes this ApiDropboxEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiDropboxEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiDropboxEntityCopyWith<ApiDropboxEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiDropboxEntityCopyWith<$Res> {
  factory $ApiDropboxEntityCopyWith(
          ApiDropboxEntity value, $Res Function(ApiDropboxEntity) then) =
      _$ApiDropboxEntityCopyWithImpl<$Res, ApiDropboxEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String path_lower,
      String path_display,
      @JsonKey(name: '.tag', unknownEnumValue: ApiDropboxEntityType.unknown)
      ApiDropboxEntityType type});
}

/// @nodoc
class _$ApiDropboxEntityCopyWithImpl<$Res, $Val extends ApiDropboxEntity>
    implements $ApiDropboxEntityCopyWith<$Res> {
  _$ApiDropboxEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiDropboxEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? path_lower = null,
    Object? path_display = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path_lower: null == path_lower
          ? _value.path_lower
          : path_lower // ignore: cast_nullable_to_non_nullable
              as String,
      path_display: null == path_display
          ? _value.path_display
          : path_display // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ApiDropboxEntityType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiDropboxEntityImplCopyWith<$Res>
    implements $ApiDropboxEntityCopyWith<$Res> {
  factory _$$ApiDropboxEntityImplCopyWith(_$ApiDropboxEntityImpl value,
          $Res Function(_$ApiDropboxEntityImpl) then) =
      __$$ApiDropboxEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String path_lower,
      String path_display,
      @JsonKey(name: '.tag', unknownEnumValue: ApiDropboxEntityType.unknown)
      ApiDropboxEntityType type});
}

/// @nodoc
class __$$ApiDropboxEntityImplCopyWithImpl<$Res>
    extends _$ApiDropboxEntityCopyWithImpl<$Res, _$ApiDropboxEntityImpl>
    implements _$$ApiDropboxEntityImplCopyWith<$Res> {
  __$$ApiDropboxEntityImplCopyWithImpl(_$ApiDropboxEntityImpl _value,
      $Res Function(_$ApiDropboxEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiDropboxEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? path_lower = null,
    Object? path_display = null,
    Object? type = null,
  }) {
    return _then(_$ApiDropboxEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path_lower: null == path_lower
          ? _value.path_lower
          : path_lower // ignore: cast_nullable_to_non_nullable
              as String,
      path_display: null == path_display
          ? _value.path_display
          : path_display // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ApiDropboxEntityType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiDropboxEntityImpl implements _ApiDropboxEntity {
  const _$ApiDropboxEntityImpl(
      {required this.id,
      required this.name,
      required this.path_lower,
      required this.path_display,
      @JsonKey(name: '.tag', unknownEnumValue: ApiDropboxEntityType.unknown)
      required this.type});

  factory _$ApiDropboxEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiDropboxEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String path_lower;
  @override
  final String path_display;
  @override
  @JsonKey(name: '.tag', unknownEnumValue: ApiDropboxEntityType.unknown)
  final ApiDropboxEntityType type;

  @override
  String toString() {
    return 'ApiDropboxEntity(id: $id, name: $name, path_lower: $path_lower, path_display: $path_display, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiDropboxEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path_lower, path_lower) ||
                other.path_lower == path_lower) &&
            (identical(other.path_display, path_display) ||
                other.path_display == path_display) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, path_lower, path_display, type);

  /// Create a copy of ApiDropboxEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiDropboxEntityImplCopyWith<_$ApiDropboxEntityImpl> get copyWith =>
      __$$ApiDropboxEntityImplCopyWithImpl<_$ApiDropboxEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiDropboxEntityImplToJson(
      this,
    );
  }
}

abstract class _ApiDropboxEntity implements ApiDropboxEntity {
  const factory _ApiDropboxEntity(
      {required final String id,
      required final String name,
      required final String path_lower,
      required final String path_display,
      @JsonKey(name: '.tag', unknownEnumValue: ApiDropboxEntityType.unknown)
      required final ApiDropboxEntityType type}) = _$ApiDropboxEntityImpl;

  factory _ApiDropboxEntity.fromJson(Map<String, dynamic> json) =
      _$ApiDropboxEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get path_lower;
  @override
  String get path_display;
  @override
  @JsonKey(name: '.tag', unknownEnumValue: ApiDropboxEntityType.unknown)
  ApiDropboxEntityType get type;

  /// Create a copy of ApiDropboxEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiDropboxEntityImplCopyWith<_$ApiDropboxEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
