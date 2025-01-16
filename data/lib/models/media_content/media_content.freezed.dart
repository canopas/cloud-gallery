// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppMediaContent {
  Stream<List<int>> get stream => throw _privateConstructorUsedError;
  int? get length => throw _privateConstructorUsedError;
  String? get range => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Create a copy of AppMediaContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppMediaContentCopyWith<AppMediaContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppMediaContentCopyWith<$Res> {
  factory $AppMediaContentCopyWith(
          AppMediaContent value, $Res Function(AppMediaContent) then) =
      _$AppMediaContentCopyWithImpl<$Res, AppMediaContent>;
  @useResult
  $Res call(
      {Stream<List<int>> stream, int? length, String? range, String type});
}

/// @nodoc
class _$AppMediaContentCopyWithImpl<$Res, $Val extends AppMediaContent>
    implements $AppMediaContentCopyWith<$Res> {
  _$AppMediaContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppMediaContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stream = null,
    Object? length = freezed,
    Object? range = freezed,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      stream: null == stream
          ? _value.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as Stream<List<int>>,
      length: freezed == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int?,
      range: freezed == range
          ? _value.range
          : range // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppMediaContentImplCopyWith<$Res>
    implements $AppMediaContentCopyWith<$Res> {
  factory _$$AppMediaContentImplCopyWith(_$AppMediaContentImpl value,
          $Res Function(_$AppMediaContentImpl) then) =
      __$$AppMediaContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Stream<List<int>> stream, int? length, String? range, String type});
}

/// @nodoc
class __$$AppMediaContentImplCopyWithImpl<$Res>
    extends _$AppMediaContentCopyWithImpl<$Res, _$AppMediaContentImpl>
    implements _$$AppMediaContentImplCopyWith<$Res> {
  __$$AppMediaContentImplCopyWithImpl(
      _$AppMediaContentImpl _value, $Res Function(_$AppMediaContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppMediaContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stream = null,
    Object? length = freezed,
    Object? range = freezed,
    Object? type = null,
  }) {
    return _then(_$AppMediaContentImpl(
      stream: null == stream
          ? _value.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as Stream<List<int>>,
      length: freezed == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int?,
      range: freezed == range
          ? _value.range
          : range // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AppMediaContentImpl implements _AppMediaContent {
  const _$AppMediaContentImpl(
      {required this.stream,
      required this.length,
      this.range,
      required this.type});

  @override
  final Stream<List<int>> stream;
  @override
  final int? length;
  @override
  final String? range;
  @override
  final String type;

  @override
  String toString() {
    return 'AppMediaContent(stream: $stream, length: $length, range: $range, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppMediaContentImpl &&
            (identical(other.stream, stream) || other.stream == stream) &&
            (identical(other.length, length) || other.length == length) &&
            (identical(other.range, range) || other.range == range) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, stream, length, range, type);

  /// Create a copy of AppMediaContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppMediaContentImplCopyWith<_$AppMediaContentImpl> get copyWith =>
      __$$AppMediaContentImplCopyWithImpl<_$AppMediaContentImpl>(
          this, _$identity);
}

abstract class _AppMediaContent implements AppMediaContent {
  const factory _AppMediaContent(
      {required final Stream<List<int>> stream,
      required final int? length,
      final String? range,
      required final String type}) = _$AppMediaContentImpl;

  @override
  Stream<List<int>> get stream;
  @override
  int? get length;
  @override
  String? get range;
  @override
  String get type;

  /// Create a copy of AppMediaContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppMediaContentImplCopyWith<_$AppMediaContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
