// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_media_screen_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LocalMediasViewState {
  bool get loading => throw _privateConstructorUsedError;
  List<AppMedia> get uploadingMedias => throw _privateConstructorUsedError;
  List<AppMedia> get medias => throw _privateConstructorUsedError;
  List<AppMedia> get selectedMedias => throw _privateConstructorUsedError;
  int get mediaCount => throw _privateConstructorUsedError;
  dynamic get hasLocalMediaAccess => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LocalMediasViewStateCopyWith<LocalMediasViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalMediasViewStateCopyWith<$Res> {
  factory $LocalMediasViewStateCopyWith(LocalMediasViewState value,
          $Res Function(LocalMediasViewState) then) =
      _$LocalMediasViewStateCopyWithImpl<$Res, LocalMediasViewState>;
  @useResult
  $Res call(
      {bool loading,
      List<AppMedia> uploadingMedias,
      List<AppMedia> medias,
      List<AppMedia> selectedMedias,
      int mediaCount,
      dynamic hasLocalMediaAccess,
      Object? error});
}

/// @nodoc
class _$LocalMediasViewStateCopyWithImpl<$Res,
        $Val extends LocalMediasViewState>
    implements $LocalMediasViewStateCopyWith<$Res> {
  _$LocalMediasViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? uploadingMedias = null,
    Object? medias = null,
    Object? selectedMedias = null,
    Object? mediaCount = null,
    Object? hasLocalMediaAccess = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      uploadingMedias: null == uploadingMedias
          ? _value.uploadingMedias
          : uploadingMedias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      medias: null == medias
          ? _value.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      selectedMedias: null == selectedMedias
          ? _value.selectedMedias
          : selectedMedias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      mediaCount: null == mediaCount
          ? _value.mediaCount
          : mediaCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasLocalMediaAccess: freezed == hasLocalMediaAccess
          ? _value.hasLocalMediaAccess
          : hasLocalMediaAccess // ignore: cast_nullable_to_non_nullable
              as dynamic,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalMediasViewStateImplCopyWith<$Res>
    implements $LocalMediasViewStateCopyWith<$Res> {
  factory _$$LocalMediasViewStateImplCopyWith(_$LocalMediasViewStateImpl value,
          $Res Function(_$LocalMediasViewStateImpl) then) =
      __$$LocalMediasViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      List<AppMedia> uploadingMedias,
      List<AppMedia> medias,
      List<AppMedia> selectedMedias,
      int mediaCount,
      dynamic hasLocalMediaAccess,
      Object? error});
}

/// @nodoc
class __$$LocalMediasViewStateImplCopyWithImpl<$Res>
    extends _$LocalMediasViewStateCopyWithImpl<$Res, _$LocalMediasViewStateImpl>
    implements _$$LocalMediasViewStateImplCopyWith<$Res> {
  __$$LocalMediasViewStateImplCopyWithImpl(_$LocalMediasViewStateImpl _value,
      $Res Function(_$LocalMediasViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? uploadingMedias = null,
    Object? medias = null,
    Object? selectedMedias = null,
    Object? mediaCount = null,
    Object? hasLocalMediaAccess = freezed,
    Object? error = freezed,
  }) {
    return _then(_$LocalMediasViewStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      uploadingMedias: null == uploadingMedias
          ? _value._uploadingMedias
          : uploadingMedias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      medias: null == medias
          ? _value._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      selectedMedias: null == selectedMedias
          ? _value._selectedMedias
          : selectedMedias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      mediaCount: null == mediaCount
          ? _value.mediaCount
          : mediaCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasLocalMediaAccess: freezed == hasLocalMediaAccess
          ? _value.hasLocalMediaAccess!
          : hasLocalMediaAccess,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$LocalMediasViewStateImpl implements _LocalMediasViewState {
  const _$LocalMediasViewStateImpl(
      {this.loading = false,
      final List<AppMedia> uploadingMedias = const [],
      final List<AppMedia> medias = const [],
      final List<AppMedia> selectedMedias = const [],
      this.mediaCount = 0,
      this.hasLocalMediaAccess = false,
      this.error})
      : _uploadingMedias = uploadingMedias,
        _medias = medias,
        _selectedMedias = selectedMedias;

  @override
  @JsonKey()
  final bool loading;
  final List<AppMedia> _uploadingMedias;
  @override
  @JsonKey()
  List<AppMedia> get uploadingMedias {
    if (_uploadingMedias is EqualUnmodifiableListView) return _uploadingMedias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_uploadingMedias);
  }

  final List<AppMedia> _medias;
  @override
  @JsonKey()
  List<AppMedia> get medias {
    if (_medias is EqualUnmodifiableListView) return _medias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medias);
  }

  final List<AppMedia> _selectedMedias;
  @override
  @JsonKey()
  List<AppMedia> get selectedMedias {
    if (_selectedMedias is EqualUnmodifiableListView) return _selectedMedias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedMedias);
  }

  @override
  @JsonKey()
  final int mediaCount;
  @override
  @JsonKey()
  final dynamic hasLocalMediaAccess;
  @override
  final Object? error;

  @override
  String toString() {
    return 'LocalMediasViewState(loading: $loading, uploadingMedias: $uploadingMedias, medias: $medias, selectedMedias: $selectedMedias, mediaCount: $mediaCount, hasLocalMediaAccess: $hasLocalMediaAccess, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalMediasViewStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality()
                .equals(other._uploadingMedias, _uploadingMedias) &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            const DeepCollectionEquality()
                .equals(other._selectedMedias, _selectedMedias) &&
            (identical(other.mediaCount, mediaCount) ||
                other.mediaCount == mediaCount) &&
            const DeepCollectionEquality()
                .equals(other.hasLocalMediaAccess, hasLocalMediaAccess) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      const DeepCollectionEquality().hash(_uploadingMedias),
      const DeepCollectionEquality().hash(_medias),
      const DeepCollectionEquality().hash(_selectedMedias),
      mediaCount,
      const DeepCollectionEquality().hash(hasLocalMediaAccess),
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalMediasViewStateImplCopyWith<_$LocalMediasViewStateImpl>
      get copyWith =>
          __$$LocalMediasViewStateImplCopyWithImpl<_$LocalMediasViewStateImpl>(
              this, _$identity);
}

abstract class _LocalMediasViewState implements LocalMediasViewState {
  const factory _LocalMediasViewState(
      {final bool loading,
      final List<AppMedia> uploadingMedias,
      final List<AppMedia> medias,
      final List<AppMedia> selectedMedias,
      final int mediaCount,
      final dynamic hasLocalMediaAccess,
      final Object? error}) = _$LocalMediasViewStateImpl;

  @override
  bool get loading;
  @override
  List<AppMedia> get uploadingMedias;
  @override
  List<AppMedia> get medias;
  @override
  List<AppMedia> get selectedMedias;
  @override
  int get mediaCount;
  @override
  dynamic get hasLocalMediaAccess;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$LocalMediasViewStateImplCopyWith<_$LocalMediasViewStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
