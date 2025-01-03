// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_media_list_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AlbumMediaListState {
  List<AppMedia> get medias => throw _privateConstructorUsedError;
  Album get album => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  bool get deleteAlbumSuccess => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;
  Object? get actionError => throw _privateConstructorUsedError;

  /// Create a copy of AlbumMediaListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlbumMediaListStateCopyWith<AlbumMediaListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlbumMediaListStateCopyWith<$Res> {
  factory $AlbumMediaListStateCopyWith(
          AlbumMediaListState value, $Res Function(AlbumMediaListState) then) =
      _$AlbumMediaListStateCopyWithImpl<$Res, AlbumMediaListState>;
  @useResult
  $Res call(
      {List<AppMedia> medias,
      Album album,
      bool loading,
      bool deleteAlbumSuccess,
      Object? error,
      Object? actionError});

  $AlbumCopyWith<$Res> get album;
}

/// @nodoc
class _$AlbumMediaListStateCopyWithImpl<$Res, $Val extends AlbumMediaListState>
    implements $AlbumMediaListStateCopyWith<$Res> {
  _$AlbumMediaListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlbumMediaListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medias = null,
    Object? album = null,
    Object? loading = null,
    Object? deleteAlbumSuccess = null,
    Object? error = freezed,
    Object? actionError = freezed,
  }) {
    return _then(_value.copyWith(
      medias: null == medias
          ? _value.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as Album,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      deleteAlbumSuccess: null == deleteAlbumSuccess
          ? _value.deleteAlbumSuccess
          : deleteAlbumSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
      actionError: freezed == actionError ? _value.actionError : actionError,
    ) as $Val);
  }

  /// Create a copy of AlbumMediaListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AlbumCopyWith<$Res> get album {
    return $AlbumCopyWith<$Res>(_value.album, (value) {
      return _then(_value.copyWith(album: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AlbumMediaListStateImplCopyWith<$Res>
    implements $AlbumMediaListStateCopyWith<$Res> {
  factory _$$AlbumMediaListStateImplCopyWith(_$AlbumMediaListStateImpl value,
          $Res Function(_$AlbumMediaListStateImpl) then) =
      __$$AlbumMediaListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<AppMedia> medias,
      Album album,
      bool loading,
      bool deleteAlbumSuccess,
      Object? error,
      Object? actionError});

  @override
  $AlbumCopyWith<$Res> get album;
}

/// @nodoc
class __$$AlbumMediaListStateImplCopyWithImpl<$Res>
    extends _$AlbumMediaListStateCopyWithImpl<$Res, _$AlbumMediaListStateImpl>
    implements _$$AlbumMediaListStateImplCopyWith<$Res> {
  __$$AlbumMediaListStateImplCopyWithImpl(_$AlbumMediaListStateImpl _value,
      $Res Function(_$AlbumMediaListStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlbumMediaListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medias = null,
    Object? album = null,
    Object? loading = null,
    Object? deleteAlbumSuccess = null,
    Object? error = freezed,
    Object? actionError = freezed,
  }) {
    return _then(_$AlbumMediaListStateImpl(
      medias: null == medias
          ? _value._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as Album,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      deleteAlbumSuccess: null == deleteAlbumSuccess
          ? _value.deleteAlbumSuccess
          : deleteAlbumSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
      actionError: freezed == actionError ? _value.actionError : actionError,
    ));
  }
}

/// @nodoc

class _$AlbumMediaListStateImpl implements _AlbumMediaListState {
  const _$AlbumMediaListStateImpl(
      {final List<AppMedia> medias = const [],
      required this.album,
      this.loading = false,
      this.deleteAlbumSuccess = false,
      this.error,
      this.actionError})
      : _medias = medias;

  final List<AppMedia> _medias;
  @override
  @JsonKey()
  List<AppMedia> get medias {
    if (_medias is EqualUnmodifiableListView) return _medias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medias);
  }

  @override
  final Album album;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool deleteAlbumSuccess;
  @override
  final Object? error;
  @override
  final Object? actionError;

  @override
  String toString() {
    return 'AlbumMediaListState(medias: $medias, album: $album, loading: $loading, deleteAlbumSuccess: $deleteAlbumSuccess, error: $error, actionError: $actionError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlbumMediaListStateImpl &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            (identical(other.album, album) || other.album == album) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.deleteAlbumSuccess, deleteAlbumSuccess) ||
                other.deleteAlbumSuccess == deleteAlbumSuccess) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            const DeepCollectionEquality()
                .equals(other.actionError, actionError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_medias),
      album,
      loading,
      deleteAlbumSuccess,
      const DeepCollectionEquality().hash(error),
      const DeepCollectionEquality().hash(actionError));

  /// Create a copy of AlbumMediaListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlbumMediaListStateImplCopyWith<_$AlbumMediaListStateImpl> get copyWith =>
      __$$AlbumMediaListStateImplCopyWithImpl<_$AlbumMediaListStateImpl>(
          this, _$identity);
}

abstract class _AlbumMediaListState implements AlbumMediaListState {
  const factory _AlbumMediaListState(
      {final List<AppMedia> medias,
      required final Album album,
      final bool loading,
      final bool deleteAlbumSuccess,
      final Object? error,
      final Object? actionError}) = _$AlbumMediaListStateImpl;

  @override
  List<AppMedia> get medias;
  @override
  Album get album;
  @override
  bool get loading;
  @override
  bool get deleteAlbumSuccess;
  @override
  Object? get error;
  @override
  Object? get actionError;

  /// Create a copy of AlbumMediaListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlbumMediaListStateImplCopyWith<_$AlbumMediaListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
