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
  SourcePage get sourcePage => throw _privateConstructorUsedError;
  bool get isLastViewChangedByScroll => throw _privateConstructorUsedError;

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
  $Res call({SourcePage sourcePage, bool isLastViewChangedByScroll});
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
    Object? sourcePage = null,
    Object? isLastViewChangedByScroll = null,
  }) {
    return _then(_value.copyWith(
      sourcePage: null == sourcePage
          ? _value.sourcePage
          : sourcePage // ignore: cast_nullable_to_non_nullable
              as SourcePage,
      isLastViewChangedByScroll: null == isLastViewChangedByScroll
          ? _value.isLastViewChangedByScroll
          : isLastViewChangedByScroll // ignore: cast_nullable_to_non_nullable
              as bool,
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
  $Res call({SourcePage sourcePage, bool isLastViewChangedByScroll});
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
    Object? sourcePage = null,
    Object? isLastViewChangedByScroll = null,
  }) {
    return _then(_$HomeViewStateImpl(
      sourcePage: null == sourcePage
          ? _value.sourcePage
          : sourcePage // ignore: cast_nullable_to_non_nullable
              as SourcePage,
      isLastViewChangedByScroll: null == isLastViewChangedByScroll
          ? _value.isLastViewChangedByScroll
          : isLastViewChangedByScroll // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$HomeViewStateImpl implements _HomeViewState {
  const _$HomeViewStateImpl(
      {this.sourcePage = const SourcePage(),
      this.isLastViewChangedByScroll = false});

  @override
  @JsonKey()
  final SourcePage sourcePage;
  @override
  @JsonKey()
  final bool isLastViewChangedByScroll;

  @override
  String toString() {
    return 'HomeViewState(sourcePage: $sourcePage, isLastViewChangedByScroll: $isLastViewChangedByScroll)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeViewStateImpl &&
            (identical(other.sourcePage, sourcePage) ||
                other.sourcePage == sourcePage) &&
            (identical(other.isLastViewChangedByScroll,
                    isLastViewChangedByScroll) ||
                other.isLastViewChangedByScroll == isLastViewChangedByScroll));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, sourcePage, isLastViewChangedByScroll);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeViewStateImplCopyWith<_$HomeViewStateImpl> get copyWith =>
      __$$HomeViewStateImplCopyWithImpl<_$HomeViewStateImpl>(this, _$identity);
}

abstract class _HomeViewState implements HomeViewState {
  const factory _HomeViewState(
      {final SourcePage sourcePage,
      final bool isLastViewChangedByScroll}) = _$HomeViewStateImpl;

  @override
  SourcePage get sourcePage;
  @override
  bool get isLastViewChangedByScroll;
  @override
  @JsonKey(ignore: true)
  _$$HomeViewStateImplCopyWith<_$HomeViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
