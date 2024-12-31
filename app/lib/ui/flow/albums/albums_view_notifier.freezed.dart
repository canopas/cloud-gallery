// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'albums_view_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AlbumsState {
  bool get loading => throw _privateConstructorUsedError;
  List<AppMedia> get medias => throw _privateConstructorUsedError;
  List<Album> get albums => throw _privateConstructorUsedError;
  GoogleSignInAccount? get googleAccount => throw _privateConstructorUsedError;
  DropboxAccount? get dropboxAccount => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  /// Create a copy of AlbumsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlbumsStateCopyWith<AlbumsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlbumsStateCopyWith<$Res> {
  factory $AlbumsStateCopyWith(
          AlbumsState value, $Res Function(AlbumsState) then) =
      _$AlbumsStateCopyWithImpl<$Res, AlbumsState>;
  @useResult
  $Res call(
      {bool loading,
      List<AppMedia> medias,
      List<Album> albums,
      GoogleSignInAccount? googleAccount,
      DropboxAccount? dropboxAccount,
      Object? error});

  $DropboxAccountCopyWith<$Res>? get dropboxAccount;
}

/// @nodoc
class _$AlbumsStateCopyWithImpl<$Res, $Val extends AlbumsState>
    implements $AlbumsStateCopyWith<$Res> {
  _$AlbumsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlbumsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? medias = null,
    Object? albums = null,
    Object? googleAccount = freezed,
    Object? dropboxAccount = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      medias: null == medias
          ? _value.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      albums: null == albums
          ? _value.albums
          : albums // ignore: cast_nullable_to_non_nullable
              as List<Album>,
      googleAccount: freezed == googleAccount
          ? _value.googleAccount
          : googleAccount // ignore: cast_nullable_to_non_nullable
              as GoogleSignInAccount?,
      dropboxAccount: freezed == dropboxAccount
          ? _value.dropboxAccount
          : dropboxAccount // ignore: cast_nullable_to_non_nullable
              as DropboxAccount?,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }

  /// Create a copy of AlbumsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DropboxAccountCopyWith<$Res>? get dropboxAccount {
    if (_value.dropboxAccount == null) {
      return null;
    }

    return $DropboxAccountCopyWith<$Res>(_value.dropboxAccount!, (value) {
      return _then(_value.copyWith(dropboxAccount: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AlbumsStateImplCopyWith<$Res>
    implements $AlbumsStateCopyWith<$Res> {
  factory _$$AlbumsStateImplCopyWith(
          _$AlbumsStateImpl value, $Res Function(_$AlbumsStateImpl) then) =
      __$$AlbumsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      List<AppMedia> medias,
      List<Album> albums,
      GoogleSignInAccount? googleAccount,
      DropboxAccount? dropboxAccount,
      Object? error});

  @override
  $DropboxAccountCopyWith<$Res>? get dropboxAccount;
}

/// @nodoc
class __$$AlbumsStateImplCopyWithImpl<$Res>
    extends _$AlbumsStateCopyWithImpl<$Res, _$AlbumsStateImpl>
    implements _$$AlbumsStateImplCopyWith<$Res> {
  __$$AlbumsStateImplCopyWithImpl(
      _$AlbumsStateImpl _value, $Res Function(_$AlbumsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlbumsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? medias = null,
    Object? albums = null,
    Object? googleAccount = freezed,
    Object? dropboxAccount = freezed,
    Object? error = freezed,
  }) {
    return _then(_$AlbumsStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      medias: null == medias
          ? _value._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      albums: null == albums
          ? _value._albums
          : albums // ignore: cast_nullable_to_non_nullable
              as List<Album>,
      googleAccount: freezed == googleAccount
          ? _value.googleAccount
          : googleAccount // ignore: cast_nullable_to_non_nullable
              as GoogleSignInAccount?,
      dropboxAccount: freezed == dropboxAccount
          ? _value.dropboxAccount
          : dropboxAccount // ignore: cast_nullable_to_non_nullable
              as DropboxAccount?,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$AlbumsStateImpl implements _AlbumsState {
  const _$AlbumsStateImpl(
      {this.loading = false,
      final List<AppMedia> medias = const [],
      final List<Album> albums = const [],
      this.googleAccount,
      this.dropboxAccount,
      this.error})
      : _medias = medias,
        _albums = albums;

  @override
  @JsonKey()
  final bool loading;
  final List<AppMedia> _medias;
  @override
  @JsonKey()
  List<AppMedia> get medias {
    if (_medias is EqualUnmodifiableListView) return _medias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medias);
  }

  final List<Album> _albums;
  @override
  @JsonKey()
  List<Album> get albums {
    if (_albums is EqualUnmodifiableListView) return _albums;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_albums);
  }

  @override
  final GoogleSignInAccount? googleAccount;
  @override
  final DropboxAccount? dropboxAccount;
  @override
  final Object? error;

  @override
  String toString() {
    return 'AlbumsState(loading: $loading, medias: $medias, albums: $albums, googleAccount: $googleAccount, dropboxAccount: $dropboxAccount, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlbumsStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            const DeepCollectionEquality().equals(other._albums, _albums) &&
            (identical(other.googleAccount, googleAccount) ||
                other.googleAccount == googleAccount) &&
            (identical(other.dropboxAccount, dropboxAccount) ||
                other.dropboxAccount == dropboxAccount) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      const DeepCollectionEquality().hash(_medias),
      const DeepCollectionEquality().hash(_albums),
      googleAccount,
      dropboxAccount,
      const DeepCollectionEquality().hash(error));

  /// Create a copy of AlbumsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlbumsStateImplCopyWith<_$AlbumsStateImpl> get copyWith =>
      __$$AlbumsStateImplCopyWithImpl<_$AlbumsStateImpl>(this, _$identity);
}

abstract class _AlbumsState implements AlbumsState {
  const factory _AlbumsState(
      {final bool loading,
      final List<AppMedia> medias,
      final List<Album> albums,
      final GoogleSignInAccount? googleAccount,
      final DropboxAccount? dropboxAccount,
      final Object? error}) = _$AlbumsStateImpl;

  @override
  bool get loading;
  @override
  List<AppMedia> get medias;
  @override
  List<Album> get albums;
  @override
  GoogleSignInAccount? get googleAccount;
  @override
  DropboxAccount? get dropboxAccount;
  @override
  Object? get error;

  /// Create a copy of AlbumsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlbumsStateImplCopyWith<_$AlbumsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
