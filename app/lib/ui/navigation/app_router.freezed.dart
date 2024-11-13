// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_router.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MediaPreviewRouteData _$MediaPreviewRouteDataFromJson(
    Map<String, dynamic> json) {
  return _MediaPreviewRouteData.fromJson(json);
}

/// @nodoc
mixin _$MediaPreviewRouteData {
  List<AppMedia> get medias => throw _privateConstructorUsedError;
  String get startFrom => throw _privateConstructorUsedError;

  /// Serializes this MediaPreviewRouteData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MediaPreviewRouteData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaPreviewRouteDataCopyWith<MediaPreviewRouteData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaPreviewRouteDataCopyWith<$Res> {
  factory $MediaPreviewRouteDataCopyWith(MediaPreviewRouteData value,
          $Res Function(MediaPreviewRouteData) then) =
      _$MediaPreviewRouteDataCopyWithImpl<$Res, MediaPreviewRouteData>;
  @useResult
  $Res call({List<AppMedia> medias, String startFrom});
}

/// @nodoc
class _$MediaPreviewRouteDataCopyWithImpl<$Res,
        $Val extends MediaPreviewRouteData>
    implements $MediaPreviewRouteDataCopyWith<$Res> {
  _$MediaPreviewRouteDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaPreviewRouteData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medias = null,
    Object? startFrom = null,
  }) {
    return _then(_value.copyWith(
      medias: null == medias
          ? _value.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      startFrom: null == startFrom
          ? _value.startFrom
          : startFrom // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MediaPreviewRouteDataImplCopyWith<$Res>
    implements $MediaPreviewRouteDataCopyWith<$Res> {
  factory _$$MediaPreviewRouteDataImplCopyWith(
          _$MediaPreviewRouteDataImpl value,
          $Res Function(_$MediaPreviewRouteDataImpl) then) =
      __$$MediaPreviewRouteDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<AppMedia> medias, String startFrom});
}

/// @nodoc
class __$$MediaPreviewRouteDataImplCopyWithImpl<$Res>
    extends _$MediaPreviewRouteDataCopyWithImpl<$Res,
        _$MediaPreviewRouteDataImpl>
    implements _$$MediaPreviewRouteDataImplCopyWith<$Res> {
  __$$MediaPreviewRouteDataImplCopyWithImpl(_$MediaPreviewRouteDataImpl _value,
      $Res Function(_$MediaPreviewRouteDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaPreviewRouteData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medias = null,
    Object? startFrom = null,
  }) {
    return _then(_$MediaPreviewRouteDataImpl(
      medias: null == medias
          ? _value._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      startFrom: null == startFrom
          ? _value.startFrom
          : startFrom // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MediaPreviewRouteDataImpl implements _MediaPreviewRouteData {
  const _$MediaPreviewRouteDataImpl(
      {required final List<AppMedia> medias, required this.startFrom})
      : _medias = medias;

  factory _$MediaPreviewRouteDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaPreviewRouteDataImplFromJson(json);

  final List<AppMedia> _medias;
  @override
  List<AppMedia> get medias {
    if (_medias is EqualUnmodifiableListView) return _medias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medias);
  }

  @override
  final String startFrom;

  @override
  String toString() {
    return 'MediaPreviewRouteData(medias: $medias, startFrom: $startFrom)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaPreviewRouteDataImpl &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            (identical(other.startFrom, startFrom) ||
                other.startFrom == startFrom));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_medias), startFrom);

  /// Create a copy of MediaPreviewRouteData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaPreviewRouteDataImplCopyWith<_$MediaPreviewRouteDataImpl>
      get copyWith => __$$MediaPreviewRouteDataImplCopyWithImpl<
          _$MediaPreviewRouteDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaPreviewRouteDataImplToJson(
      this,
    );
  }
}

abstract class _MediaPreviewRouteData implements MediaPreviewRouteData {
  const factory _MediaPreviewRouteData(
      {required final List<AppMedia> medias,
      required final String startFrom}) = _$MediaPreviewRouteDataImpl;

  factory _MediaPreviewRouteData.fromJson(Map<String, dynamic> json) =
      _$MediaPreviewRouteDataImpl.fromJson;

  @override
  List<AppMedia> get medias;
  @override
  String get startFrom;

  /// Create a copy of MediaPreviewRouteData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaPreviewRouteDataImplCopyWith<_$MediaPreviewRouteDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
