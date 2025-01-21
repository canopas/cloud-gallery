// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clean_up_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CleanUpState {
  bool get deleteAllLoading => throw _privateConstructorUsedError;
  List<String> get deleteSelectedLoading => throw _privateConstructorUsedError;
  List<AppMedia> get medias => throw _privateConstructorUsedError;
  List<String> get selected => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;
  Object? get actionError => throw _privateConstructorUsedError;

  /// Create a copy of CleanUpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CleanUpStateCopyWith<CleanUpState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CleanUpStateCopyWith<$Res> {
  factory $CleanUpStateCopyWith(
          CleanUpState value, $Res Function(CleanUpState) then) =
      _$CleanUpStateCopyWithImpl<$Res, CleanUpState>;
  @useResult
  $Res call(
      {bool deleteAllLoading,
      List<String> deleteSelectedLoading,
      List<AppMedia> medias,
      List<String> selected,
      bool loading,
      Object? error,
      Object? actionError});
}

/// @nodoc
class _$CleanUpStateCopyWithImpl<$Res, $Val extends CleanUpState>
    implements $CleanUpStateCopyWith<$Res> {
  _$CleanUpStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CleanUpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deleteAllLoading = null,
    Object? deleteSelectedLoading = null,
    Object? medias = null,
    Object? selected = null,
    Object? loading = null,
    Object? error = freezed,
    Object? actionError = freezed,
  }) {
    return _then(_value.copyWith(
      deleteAllLoading: null == deleteAllLoading
          ? _value.deleteAllLoading
          : deleteAllLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      deleteSelectedLoading: null == deleteSelectedLoading
          ? _value.deleteSelectedLoading
          : deleteSelectedLoading // ignore: cast_nullable_to_non_nullable
              as List<String>,
      medias: null == medias
          ? _value.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as List<String>,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
      actionError: freezed == actionError ? _value.actionError : actionError,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CleanUpStateImplCopyWith<$Res>
    implements $CleanUpStateCopyWith<$Res> {
  factory _$$CleanUpStateImplCopyWith(
          _$CleanUpStateImpl value, $Res Function(_$CleanUpStateImpl) then) =
      __$$CleanUpStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool deleteAllLoading,
      List<String> deleteSelectedLoading,
      List<AppMedia> medias,
      List<String> selected,
      bool loading,
      Object? error,
      Object? actionError});
}

/// @nodoc
class __$$CleanUpStateImplCopyWithImpl<$Res>
    extends _$CleanUpStateCopyWithImpl<$Res, _$CleanUpStateImpl>
    implements _$$CleanUpStateImplCopyWith<$Res> {
  __$$CleanUpStateImplCopyWithImpl(
      _$CleanUpStateImpl _value, $Res Function(_$CleanUpStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CleanUpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deleteAllLoading = null,
    Object? deleteSelectedLoading = null,
    Object? medias = null,
    Object? selected = null,
    Object? loading = null,
    Object? error = freezed,
    Object? actionError = freezed,
  }) {
    return _then(_$CleanUpStateImpl(
      deleteAllLoading: null == deleteAllLoading
          ? _value.deleteAllLoading
          : deleteAllLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      deleteSelectedLoading: null == deleteSelectedLoading
          ? _value._deleteSelectedLoading
          : deleteSelectedLoading // ignore: cast_nullable_to_non_nullable
              as List<String>,
      medias: null == medias
          ? _value._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      selected: null == selected
          ? _value._selected
          : selected // ignore: cast_nullable_to_non_nullable
              as List<String>,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
      actionError: freezed == actionError ? _value.actionError : actionError,
    ));
  }
}

/// @nodoc

class _$CleanUpStateImpl implements _CleanUpState {
  const _$CleanUpStateImpl(
      {this.deleteAllLoading = false,
      final List<String> deleteSelectedLoading = const [],
      final List<AppMedia> medias = const [],
      final List<String> selected = const [],
      this.loading = false,
      this.error,
      this.actionError})
      : _deleteSelectedLoading = deleteSelectedLoading,
        _medias = medias,
        _selected = selected;

  @override
  @JsonKey()
  final bool deleteAllLoading;
  final List<String> _deleteSelectedLoading;
  @override
  @JsonKey()
  List<String> get deleteSelectedLoading {
    if (_deleteSelectedLoading is EqualUnmodifiableListView)
      return _deleteSelectedLoading;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deleteSelectedLoading);
  }

  final List<AppMedia> _medias;
  @override
  @JsonKey()
  List<AppMedia> get medias {
    if (_medias is EqualUnmodifiableListView) return _medias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medias);
  }

  final List<String> _selected;
  @override
  @JsonKey()
  List<String> get selected {
    if (_selected is EqualUnmodifiableListView) return _selected;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selected);
  }

  @override
  @JsonKey()
  final bool loading;
  @override
  final Object? error;
  @override
  final Object? actionError;

  @override
  String toString() {
    return 'CleanUpState(deleteAllLoading: $deleteAllLoading, deleteSelectedLoading: $deleteSelectedLoading, medias: $medias, selected: $selected, loading: $loading, error: $error, actionError: $actionError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CleanUpStateImpl &&
            (identical(other.deleteAllLoading, deleteAllLoading) ||
                other.deleteAllLoading == deleteAllLoading) &&
            const DeepCollectionEquality()
                .equals(other._deleteSelectedLoading, _deleteSelectedLoading) &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            const DeepCollectionEquality().equals(other._selected, _selected) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            const DeepCollectionEquality()
                .equals(other.actionError, actionError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      deleteAllLoading,
      const DeepCollectionEquality().hash(_deleteSelectedLoading),
      const DeepCollectionEquality().hash(_medias),
      const DeepCollectionEquality().hash(_selected),
      loading,
      const DeepCollectionEquality().hash(error),
      const DeepCollectionEquality().hash(actionError));

  /// Create a copy of CleanUpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CleanUpStateImplCopyWith<_$CleanUpStateImpl> get copyWith =>
      __$$CleanUpStateImplCopyWithImpl<_$CleanUpStateImpl>(this, _$identity);
}

abstract class _CleanUpState implements CleanUpState {
  const factory _CleanUpState(
      {final bool deleteAllLoading,
      final List<String> deleteSelectedLoading,
      final List<AppMedia> medias,
      final List<String> selected,
      final bool loading,
      final Object? error,
      final Object? actionError}) = _$CleanUpStateImpl;

  @override
  bool get deleteAllLoading;
  @override
  List<String> get deleteSelectedLoading;
  @override
  List<AppMedia> get medias;
  @override
  List<String> get selected;
  @override
  bool get loading;
  @override
  Object? get error;
  @override
  Object? get actionError;

  /// Create a copy of CleanUpState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CleanUpStateImplCopyWith<_$CleanUpStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
