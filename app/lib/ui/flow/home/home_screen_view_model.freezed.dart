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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeViewState {
  Object? get error => throw _privateConstructorUsedError;
  Object? get actionError => throw _privateConstructorUsedError;
  bool get hasLocalMediaAccess => throw _privateConstructorUsedError;
  bool get hasInternet => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  bool get cloudLoading => throw _privateConstructorUsedError;
  GoogleSignInAccount? get googleAccount => throw _privateConstructorUsedError;
  DropboxAccount? get dropboxAccount => throw _privateConstructorUsedError;
  Map<DateTime, Map<String, AppMedia>> get medias =>
      throw _privateConstructorUsedError;
  Map<String, AppMedia> get selectedMedias =>
      throw _privateConstructorUsedError;
  Map<String, UploadMediaProcess> get uploadMediaProcesses =>
      throw _privateConstructorUsedError;
  Map<String, DownloadMediaProcess> get downloadMediaProcesses =>
      throw _privateConstructorUsedError;
  String? get lastLocalMediaId => throw _privateConstructorUsedError;

  /// Create a copy of HomeViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      Object? actionError,
      bool hasLocalMediaAccess,
      bool hasInternet,
      bool loading,
      bool cloudLoading,
      GoogleSignInAccount? googleAccount,
      DropboxAccount? dropboxAccount,
      Map<DateTime, Map<String, AppMedia>> medias,
      Map<String, AppMedia> selectedMedias,
      Map<String, UploadMediaProcess> uploadMediaProcesses,
      Map<String, DownloadMediaProcess> downloadMediaProcesses,
      String? lastLocalMediaId});

  $DropboxAccountCopyWith<$Res>? get dropboxAccount;
}

/// @nodoc
class _$HomeViewStateCopyWithImpl<$Res, $Val extends HomeViewState>
    implements $HomeViewStateCopyWith<$Res> {
  _$HomeViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? actionError = freezed,
    Object? hasLocalMediaAccess = null,
    Object? hasInternet = null,
    Object? loading = null,
    Object? cloudLoading = null,
    Object? googleAccount = freezed,
    Object? dropboxAccount = freezed,
    Object? medias = null,
    Object? selectedMedias = null,
    Object? uploadMediaProcesses = null,
    Object? downloadMediaProcesses = null,
    Object? lastLocalMediaId = freezed,
  }) {
    return _then(_value.copyWith(
      error: freezed == error ? _value.error : error,
      actionError: freezed == actionError ? _value.actionError : actionError,
      hasLocalMediaAccess: null == hasLocalMediaAccess
          ? _value.hasLocalMediaAccess
          : hasLocalMediaAccess // ignore: cast_nullable_to_non_nullable
              as bool,
      hasInternet: null == hasInternet
          ? _value.hasInternet
          : hasInternet // ignore: cast_nullable_to_non_nullable
              as bool,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      cloudLoading: null == cloudLoading
          ? _value.cloudLoading
          : cloudLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      googleAccount: freezed == googleAccount
          ? _value.googleAccount
          : googleAccount // ignore: cast_nullable_to_non_nullable
              as GoogleSignInAccount?,
      dropboxAccount: freezed == dropboxAccount
          ? _value.dropboxAccount
          : dropboxAccount // ignore: cast_nullable_to_non_nullable
              as DropboxAccount?,
      medias: null == medias
          ? _value.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, Map<String, AppMedia>>,
      selectedMedias: null == selectedMedias
          ? _value.selectedMedias
          : selectedMedias // ignore: cast_nullable_to_non_nullable
              as Map<String, AppMedia>,
      uploadMediaProcesses: null == uploadMediaProcesses
          ? _value.uploadMediaProcesses
          : uploadMediaProcesses // ignore: cast_nullable_to_non_nullable
              as Map<String, UploadMediaProcess>,
      downloadMediaProcesses: null == downloadMediaProcesses
          ? _value.downloadMediaProcesses
          : downloadMediaProcesses // ignore: cast_nullable_to_non_nullable
              as Map<String, DownloadMediaProcess>,
      lastLocalMediaId: freezed == lastLocalMediaId
          ? _value.lastLocalMediaId
          : lastLocalMediaId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of HomeViewState
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
abstract class _$$HomeViewStateImplCopyWith<$Res>
    implements $HomeViewStateCopyWith<$Res> {
  factory _$$HomeViewStateImplCopyWith(
          _$HomeViewStateImpl value, $Res Function(_$HomeViewStateImpl) then) =
      __$$HomeViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Object? error,
      Object? actionError,
      bool hasLocalMediaAccess,
      bool hasInternet,
      bool loading,
      bool cloudLoading,
      GoogleSignInAccount? googleAccount,
      DropboxAccount? dropboxAccount,
      Map<DateTime, Map<String, AppMedia>> medias,
      Map<String, AppMedia> selectedMedias,
      Map<String, UploadMediaProcess> uploadMediaProcesses,
      Map<String, DownloadMediaProcess> downloadMediaProcesses,
      String? lastLocalMediaId});

  @override
  $DropboxAccountCopyWith<$Res>? get dropboxAccount;
}

/// @nodoc
class __$$HomeViewStateImplCopyWithImpl<$Res>
    extends _$HomeViewStateCopyWithImpl<$Res, _$HomeViewStateImpl>
    implements _$$HomeViewStateImplCopyWith<$Res> {
  __$$HomeViewStateImplCopyWithImpl(
      _$HomeViewStateImpl _value, $Res Function(_$HomeViewStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? actionError = freezed,
    Object? hasLocalMediaAccess = null,
    Object? hasInternet = null,
    Object? loading = null,
    Object? cloudLoading = null,
    Object? googleAccount = freezed,
    Object? dropboxAccount = freezed,
    Object? medias = null,
    Object? selectedMedias = null,
    Object? uploadMediaProcesses = null,
    Object? downloadMediaProcesses = null,
    Object? lastLocalMediaId = freezed,
  }) {
    return _then(_$HomeViewStateImpl(
      error: freezed == error ? _value.error : error,
      actionError: freezed == actionError ? _value.actionError : actionError,
      hasLocalMediaAccess: null == hasLocalMediaAccess
          ? _value.hasLocalMediaAccess
          : hasLocalMediaAccess // ignore: cast_nullable_to_non_nullable
              as bool,
      hasInternet: null == hasInternet
          ? _value.hasInternet
          : hasInternet // ignore: cast_nullable_to_non_nullable
              as bool,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      cloudLoading: null == cloudLoading
          ? _value.cloudLoading
          : cloudLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      googleAccount: freezed == googleAccount
          ? _value.googleAccount
          : googleAccount // ignore: cast_nullable_to_non_nullable
              as GoogleSignInAccount?,
      dropboxAccount: freezed == dropboxAccount
          ? _value.dropboxAccount
          : dropboxAccount // ignore: cast_nullable_to_non_nullable
              as DropboxAccount?,
      medias: null == medias
          ? _value._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, Map<String, AppMedia>>,
      selectedMedias: null == selectedMedias
          ? _value._selectedMedias
          : selectedMedias // ignore: cast_nullable_to_non_nullable
              as Map<String, AppMedia>,
      uploadMediaProcesses: null == uploadMediaProcesses
          ? _value._uploadMediaProcesses
          : uploadMediaProcesses // ignore: cast_nullable_to_non_nullable
              as Map<String, UploadMediaProcess>,
      downloadMediaProcesses: null == downloadMediaProcesses
          ? _value._downloadMediaProcesses
          : downloadMediaProcesses // ignore: cast_nullable_to_non_nullable
              as Map<String, DownloadMediaProcess>,
      lastLocalMediaId: freezed == lastLocalMediaId
          ? _value.lastLocalMediaId
          : lastLocalMediaId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$HomeViewStateImpl implements _HomeViewState {
  const _$HomeViewStateImpl(
      {this.error,
      this.actionError,
      this.hasLocalMediaAccess = false,
      this.hasInternet = false,
      this.loading = false,
      this.cloudLoading = false,
      this.googleAccount,
      this.dropboxAccount,
      final Map<DateTime, Map<String, AppMedia>> medias = const {},
      final Map<String, AppMedia> selectedMedias = const {},
      final Map<String, UploadMediaProcess> uploadMediaProcesses = const {},
      final Map<String, DownloadMediaProcess> downloadMediaProcesses = const {},
      this.lastLocalMediaId})
      : _medias = medias,
        _selectedMedias = selectedMedias,
        _uploadMediaProcesses = uploadMediaProcesses,
        _downloadMediaProcesses = downloadMediaProcesses;

  @override
  final Object? error;
  @override
  final Object? actionError;
  @override
  @JsonKey()
  final bool hasLocalMediaAccess;
  @override
  @JsonKey()
  final bool hasInternet;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool cloudLoading;
  @override
  final GoogleSignInAccount? googleAccount;
  @override
  final DropboxAccount? dropboxAccount;
  final Map<DateTime, Map<String, AppMedia>> _medias;
  @override
  @JsonKey()
  Map<DateTime, Map<String, AppMedia>> get medias {
    if (_medias is EqualUnmodifiableMapView) return _medias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_medias);
  }

  final Map<String, AppMedia> _selectedMedias;
  @override
  @JsonKey()
  Map<String, AppMedia> get selectedMedias {
    if (_selectedMedias is EqualUnmodifiableMapView) return _selectedMedias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_selectedMedias);
  }

  final Map<String, UploadMediaProcess> _uploadMediaProcesses;
  @override
  @JsonKey()
  Map<String, UploadMediaProcess> get uploadMediaProcesses {
    if (_uploadMediaProcesses is EqualUnmodifiableMapView)
      return _uploadMediaProcesses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_uploadMediaProcesses);
  }

  final Map<String, DownloadMediaProcess> _downloadMediaProcesses;
  @override
  @JsonKey()
  Map<String, DownloadMediaProcess> get downloadMediaProcesses {
    if (_downloadMediaProcesses is EqualUnmodifiableMapView)
      return _downloadMediaProcesses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_downloadMediaProcesses);
  }

  @override
  final String? lastLocalMediaId;

  @override
  String toString() {
    return 'HomeViewState(error: $error, actionError: $actionError, hasLocalMediaAccess: $hasLocalMediaAccess, hasInternet: $hasInternet, loading: $loading, cloudLoading: $cloudLoading, googleAccount: $googleAccount, dropboxAccount: $dropboxAccount, medias: $medias, selectedMedias: $selectedMedias, uploadMediaProcesses: $uploadMediaProcesses, downloadMediaProcesses: $downloadMediaProcesses, lastLocalMediaId: $lastLocalMediaId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeViewStateImpl &&
            const DeepCollectionEquality().equals(other.error, error) &&
            const DeepCollectionEquality()
                .equals(other.actionError, actionError) &&
            (identical(other.hasLocalMediaAccess, hasLocalMediaAccess) ||
                other.hasLocalMediaAccess == hasLocalMediaAccess) &&
            (identical(other.hasInternet, hasInternet) ||
                other.hasInternet == hasInternet) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.cloudLoading, cloudLoading) ||
                other.cloudLoading == cloudLoading) &&
            (identical(other.googleAccount, googleAccount) ||
                other.googleAccount == googleAccount) &&
            (identical(other.dropboxAccount, dropboxAccount) ||
                other.dropboxAccount == dropboxAccount) &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            const DeepCollectionEquality()
                .equals(other._selectedMedias, _selectedMedias) &&
            const DeepCollectionEquality()
                .equals(other._uploadMediaProcesses, _uploadMediaProcesses) &&
            const DeepCollectionEquality().equals(
                other._downloadMediaProcesses, _downloadMediaProcesses) &&
            (identical(other.lastLocalMediaId, lastLocalMediaId) ||
                other.lastLocalMediaId == lastLocalMediaId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(error),
      const DeepCollectionEquality().hash(actionError),
      hasLocalMediaAccess,
      hasInternet,
      loading,
      cloudLoading,
      googleAccount,
      dropboxAccount,
      const DeepCollectionEquality().hash(_medias),
      const DeepCollectionEquality().hash(_selectedMedias),
      const DeepCollectionEquality().hash(_uploadMediaProcesses),
      const DeepCollectionEquality().hash(_downloadMediaProcesses),
      lastLocalMediaId);

  /// Create a copy of HomeViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeViewStateImplCopyWith<_$HomeViewStateImpl> get copyWith =>
      __$$HomeViewStateImplCopyWithImpl<_$HomeViewStateImpl>(this, _$identity);
}

abstract class _HomeViewState implements HomeViewState {
  const factory _HomeViewState(
      {final Object? error,
      final Object? actionError,
      final bool hasLocalMediaAccess,
      final bool hasInternet,
      final bool loading,
      final bool cloudLoading,
      final GoogleSignInAccount? googleAccount,
      final DropboxAccount? dropboxAccount,
      final Map<DateTime, Map<String, AppMedia>> medias,
      final Map<String, AppMedia> selectedMedias,
      final Map<String, UploadMediaProcess> uploadMediaProcesses,
      final Map<String, DownloadMediaProcess> downloadMediaProcesses,
      final String? lastLocalMediaId}) = _$HomeViewStateImpl;

  @override
  Object? get error;
  @override
  Object? get actionError;
  @override
  bool get hasLocalMediaAccess;
  @override
  bool get hasInternet;
  @override
  bool get loading;
  @override
  bool get cloudLoading;
  @override
  GoogleSignInAccount? get googleAccount;
  @override
  DropboxAccount? get dropboxAccount;
  @override
  Map<DateTime, Map<String, AppMedia>> get medias;
  @override
  Map<String, AppMedia> get selectedMedias;
  @override
  Map<String, UploadMediaProcess> get uploadMediaProcesses;
  @override
  Map<String, DownloadMediaProcess> get downloadMediaProcesses;
  @override
  String? get lastLocalMediaId;

  /// Create a copy of HomeViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeViewStateImplCopyWith<_$HomeViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
