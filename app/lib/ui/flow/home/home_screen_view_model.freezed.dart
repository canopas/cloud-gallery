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
  Object? get error => throw _privateConstructorUsedError;
  bool get hasLocalMediaAccess => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  List<AppMedia> get medias => throw _privateConstructorUsedError;
  List<String> get selectedMedias => throw _privateConstructorUsedError;
  List<String> get uploadingMedias => throw _privateConstructorUsedError;

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
      {Object? error,
      bool hasLocalMediaAccess,
      bool loading,
      List<AppMedia> medias,
      List<String> selectedMedias,
      List<String> uploadingMedias});
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
    Object? error = freezed,
    Object? hasLocalMediaAccess = null,
    Object? loading = null,
    Object? medias = null,
    Object? selectedMedias = null,
    Object? uploadingMedias = null,
  }) {
    return _then(_value.copyWith(
      error: freezed == error ? _value.error : error,
      hasLocalMediaAccess: null == hasLocalMediaAccess
          ? _value.hasLocalMediaAccess
          : hasLocalMediaAccess // ignore: cast_nullable_to_non_nullable
              as bool,
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
              as List<String>,
      uploadingMedias: null == uploadingMedias
          ? _value.uploadingMedias
          : uploadingMedias // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
      {Object? error,
      bool hasLocalMediaAccess,
      bool loading,
      List<AppMedia> medias,
      List<String> selectedMedias,
      List<String> uploadingMedias});
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
    Object? error = freezed,
    Object? hasLocalMediaAccess = null,
    Object? loading = null,
    Object? medias = null,
    Object? selectedMedias = null,
    Object? uploadingMedias = null,
  }) {
    return _then(_$HomeViewStateImpl(
      error: freezed == error ? _value.error : error,
      hasLocalMediaAccess: null == hasLocalMediaAccess
          ? _value.hasLocalMediaAccess
          : hasLocalMediaAccess // ignore: cast_nullable_to_non_nullable
              as bool,
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
              as List<String>,
      uploadingMedias: null == uploadingMedias
          ? _value._uploadingMedias
          : uploadingMedias // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$HomeViewStateImpl implements _HomeViewState {
  const _$HomeViewStateImpl(
      {this.error,
      this.hasLocalMediaAccess = false,
      this.loading = false,
      final List<AppMedia> medias = const [],
      final List<String> selectedMedias = const [],
      final List<String> uploadingMedias = const []})
      : _medias = medias,
        _selectedMedias = selectedMedias,
        _uploadingMedias = uploadingMedias;

  @override
  final Object? error;
  @override
  @JsonKey()
  final bool hasLocalMediaAccess;
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

  final List<String> _selectedMedias;
  @override
  @JsonKey()
  List<String> get selectedMedias {
    if (_selectedMedias is EqualUnmodifiableListView) return _selectedMedias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedMedias);
  }

  final List<String> _uploadingMedias;
  @override
  @JsonKey()
  List<String> get uploadingMedias {
    if (_uploadingMedias is EqualUnmodifiableListView) return _uploadingMedias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_uploadingMedias);
  }

  @override
  String toString() {
    return 'HomeViewState(error: $error, hasLocalMediaAccess: $hasLocalMediaAccess, loading: $loading, medias: $medias, selectedMedias: $selectedMedias, uploadingMedias: $uploadingMedias)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeViewStateImpl &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.hasLocalMediaAccess, hasLocalMediaAccess) ||
                other.hasLocalMediaAccess == hasLocalMediaAccess) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            const DeepCollectionEquality()
                .equals(other._selectedMedias, _selectedMedias) &&
            const DeepCollectionEquality()
                .equals(other._uploadingMedias, _uploadingMedias));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(error),
      hasLocalMediaAccess,
      loading,
      const DeepCollectionEquality().hash(_medias),
      const DeepCollectionEquality().hash(_selectedMedias),
      const DeepCollectionEquality().hash(_uploadingMedias));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeViewStateImplCopyWith<_$HomeViewStateImpl> get copyWith =>
      __$$HomeViewStateImplCopyWithImpl<_$HomeViewStateImpl>(this, _$identity);
}

abstract class _HomeViewState implements HomeViewState {
  const factory _HomeViewState(
      {final Object? error,
      final bool hasLocalMediaAccess,
      final bool loading,
      final List<AppMedia> medias,
      final List<String> selectedMedias,
      final List<String> uploadingMedias}) = _$HomeViewStateImpl;

  @override
  Object? get error;
  @override
  bool get hasLocalMediaAccess;
  @override
  bool get loading;
  @override
  List<AppMedia> get medias;
  @override
  List<String> get selectedMedias;
  @override
  List<String> get uploadingMedias;
  @override
  @JsonKey(ignore: true)
  _$$HomeViewStateImplCopyWith<_$HomeViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
