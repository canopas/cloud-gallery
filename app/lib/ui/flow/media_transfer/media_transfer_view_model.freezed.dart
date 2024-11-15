// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_transfer_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MediaTransferState {
  Object? get error => throw _privateConstructorUsedError;
  List<AppProcess> get upload => throw _privateConstructorUsedError;
  List<AppProcess> get download => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;

  /// Create a copy of MediaTransferState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaTransferStateCopyWith<MediaTransferState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaTransferStateCopyWith<$Res> {
  factory $MediaTransferStateCopyWith(
          MediaTransferState value, $Res Function(MediaTransferState) then) =
      _$MediaTransferStateCopyWithImpl<$Res, MediaTransferState>;
  @useResult
  $Res call(
      {Object? error,
      List<AppProcess> upload,
      List<AppProcess> download,
      int page});
}

/// @nodoc
class _$MediaTransferStateCopyWithImpl<$Res, $Val extends MediaTransferState>
    implements $MediaTransferStateCopyWith<$Res> {
  _$MediaTransferStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaTransferState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? upload = null,
    Object? download = null,
    Object? page = null,
  }) {
    return _then(_value.copyWith(
      error: freezed == error ? _value.error : error,
      upload: null == upload
          ? _value.upload
          : upload // ignore: cast_nullable_to_non_nullable
              as List<AppProcess>,
      download: null == download
          ? _value.download
          : download // ignore: cast_nullable_to_non_nullable
              as List<AppProcess>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MediaTransferStateImplCopyWith<$Res>
    implements $MediaTransferStateCopyWith<$Res> {
  factory _$$MediaTransferStateImplCopyWith(_$MediaTransferStateImpl value,
          $Res Function(_$MediaTransferStateImpl) then) =
      __$$MediaTransferStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Object? error,
      List<AppProcess> upload,
      List<AppProcess> download,
      int page});
}

/// @nodoc
class __$$MediaTransferStateImplCopyWithImpl<$Res>
    extends _$MediaTransferStateCopyWithImpl<$Res, _$MediaTransferStateImpl>
    implements _$$MediaTransferStateImplCopyWith<$Res> {
  __$$MediaTransferStateImplCopyWithImpl(_$MediaTransferStateImpl _value,
      $Res Function(_$MediaTransferStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaTransferState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? upload = null,
    Object? download = null,
    Object? page = null,
  }) {
    return _then(_$MediaTransferStateImpl(
      error: freezed == error ? _value.error : error,
      upload: null == upload
          ? _value._upload
          : upload // ignore: cast_nullable_to_non_nullable
              as List<AppProcess>,
      download: null == download
          ? _value._download
          : download // ignore: cast_nullable_to_non_nullable
              as List<AppProcess>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$MediaTransferStateImpl implements _MediaTransferState {
  const _$MediaTransferStateImpl(
      {this.error,
      final List<AppProcess> upload = const [],
      final List<AppProcess> download = const [],
      this.page = 0})
      : _upload = upload,
        _download = download;

  @override
  final Object? error;
  final List<AppProcess> _upload;
  @override
  @JsonKey()
  List<AppProcess> get upload {
    if (_upload is EqualUnmodifiableListView) return _upload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_upload);
  }

  final List<AppProcess> _download;
  @override
  @JsonKey()
  List<AppProcess> get download {
    if (_download is EqualUnmodifiableListView) return _download;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_download);
  }

  @override
  @JsonKey()
  final int page;

  @override
  String toString() {
    return 'MediaTransferState(error: $error, upload: $upload, download: $download, page: $page)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaTransferStateImpl &&
            const DeepCollectionEquality().equals(other.error, error) &&
            const DeepCollectionEquality().equals(other._upload, _upload) &&
            const DeepCollectionEquality().equals(other._download, _download) &&
            (identical(other.page, page) || other.page == page));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(error),
      const DeepCollectionEquality().hash(_upload),
      const DeepCollectionEquality().hash(_download),
      page);

  /// Create a copy of MediaTransferState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaTransferStateImplCopyWith<_$MediaTransferStateImpl> get copyWith =>
      __$$MediaTransferStateImplCopyWithImpl<_$MediaTransferStateImpl>(
          this, _$identity);
}

abstract class _MediaTransferState implements MediaTransferState {
  const factory _MediaTransferState(
      {final Object? error,
      final List<AppProcess> upload,
      final List<AppProcess> download,
      final int page}) = _$MediaTransferStateImpl;

  @override
  Object? get error;
  @override
  List<AppProcess> get upload;
  @override
  List<AppProcess> get download;
  @override
  int get page;

  /// Create a copy of MediaTransferState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaTransferStateImplCopyWith<_$MediaTransferStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
