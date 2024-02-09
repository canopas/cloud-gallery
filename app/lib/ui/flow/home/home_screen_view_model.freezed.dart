// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_screen_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HomeViewState {
  bool get loading => throw _privateConstructorUsedError;
  List<AppMedia> get medias => throw _privateConstructorUsedError;
  List<AppMedia> get selectedMedias => throw _privateConstructorUsedError;
  int get mediaCount => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeViewStateCopyWith<HomeViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeViewStateCopyWith<$Res> {
  factory $HomeViewStateCopyWith(
          HomeViewState value, $Res Function(HomeViewState) then) =
      _$HomeViewStateCopyWithImpl<$Res, HomeViewState>;
  @useResult
  $Res call(
      {bool loading,
      List<AppMedia> medias,
      List<AppMedia> selectedMedias,
      int mediaCount,
      Object? error});
}

/// @nodoc
class _$HomeViewStateCopyWithImpl<$Res, $Val extends HomeViewState>
    implements $HomeViewStateCopyWith<$Res> {
  _$HomeViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? medias = null,
    Object? selectedMedias = null,
    Object? mediaCount = null,
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
      selectedMedias: null == selectedMedias
          ? _value.selectedMedias
          : selectedMedias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      mediaCount: null == mediaCount
          ? _value.mediaCount
          : mediaCount // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeViewStateImplCopyWith<$Res>
    implements $HomeViewStateCopyWith<$Res> {
  factory _$$HomeViewStateImplCopyWith(
          _$HomeViewStateImpl value, $Res Function(_$HomeViewStateImpl) then) =
      __$$HomeViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      List<AppMedia> medias,
      List<AppMedia> selectedMedias,
      int mediaCount,
      Object? error});
}

/// @nodoc
class __$$HomeViewStateImplCopyWithImpl<$Res>
    extends _$HomeViewStateCopyWithImpl<$Res, _$HomeViewStateImpl>
    implements _$$HomeViewStateImplCopyWith<$Res> {
  __$$HomeViewStateImplCopyWithImpl(
      _$HomeViewStateImpl _value, $Res Function(_$HomeViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? medias = null,
    Object? selectedMedias = null,
    Object? mediaCount = null,
    Object? error = freezed,
  }) {
    return _then(_$HomeViewStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
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
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$HomeViewStateImpl implements _HomeViewState {
  const _$HomeViewStateImpl(
      {this.loading = false,
      final List<AppMedia> medias = const [],
      final List<AppMedia> selectedMedias = const [],
      this.mediaCount = 0,
      this.error})
      : _medias = medias,
        _selectedMedias = selectedMedias;

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
  final Object? error;

  @override
  String toString() {
    return 'HomeViewState(loading: $loading, medias: $medias, selectedMedias: $selectedMedias, mediaCount: $mediaCount, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeViewStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            const DeepCollectionEquality()
                .equals(other._selectedMedias, _selectedMedias) &&
            (identical(other.mediaCount, mediaCount) ||
                other.mediaCount == mediaCount) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      const DeepCollectionEquality().hash(_medias),
      const DeepCollectionEquality().hash(_selectedMedias),
      mediaCount,
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeViewStateImplCopyWith<_$HomeViewStateImpl> get copyWith =>
      __$$HomeViewStateImplCopyWithImpl<_$HomeViewStateImpl>(this, _$identity);
}

abstract class _HomeViewState implements HomeViewState {
  const factory _HomeViewState(
      {final bool loading,
      final List<AppMedia> medias,
      final List<AppMedia> selectedMedias,
      final int mediaCount,
      final Object? error}) = _$HomeViewStateImpl;

  @override
  bool get loading;
  @override
  List<AppMedia> get medias;
  @override
  List<AppMedia> get selectedMedias;
  @override
  int get mediaCount;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$HomeViewStateImplCopyWith<_$HomeViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
