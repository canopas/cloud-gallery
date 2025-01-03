// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_selection_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MediaSelectionState {
  Map<DateTime, List<AppMedia>> get medias =>
      throw _privateConstructorUsedError;
  List<String> get selectedMedias => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  bool get noAccess => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;
  Object? get actionError => throw _privateConstructorUsedError;

  /// Create a copy of MediaSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaSelectionStateCopyWith<MediaSelectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaSelectionStateCopyWith<$Res> {
  factory $MediaSelectionStateCopyWith(
          MediaSelectionState value, $Res Function(MediaSelectionState) then) =
      _$MediaSelectionStateCopyWithImpl<$Res, MediaSelectionState>;
  @useResult
  $Res call(
      {Map<DateTime, List<AppMedia>> medias,
      List<String> selectedMedias,
      bool loading,
      bool noAccess,
      Object? error,
      Object? actionError});
}

/// @nodoc
class _$MediaSelectionStateCopyWithImpl<$Res, $Val extends MediaSelectionState>
    implements $MediaSelectionStateCopyWith<$Res> {
  _$MediaSelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medias = null,
    Object? selectedMedias = null,
    Object? loading = null,
    Object? noAccess = null,
    Object? error = freezed,
    Object? actionError = freezed,
  }) {
    return _then(_value.copyWith(
      medias: null == medias
          ? _value.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, List<AppMedia>>,
      selectedMedias: null == selectedMedias
          ? _value.selectedMedias
          : selectedMedias // ignore: cast_nullable_to_non_nullable
              as List<String>,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      noAccess: null == noAccess
          ? _value.noAccess
          : noAccess // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
      actionError: freezed == actionError ? _value.actionError : actionError,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MediaSelectionStateImplCopyWith<$Res>
    implements $MediaSelectionStateCopyWith<$Res> {
  factory _$$MediaSelectionStateImplCopyWith(_$MediaSelectionStateImpl value,
          $Res Function(_$MediaSelectionStateImpl) then) =
      __$$MediaSelectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<DateTime, List<AppMedia>> medias,
      List<String> selectedMedias,
      bool loading,
      bool noAccess,
      Object? error,
      Object? actionError});
}

/// @nodoc
class __$$MediaSelectionStateImplCopyWithImpl<$Res>
    extends _$MediaSelectionStateCopyWithImpl<$Res, _$MediaSelectionStateImpl>
    implements _$$MediaSelectionStateImplCopyWith<$Res> {
  __$$MediaSelectionStateImplCopyWithImpl(_$MediaSelectionStateImpl _value,
      $Res Function(_$MediaSelectionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medias = null,
    Object? selectedMedias = null,
    Object? loading = null,
    Object? noAccess = null,
    Object? error = freezed,
    Object? actionError = freezed,
  }) {
    return _then(_$MediaSelectionStateImpl(
      medias: null == medias
          ? _value._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, List<AppMedia>>,
      selectedMedias: null == selectedMedias
          ? _value._selectedMedias
          : selectedMedias // ignore: cast_nullable_to_non_nullable
              as List<String>,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      noAccess: null == noAccess
          ? _value.noAccess
          : noAccess // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
      actionError: freezed == actionError ? _value.actionError : actionError,
    ));
  }
}

/// @nodoc

class _$MediaSelectionStateImpl implements _MediaSelectionState {
  const _$MediaSelectionStateImpl(
      {final Map<DateTime, List<AppMedia>> medias = const {},
      final List<String> selectedMedias = const [],
      this.loading = false,
      this.noAccess = false,
      this.error,
      this.actionError})
      : _medias = medias,
        _selectedMedias = selectedMedias;

  final Map<DateTime, List<AppMedia>> _medias;
  @override
  @JsonKey()
  Map<DateTime, List<AppMedia>> get medias {
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
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool noAccess;
  @override
  final Object? error;
  @override
  final Object? actionError;

  @override
  String toString() {
    return 'MediaSelectionState(medias: $medias, selectedMedias: $selectedMedias, loading: $loading, noAccess: $noAccess, error: $error, actionError: $actionError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaSelectionStateImpl &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            const DeepCollectionEquality()
                .equals(other._selectedMedias, _selectedMedias) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.noAccess, noAccess) ||
                other.noAccess == noAccess) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            const DeepCollectionEquality()
                .equals(other.actionError, actionError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_medias),
      const DeepCollectionEquality().hash(_selectedMedias),
      loading,
      noAccess,
      const DeepCollectionEquality().hash(error),
      const DeepCollectionEquality().hash(actionError));

  /// Create a copy of MediaSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaSelectionStateImplCopyWith<_$MediaSelectionStateImpl> get copyWith =>
      __$$MediaSelectionStateImplCopyWithImpl<_$MediaSelectionStateImpl>(
          this, _$identity);
}

abstract class _MediaSelectionState implements MediaSelectionState {
  const factory _MediaSelectionState(
      {final Map<DateTime, List<AppMedia>> medias,
      final List<String> selectedMedias,
      final bool loading,
      final bool noAccess,
      final Object? error,
      final Object? actionError}) = _$MediaSelectionStateImpl;

  @override
  Map<DateTime, List<AppMedia>> get medias;
  @override
  List<String> get selectedMedias;
  @override
  bool get loading;
  @override
  bool get noAccess;
  @override
  Object? get error;
  @override
  Object? get actionError;

  /// Create a copy of MediaSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaSelectionStateImplCopyWith<_$MediaSelectionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
