// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'google_drive_medias_screen_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GoogleDriveMediasViewState {
  bool get loading => throw _privateConstructorUsedError;
  List<AppMedia> get medias => throw _privateConstructorUsedError;
  bool get isSignedIn => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GoogleDriveMediasViewStateCopyWith<GoogleDriveMediasViewState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoogleDriveMediasViewStateCopyWith<$Res> {
  factory $GoogleDriveMediasViewStateCopyWith(GoogleDriveMediasViewState value,
          $Res Function(GoogleDriveMediasViewState) then) =
      _$GoogleDriveMediasViewStateCopyWithImpl<$Res,
          GoogleDriveMediasViewState>;
  @useResult
  $Res call(
      {bool loading, List<AppMedia> medias, bool isSignedIn, Object? error});
}

/// @nodoc
class _$GoogleDriveMediasViewStateCopyWithImpl<$Res,
        $Val extends GoogleDriveMediasViewState>
    implements $GoogleDriveMediasViewStateCopyWith<$Res> {
  _$GoogleDriveMediasViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? medias = null,
    Object? isSignedIn = null,
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
      isSignedIn: null == isSignedIn
          ? _value.isSignedIn
          : isSignedIn // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoogleDriveMediasViewStateImplCopyWith<$Res>
    implements $GoogleDriveMediasViewStateCopyWith<$Res> {
  factory _$$GoogleDriveMediasViewStateImplCopyWith(
          _$GoogleDriveMediasViewStateImpl value,
          $Res Function(_$GoogleDriveMediasViewStateImpl) then) =
      __$$GoogleDriveMediasViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading, List<AppMedia> medias, bool isSignedIn, Object? error});
}

/// @nodoc
class __$$GoogleDriveMediasViewStateImplCopyWithImpl<$Res>
    extends _$GoogleDriveMediasViewStateCopyWithImpl<$Res,
        _$GoogleDriveMediasViewStateImpl>
    implements _$$GoogleDriveMediasViewStateImplCopyWith<$Res> {
  __$$GoogleDriveMediasViewStateImplCopyWithImpl(
      _$GoogleDriveMediasViewStateImpl _value,
      $Res Function(_$GoogleDriveMediasViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? medias = null,
    Object? isSignedIn = null,
    Object? error = freezed,
  }) {
    return _then(_$GoogleDriveMediasViewStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      medias: null == medias
          ? _value._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      isSignedIn: null == isSignedIn
          ? _value.isSignedIn
          : isSignedIn // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$GoogleDriveMediasViewStateImpl implements _GoogleDriveMediasViewState {
  const _$GoogleDriveMediasViewStateImpl(
      {this.loading = false,
      final List<AppMedia> medias = const [],
      required this.isSignedIn,
      this.error})
      : _medias = medias;

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

  @override
  final bool isSignedIn;
  @override
  final Object? error;

  @override
  String toString() {
    return 'GoogleDriveMediasViewState(loading: $loading, medias: $medias, isSignedIn: $isSignedIn, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleDriveMediasViewStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            (identical(other.isSignedIn, isSignedIn) ||
                other.isSignedIn == isSignedIn) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      const DeepCollectionEquality().hash(_medias),
      isSignedIn,
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoogleDriveMediasViewStateImplCopyWith<_$GoogleDriveMediasViewStateImpl>
      get copyWith => __$$GoogleDriveMediasViewStateImplCopyWithImpl<
          _$GoogleDriveMediasViewStateImpl>(this, _$identity);
}

abstract class _GoogleDriveMediasViewState
    implements GoogleDriveMediasViewState {
  const factory _GoogleDriveMediasViewState(
      {final bool loading,
      final List<AppMedia> medias,
      required final bool isSignedIn,
      final Object? error}) = _$GoogleDriveMediasViewStateImpl;

  @override
  bool get loading;
  @override
  List<AppMedia> get medias;
  @override
  bool get isSignedIn;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$GoogleDriveMediasViewStateImplCopyWith<_$GoogleDriveMediasViewStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
