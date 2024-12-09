// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppMedia _$AppMediaFromJson(Map<String, dynamic> json) {
  return _AppMedia.fromJson(json);
}

/// @nodoc
mixin _$AppMedia {
  String get id => throw _privateConstructorUsedError;
  String? get driveMediaRefId => throw _privateConstructorUsedError;
  String? get dropboxMediaRefId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  String? get thumbnailLink => throw _privateConstructorUsedError;
  double? get displayHeight => throw _privateConstructorUsedError;
  double? get displayWidth => throw _privateConstructorUsedError;
  AppMediaType get type => throw _privateConstructorUsedError;
  String? get mimeType => throw _privateConstructorUsedError;
  @DateTimeJsonConverter()
  DateTime? get createdTime => throw _privateConstructorUsedError;
  @DateTimeJsonConverter()
  DateTime? get modifiedTime => throw _privateConstructorUsedError;
  AppMediaOrientation? get orientation => throw _privateConstructorUsedError;
  String? get size => throw _privateConstructorUsedError;
  @DurationJsonConverter()
  Duration? get videoDuration => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  List<AppMediaSource> get sources => throw _privateConstructorUsedError;

  /// Serializes this AppMedia to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppMediaCopyWith<AppMedia> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppMediaCopyWith<$Res> {
  factory $AppMediaCopyWith(AppMedia value, $Res Function(AppMedia) then) =
      _$AppMediaCopyWithImpl<$Res, AppMedia>;
  @useResult
  $Res call(
      {String id,
      String? driveMediaRefId,
      String? dropboxMediaRefId,
      String? name,
      String path,
      String? thumbnailLink,
      double? displayHeight,
      double? displayWidth,
      AppMediaType type,
      String? mimeType,
      @DateTimeJsonConverter() DateTime? createdTime,
      @DateTimeJsonConverter() DateTime? modifiedTime,
      AppMediaOrientation? orientation,
      String? size,
      @DurationJsonConverter() Duration? videoDuration,
      double? latitude,
      double? longitude,
      List<AppMediaSource> sources});
}

/// @nodoc
class _$AppMediaCopyWithImpl<$Res, $Val extends AppMedia>
    implements $AppMediaCopyWith<$Res> {
  _$AppMediaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppMedia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? driveMediaRefId = freezed,
    Object? dropboxMediaRefId = freezed,
    Object? name = freezed,
    Object? path = null,
    Object? thumbnailLink = freezed,
    Object? displayHeight = freezed,
    Object? displayWidth = freezed,
    Object? type = null,
    Object? mimeType = freezed,
    Object? createdTime = freezed,
    Object? modifiedTime = freezed,
    Object? orientation = freezed,
    Object? size = freezed,
    Object? videoDuration = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? sources = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      driveMediaRefId: freezed == driveMediaRefId
          ? _value.driveMediaRefId
          : driveMediaRefId // ignore: cast_nullable_to_non_nullable
              as String?,
      dropboxMediaRefId: freezed == dropboxMediaRefId
          ? _value.dropboxMediaRefId
          : dropboxMediaRefId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailLink: freezed == thumbnailLink
          ? _value.thumbnailLink
          : thumbnailLink // ignore: cast_nullable_to_non_nullable
              as String?,
      displayHeight: freezed == displayHeight
          ? _value.displayHeight
          : displayHeight // ignore: cast_nullable_to_non_nullable
              as double?,
      displayWidth: freezed == displayWidth
          ? _value.displayWidth
          : displayWidth // ignore: cast_nullable_to_non_nullable
              as double?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AppMediaType,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      modifiedTime: freezed == modifiedTime
          ? _value.modifiedTime
          : modifiedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      orientation: freezed == orientation
          ? _value.orientation
          : orientation // ignore: cast_nullable_to_non_nullable
              as AppMediaOrientation?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      videoDuration: freezed == videoDuration
          ? _value.videoDuration
          : videoDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      sources: null == sources
          ? _value.sources
          : sources // ignore: cast_nullable_to_non_nullable
              as List<AppMediaSource>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppMediaImplCopyWith<$Res>
    implements $AppMediaCopyWith<$Res> {
  factory _$$AppMediaImplCopyWith(
          _$AppMediaImpl value, $Res Function(_$AppMediaImpl) then) =
      __$$AppMediaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? driveMediaRefId,
      String? dropboxMediaRefId,
      String? name,
      String path,
      String? thumbnailLink,
      double? displayHeight,
      double? displayWidth,
      AppMediaType type,
      String? mimeType,
      @DateTimeJsonConverter() DateTime? createdTime,
      @DateTimeJsonConverter() DateTime? modifiedTime,
      AppMediaOrientation? orientation,
      String? size,
      @DurationJsonConverter() Duration? videoDuration,
      double? latitude,
      double? longitude,
      List<AppMediaSource> sources});
}

/// @nodoc
class __$$AppMediaImplCopyWithImpl<$Res>
    extends _$AppMediaCopyWithImpl<$Res, _$AppMediaImpl>
    implements _$$AppMediaImplCopyWith<$Res> {
  __$$AppMediaImplCopyWithImpl(
      _$AppMediaImpl _value, $Res Function(_$AppMediaImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppMedia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? driveMediaRefId = freezed,
    Object? dropboxMediaRefId = freezed,
    Object? name = freezed,
    Object? path = null,
    Object? thumbnailLink = freezed,
    Object? displayHeight = freezed,
    Object? displayWidth = freezed,
    Object? type = null,
    Object? mimeType = freezed,
    Object? createdTime = freezed,
    Object? modifiedTime = freezed,
    Object? orientation = freezed,
    Object? size = freezed,
    Object? videoDuration = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? sources = null,
  }) {
    return _then(_$AppMediaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      driveMediaRefId: freezed == driveMediaRefId
          ? _value.driveMediaRefId
          : driveMediaRefId // ignore: cast_nullable_to_non_nullable
              as String?,
      dropboxMediaRefId: freezed == dropboxMediaRefId
          ? _value.dropboxMediaRefId
          : dropboxMediaRefId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailLink: freezed == thumbnailLink
          ? _value.thumbnailLink
          : thumbnailLink // ignore: cast_nullable_to_non_nullable
              as String?,
      displayHeight: freezed == displayHeight
          ? _value.displayHeight
          : displayHeight // ignore: cast_nullable_to_non_nullable
              as double?,
      displayWidth: freezed == displayWidth
          ? _value.displayWidth
          : displayWidth // ignore: cast_nullable_to_non_nullable
              as double?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AppMediaType,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      modifiedTime: freezed == modifiedTime
          ? _value.modifiedTime
          : modifiedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      orientation: freezed == orientation
          ? _value.orientation
          : orientation // ignore: cast_nullable_to_non_nullable
              as AppMediaOrientation?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      videoDuration: freezed == videoDuration
          ? _value.videoDuration
          : videoDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      sources: null == sources
          ? _value._sources
          : sources // ignore: cast_nullable_to_non_nullable
              as List<AppMediaSource>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppMediaImpl extends _AppMedia {
  const _$AppMediaImpl(
      {required this.id,
      this.driveMediaRefId,
      this.dropboxMediaRefId,
      this.name,
      required this.path,
      this.thumbnailLink,
      this.displayHeight,
      this.displayWidth,
      required this.type,
      this.mimeType,
      @DateTimeJsonConverter() this.createdTime,
      @DateTimeJsonConverter() this.modifiedTime,
      this.orientation,
      this.size,
      @DurationJsonConverter() this.videoDuration,
      this.latitude,
      this.longitude,
      final List<AppMediaSource> sources = const [AppMediaSource.local]})
      : _sources = sources,
        super._();

  factory _$AppMediaImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppMediaImplFromJson(json);

  @override
  final String id;
  @override
  final String? driveMediaRefId;
  @override
  final String? dropboxMediaRefId;
  @override
  final String? name;
  @override
  final String path;
  @override
  final String? thumbnailLink;
  @override
  final double? displayHeight;
  @override
  final double? displayWidth;
  @override
  final AppMediaType type;
  @override
  final String? mimeType;
  @override
  @DateTimeJsonConverter()
  final DateTime? createdTime;
  @override
  @DateTimeJsonConverter()
  final DateTime? modifiedTime;
  @override
  final AppMediaOrientation? orientation;
  @override
  final String? size;
  @override
  @DurationJsonConverter()
  final Duration? videoDuration;
  @override
  final double? latitude;
  @override
  final double? longitude;
  final List<AppMediaSource> _sources;
  @override
  @JsonKey()
  List<AppMediaSource> get sources {
    if (_sources is EqualUnmodifiableListView) return _sources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sources);
  }

  @override
  String toString() {
    return 'AppMedia(id: $id, driveMediaRefId: $driveMediaRefId, dropboxMediaRefId: $dropboxMediaRefId, name: $name, path: $path, thumbnailLink: $thumbnailLink, displayHeight: $displayHeight, displayWidth: $displayWidth, type: $type, mimeType: $mimeType, createdTime: $createdTime, modifiedTime: $modifiedTime, orientation: $orientation, size: $size, videoDuration: $videoDuration, latitude: $latitude, longitude: $longitude, sources: $sources)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppMediaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.driveMediaRefId, driveMediaRefId) ||
                other.driveMediaRefId == driveMediaRefId) &&
            (identical(other.dropboxMediaRefId, dropboxMediaRefId) ||
                other.dropboxMediaRefId == dropboxMediaRefId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.thumbnailLink, thumbnailLink) ||
                other.thumbnailLink == thumbnailLink) &&
            (identical(other.displayHeight, displayHeight) ||
                other.displayHeight == displayHeight) &&
            (identical(other.displayWidth, displayWidth) ||
                other.displayWidth == displayWidth) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.modifiedTime, modifiedTime) ||
                other.modifiedTime == modifiedTime) &&
            (identical(other.orientation, orientation) ||
                other.orientation == orientation) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.videoDuration, videoDuration) ||
                other.videoDuration == videoDuration) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(other._sources, _sources));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      driveMediaRefId,
      dropboxMediaRefId,
      name,
      path,
      thumbnailLink,
      displayHeight,
      displayWidth,
      type,
      mimeType,
      createdTime,
      modifiedTime,
      orientation,
      size,
      videoDuration,
      latitude,
      longitude,
      const DeepCollectionEquality().hash(_sources));

  /// Create a copy of AppMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppMediaImplCopyWith<_$AppMediaImpl> get copyWith =>
      __$$AppMediaImplCopyWithImpl<_$AppMediaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppMediaImplToJson(
      this,
    );
  }
}

abstract class _AppMedia extends AppMedia {
  const factory _AppMedia(
      {required final String id,
      final String? driveMediaRefId,
      final String? dropboxMediaRefId,
      final String? name,
      required final String path,
      final String? thumbnailLink,
      final double? displayHeight,
      final double? displayWidth,
      required final AppMediaType type,
      final String? mimeType,
      @DateTimeJsonConverter() final DateTime? createdTime,
      @DateTimeJsonConverter() final DateTime? modifiedTime,
      final AppMediaOrientation? orientation,
      final String? size,
      @DurationJsonConverter() final Duration? videoDuration,
      final double? latitude,
      final double? longitude,
      final List<AppMediaSource> sources}) = _$AppMediaImpl;
  const _AppMedia._() : super._();

  factory _AppMedia.fromJson(Map<String, dynamic> json) =
      _$AppMediaImpl.fromJson;

  @override
  String get id;
  @override
  String? get driveMediaRefId;
  @override
  String? get dropboxMediaRefId;
  @override
  String? get name;
  @override
  String get path;
  @override
  String? get thumbnailLink;
  @override
  double? get displayHeight;
  @override
  double? get displayWidth;
  @override
  AppMediaType get type;
  @override
  String? get mimeType;
  @override
  @DateTimeJsonConverter()
  DateTime? get createdTime;
  @override
  @DateTimeJsonConverter()
  DateTime? get modifiedTime;
  @override
  AppMediaOrientation? get orientation;
  @override
  String? get size;
  @override
  @DurationJsonConverter()
  Duration? get videoDuration;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  List<AppMediaSource> get sources;

  /// Create a copy of AppMedia
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppMediaImplCopyWith<_$AppMediaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
