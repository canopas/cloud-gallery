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
  Map<String, AppMedia> get medias => throw _privateConstructorUsedError;
  List<String> get selectedMedias => throw _privateConstructorUsedError;
  Album get album => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  bool get loadingMore => throw _privateConstructorUsedError;
  List<String> get addingMedia => throw _privateConstructorUsedError;
  List<String> get removingMedia => throw _privateConstructorUsedError;
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
      {Map<String, AppMedia> medias,
      List<String> selectedMedias,
      Album album,
      bool loading,
      bool loadingMore,
      List<String> addingMedia,
      List<String> removingMedia,
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
    Object? selectedMedias = null,
    Object? album = null,
    Object? loading = null,
    Object? loadingMore = null,
    Object? addingMedia = null,
    Object? removingMedia = null,
    Object? deleteAlbumSuccess = null,
    Object? error = freezed,
    Object? actionError = freezed,
  }) {
    return _then(_value.copyWith(
      medias: null == medias
          ? _value.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as Map<String, AppMedia>,
      selectedMedias: null == selectedMedias
          ? _value.selectedMedias
          : selectedMedias // ignore: cast_nullable_to_non_nullable
              as List<String>,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as Album,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingMore: null == loadingMore
          ? _value.loadingMore
          : loadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      addingMedia: null == addingMedia
          ? _value.addingMedia
          : addingMedia // ignore: cast_nullable_to_non_nullable
              as List<String>,
      removingMedia: null == removingMedia
          ? _value.removingMedia
          : removingMedia // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
      {Map<String, AppMedia> medias,
      List<String> selectedMedias,
      Album album,
      bool loading,
      bool loadingMore,
      List<String> addingMedia,
      List<String> removingMedia,
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
    Object? selectedMedias = null,
    Object? album = null,
    Object? loading = null,
    Object? loadingMore = null,
    Object? addingMedia = null,
    Object? removingMedia = null,
    Object? deleteAlbumSuccess = null,
    Object? error = freezed,
    Object? actionError = freezed,
  }) {
    return _then(_$AlbumMediaListStateImpl(
      medias: null == medias
          ? _value._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as Map<String, AppMedia>,
      selectedMedias: null == selectedMedias
          ? _value._selectedMedias
          : selectedMedias // ignore: cast_nullable_to_non_nullable
              as List<String>,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as Album,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingMore: null == loadingMore
          ? _value.loadingMore
          : loadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      addingMedia: null == addingMedia
          ? _value._addingMedia
          : addingMedia // ignore: cast_nullable_to_non_nullable
              as List<String>,
      removingMedia: null == removingMedia
          ? _value._removingMedia
          : removingMedia // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
      {final Map<String, AppMedia> medias = const {},
      final List<String> selectedMedias = const [],
      required this.album,
      this.loading = false,
      this.loadingMore = false,
      final List<String> addingMedia = const [],
      final List<String> removingMedia = const [],
      this.deleteAlbumSuccess = false,
      this.error,
      this.actionError})
      : _medias = medias,
        _selectedMedias = selectedMedias,
        _addingMedia = addingMedia,
        _removingMedia = removingMedia;

  final Map<String, AppMedia> _medias;
  @override
  @JsonKey()
  Map<String, AppMedia> get medias {
    if (_medias is EqualUnmodifiableMapView) return _medias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_medias);
  }

  final List<String> _selectedMedias;
  @override
  @JsonKey()
  List<String> get selectedMedias {
    if (_selectedMedias is EqualUnmodifiableListView) return _selectedMedias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedMedias);
  }

  @override
  final Album album;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool loadingMore;
  final List<String> _addingMedia;
  @override
  @JsonKey()
  List<String> get addingMedia {
    if (_addingMedia is EqualUnmodifiableListView) return _addingMedia;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addingMedia);
  }

  final List<String> _removingMedia;
  @override
  @JsonKey()
  List<String> get removingMedia {
    if (_removingMedia is EqualUnmodifiableListView) return _removingMedia;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_removingMedia);
  }

  @override
  @JsonKey()
  final bool deleteAlbumSuccess;
  @override
  final Object? error;
  @override
  final Object? actionError;

  @override
  String toString() {
    return 'AlbumMediaListState(medias: $medias, selectedMedias: $selectedMedias, album: $album, loading: $loading, loadingMore: $loadingMore, addingMedia: $addingMedia, removingMedia: $removingMedia, deleteAlbumSuccess: $deleteAlbumSuccess, error: $error, actionError: $actionError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlbumMediaListStateImpl &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            const DeepCollectionEquality()
                .equals(other._selectedMedias, _selectedMedias) &&
            (identical(other.album, album) || other.album == album) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.loadingMore, loadingMore) ||
                other.loadingMore == loadingMore) &&
            const DeepCollectionEquality()
                .equals(other._addingMedia, _addingMedia) &&
            const DeepCollectionEquality()
                .equals(other._removingMedia, _removingMedia) &&
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
      const DeepCollectionEquality().hash(_selectedMedias),
      album,
      loading,
      loadingMore,
      const DeepCollectionEquality().hash(_addingMedia),
      const DeepCollectionEquality().hash(_removingMedia),
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
      {final Map<String, AppMedia> medias,
      final List<String> selectedMedias,
      required final Album album,
      final bool loading,
      final bool loadingMore,
      final List<String> addingMedia,
      final List<String> removingMedia,
      final bool deleteAlbumSuccess,
      final Object? error,
      final Object? actionError}) = _$AlbumMediaListStateImpl;

  @override
  Map<String, AppMedia> get medias;
  @override
  List<String> get selectedMedias;
  @override
  Album get album;
  @override
  bool get loading;
  @override
  bool get loadingMore;
  @override
  List<String> get addingMedia;
  @override
  List<String> get removingMedia;
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
