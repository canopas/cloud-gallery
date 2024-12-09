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
  List<UploadMediaProcess> get uploadProcesses =>
      throw _privateConstructorUsedError;
  List<DownloadMediaProcess> get downloadProcesses =>
      throw _privateConstructorUsedError;
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
      List<UploadMediaProcess> uploadProcesses,
      List<DownloadMediaProcess> downloadProcesses,
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
    Object? uploadProcesses = null,
    Object? downloadProcesses = null,
    Object? page = null,
  }) {
    return _then(_value.copyWith(
      error: freezed == error ? _value.error : error,
      uploadProcesses: null == uploadProcesses
          ? _value.uploadProcesses
          : uploadProcesses // ignore: cast_nullable_to_non_nullable
              as List<UploadMediaProcess>,
      downloadProcesses: null == downloadProcesses
          ? _value.downloadProcesses
          : downloadProcesses // ignore: cast_nullable_to_non_nullable
              as List<DownloadMediaProcess>,
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
      List<UploadMediaProcess> uploadProcesses,
      List<DownloadMediaProcess> downloadProcesses,
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
    Object? uploadProcesses = null,
    Object? downloadProcesses = null,
    Object? page = null,
  }) {
    return _then(_$MediaTransferStateImpl(
      error: freezed == error ? _value.error : error,
      uploadProcesses: null == uploadProcesses
          ? _value._uploadProcesses
          : uploadProcesses // ignore: cast_nullable_to_non_nullable
              as List<UploadMediaProcess>,
      downloadProcesses: null == downloadProcesses
          ? _value._downloadProcesses
          : downloadProcesses // ignore: cast_nullable_to_non_nullable
              as List<DownloadMediaProcess>,
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
      final List<UploadMediaProcess> uploadProcesses = const [],
      final List<DownloadMediaProcess> downloadProcesses = const [],
      this.page = 0})
      : _uploadProcesses = uploadProcesses,
        _downloadProcesses = downloadProcesses;

  @override
  final Object? error;
  final List<UploadMediaProcess> _uploadProcesses;
  @override
  @JsonKey()
  List<UploadMediaProcess> get uploadProcesses {
    if (_uploadProcesses is EqualUnmodifiableListView) return _uploadProcesses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_uploadProcesses);
  }

  final List<DownloadMediaProcess> _downloadProcesses;
  @override
  @JsonKey()
  List<DownloadMediaProcess> get downloadProcesses {
    if (_downloadProcesses is EqualUnmodifiableListView)
      return _downloadProcesses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_downloadProcesses);
  }

  @override
  @JsonKey()
  final int page;

  @override
  String toString() {
    return 'MediaTransferState(error: $error, uploadProcesses: $uploadProcesses, downloadProcesses: $downloadProcesses, page: $page)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaTransferStateImpl &&
            const DeepCollectionEquality().equals(other.error, error) &&
            const DeepCollectionEquality()
                .equals(other._uploadProcesses, _uploadProcesses) &&
            const DeepCollectionEquality()
                .equals(other._downloadProcesses, _downloadProcesses) &&
            (identical(other.page, page) || other.page == page));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(error),
      const DeepCollectionEquality().hash(_uploadProcesses),
      const DeepCollectionEquality().hash(_downloadProcesses),
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
      final List<UploadMediaProcess> uploadProcesses,
      final List<DownloadMediaProcess> downloadProcesses,
      final int page}) = _$MediaTransferStateImpl;

  @override
  Object? get error;
  @override
  List<UploadMediaProcess> get uploadProcesses;
  @override
  List<DownloadMediaProcess> get downloadProcesses;
  @override
  int get page;

  /// Create a copy of MediaTransferState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaTransferStateImplCopyWith<_$MediaTransferStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
