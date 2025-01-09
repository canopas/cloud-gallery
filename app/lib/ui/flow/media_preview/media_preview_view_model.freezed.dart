// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_preview_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MediaPreviewState {
  GoogleSignInAccount? get googleAccount => throw _privateConstructorUsedError;
  DropboxAccount? get dropboxAccount => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;
  Object? get actionError => throw _privateConstructorUsedError;
  List<AppMedia> get medias => throw _privateConstructorUsedError;
  int get currentIndex => throw _privateConstructorUsedError;
  bool get showActions => throw _privateConstructorUsedError;
  bool get isVideoInitialized => throw _privateConstructorUsedError;
  bool get isVideoBuffering => throw _privateConstructorUsedError;
  bool get isImageZoomed => throw _privateConstructorUsedError;
  bool get pointerOnSlider => throw _privateConstructorUsedError;
  double get swipeDownPercentage => throw _privateConstructorUsedError;
  Duration get videoPosition => throw _privateConstructorUsedError;
  Duration get videoMaxDuration => throw _privateConstructorUsedError;
  String? get initializedVideoPath => throw _privateConstructorUsedError;
  bool get isVideoPlaying => throw _privateConstructorUsedError;
  Map<String, UploadMediaProcess> get uploadMediaProcesses =>
      throw _privateConstructorUsedError;
  Map<String, DownloadMediaProcess> get downloadMediaProcesses =>
      throw _privateConstructorUsedError;

  /// Create a copy of MediaPreviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaPreviewStateCopyWith<MediaPreviewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaPreviewStateCopyWith<$Res> {
  factory $MediaPreviewStateCopyWith(
          MediaPreviewState value, $Res Function(MediaPreviewState) then) =
      _$MediaPreviewStateCopyWithImpl<$Res, MediaPreviewState>;
  @useResult
  $Res call(
      {GoogleSignInAccount? googleAccount,
      DropboxAccount? dropboxAccount,
      Object? error,
      Object? actionError,
      List<AppMedia> medias,
      int currentIndex,
      bool showActions,
      bool isVideoInitialized,
      bool isVideoBuffering,
      bool isImageZoomed,
      bool pointerOnSlider,
      double swipeDownPercentage,
      Duration videoPosition,
      Duration videoMaxDuration,
      String? initializedVideoPath,
      bool isVideoPlaying,
      Map<String, UploadMediaProcess> uploadMediaProcesses,
      Map<String, DownloadMediaProcess> downloadMediaProcesses});

  $DropboxAccountCopyWith<$Res>? get dropboxAccount;
}

/// @nodoc
class _$MediaPreviewStateCopyWithImpl<$Res, $Val extends MediaPreviewState>
    implements $MediaPreviewStateCopyWith<$Res> {
  _$MediaPreviewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaPreviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? googleAccount = freezed,
    Object? dropboxAccount = freezed,
    Object? error = freezed,
    Object? actionError = freezed,
    Object? medias = null,
    Object? currentIndex = null,
    Object? showActions = null,
    Object? isVideoInitialized = null,
    Object? isVideoBuffering = null,
    Object? isImageZoomed = null,
    Object? pointerOnSlider = null,
    Object? swipeDownPercentage = null,
    Object? videoPosition = null,
    Object? videoMaxDuration = null,
    Object? initializedVideoPath = freezed,
    Object? isVideoPlaying = null,
    Object? uploadMediaProcesses = null,
    Object? downloadMediaProcesses = null,
  }) {
    return _then(_value.copyWith(
      googleAccount: freezed == googleAccount
          ? _value.googleAccount
          : googleAccount // ignore: cast_nullable_to_non_nullable
              as GoogleSignInAccount?,
      dropboxAccount: freezed == dropboxAccount
          ? _value.dropboxAccount
          : dropboxAccount // ignore: cast_nullable_to_non_nullable
              as DropboxAccount?,
      error: freezed == error ? _value.error : error,
      actionError: freezed == actionError ? _value.actionError : actionError,
      medias: null == medias
          ? _value.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      showActions: null == showActions
          ? _value.showActions
          : showActions // ignore: cast_nullable_to_non_nullable
              as bool,
      isVideoInitialized: null == isVideoInitialized
          ? _value.isVideoInitialized
          : isVideoInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      isVideoBuffering: null == isVideoBuffering
          ? _value.isVideoBuffering
          : isVideoBuffering // ignore: cast_nullable_to_non_nullable
              as bool,
      isImageZoomed: null == isImageZoomed
          ? _value.isImageZoomed
          : isImageZoomed // ignore: cast_nullable_to_non_nullable
              as bool,
      pointerOnSlider: null == pointerOnSlider
          ? _value.pointerOnSlider
          : pointerOnSlider // ignore: cast_nullable_to_non_nullable
              as bool,
      swipeDownPercentage: null == swipeDownPercentage
          ? _value.swipeDownPercentage
          : swipeDownPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      videoPosition: null == videoPosition
          ? _value.videoPosition
          : videoPosition // ignore: cast_nullable_to_non_nullable
              as Duration,
      videoMaxDuration: null == videoMaxDuration
          ? _value.videoMaxDuration
          : videoMaxDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      initializedVideoPath: freezed == initializedVideoPath
          ? _value.initializedVideoPath
          : initializedVideoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      isVideoPlaying: null == isVideoPlaying
          ? _value.isVideoPlaying
          : isVideoPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      uploadMediaProcesses: null == uploadMediaProcesses
          ? _value.uploadMediaProcesses
          : uploadMediaProcesses // ignore: cast_nullable_to_non_nullable
              as Map<String, UploadMediaProcess>,
      downloadMediaProcesses: null == downloadMediaProcesses
          ? _value.downloadMediaProcesses
          : downloadMediaProcesses // ignore: cast_nullable_to_non_nullable
              as Map<String, DownloadMediaProcess>,
    ) as $Val);
  }

  /// Create a copy of MediaPreviewState
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
abstract class _$$MediaPreviewStateImplCopyWith<$Res>
    implements $MediaPreviewStateCopyWith<$Res> {
  factory _$$MediaPreviewStateImplCopyWith(_$MediaPreviewStateImpl value,
          $Res Function(_$MediaPreviewStateImpl) then) =
      __$$MediaPreviewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GoogleSignInAccount? googleAccount,
      DropboxAccount? dropboxAccount,
      Object? error,
      Object? actionError,
      List<AppMedia> medias,
      int currentIndex,
      bool showActions,
      bool isVideoInitialized,
      bool isVideoBuffering,
      bool isImageZoomed,
      bool pointerOnSlider,
      double swipeDownPercentage,
      Duration videoPosition,
      Duration videoMaxDuration,
      String? initializedVideoPath,
      bool isVideoPlaying,
      Map<String, UploadMediaProcess> uploadMediaProcesses,
      Map<String, DownloadMediaProcess> downloadMediaProcesses});

  @override
  $DropboxAccountCopyWith<$Res>? get dropboxAccount;
}

/// @nodoc
class __$$MediaPreviewStateImplCopyWithImpl<$Res>
    extends _$MediaPreviewStateCopyWithImpl<$Res, _$MediaPreviewStateImpl>
    implements _$$MediaPreviewStateImplCopyWith<$Res> {
  __$$MediaPreviewStateImplCopyWithImpl(_$MediaPreviewStateImpl _value,
      $Res Function(_$MediaPreviewStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaPreviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? googleAccount = freezed,
    Object? dropboxAccount = freezed,
    Object? error = freezed,
    Object? actionError = freezed,
    Object? medias = null,
    Object? currentIndex = null,
    Object? showActions = null,
    Object? isVideoInitialized = null,
    Object? isVideoBuffering = null,
    Object? isImageZoomed = null,
    Object? pointerOnSlider = null,
    Object? swipeDownPercentage = null,
    Object? videoPosition = null,
    Object? videoMaxDuration = null,
    Object? initializedVideoPath = freezed,
    Object? isVideoPlaying = null,
    Object? uploadMediaProcesses = null,
    Object? downloadMediaProcesses = null,
  }) {
    return _then(_$MediaPreviewStateImpl(
      googleAccount: freezed == googleAccount
          ? _value.googleAccount
          : googleAccount // ignore: cast_nullable_to_non_nullable
              as GoogleSignInAccount?,
      dropboxAccount: freezed == dropboxAccount
          ? _value.dropboxAccount
          : dropboxAccount // ignore: cast_nullable_to_non_nullable
              as DropboxAccount?,
      error: freezed == error ? _value.error : error,
      actionError: freezed == actionError ? _value.actionError : actionError,
      medias: null == medias
          ? _value._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<AppMedia>,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      showActions: null == showActions
          ? _value.showActions
          : showActions // ignore: cast_nullable_to_non_nullable
              as bool,
      isVideoInitialized: null == isVideoInitialized
          ? _value.isVideoInitialized
          : isVideoInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      isVideoBuffering: null == isVideoBuffering
          ? _value.isVideoBuffering
          : isVideoBuffering // ignore: cast_nullable_to_non_nullable
              as bool,
      isImageZoomed: null == isImageZoomed
          ? _value.isImageZoomed
          : isImageZoomed // ignore: cast_nullable_to_non_nullable
              as bool,
      pointerOnSlider: null == pointerOnSlider
          ? _value.pointerOnSlider
          : pointerOnSlider // ignore: cast_nullable_to_non_nullable
              as bool,
      swipeDownPercentage: null == swipeDownPercentage
          ? _value.swipeDownPercentage
          : swipeDownPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      videoPosition: null == videoPosition
          ? _value.videoPosition
          : videoPosition // ignore: cast_nullable_to_non_nullable
              as Duration,
      videoMaxDuration: null == videoMaxDuration
          ? _value.videoMaxDuration
          : videoMaxDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      initializedVideoPath: freezed == initializedVideoPath
          ? _value.initializedVideoPath
          : initializedVideoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      isVideoPlaying: null == isVideoPlaying
          ? _value.isVideoPlaying
          : isVideoPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      uploadMediaProcesses: null == uploadMediaProcesses
          ? _value._uploadMediaProcesses
          : uploadMediaProcesses // ignore: cast_nullable_to_non_nullable
              as Map<String, UploadMediaProcess>,
      downloadMediaProcesses: null == downloadMediaProcesses
          ? _value._downloadMediaProcesses
          : downloadMediaProcesses // ignore: cast_nullable_to_non_nullable
              as Map<String, DownloadMediaProcess>,
    ));
  }
}

/// @nodoc

class _$MediaPreviewStateImpl implements _MediaPreviewState {
  const _$MediaPreviewStateImpl(
      {this.googleAccount,
      this.dropboxAccount,
      this.error,
      this.actionError,
      final List<AppMedia> medias = const [],
      this.currentIndex = 0,
      this.showActions = true,
      this.isVideoInitialized = false,
      this.isVideoBuffering = false,
      this.isImageZoomed = false,
      this.pointerOnSlider = false,
      this.swipeDownPercentage = 0.0,
      this.videoPosition = Duration.zero,
      this.videoMaxDuration = Duration.zero,
      this.initializedVideoPath,
      this.isVideoPlaying = false,
      final Map<String, UploadMediaProcess> uploadMediaProcesses = const {},
      final Map<String, DownloadMediaProcess> downloadMediaProcesses =
          const {}})
      : _medias = medias,
        _uploadMediaProcesses = uploadMediaProcesses,
        _downloadMediaProcesses = downloadMediaProcesses;

  @override
  final GoogleSignInAccount? googleAccount;
  @override
  final DropboxAccount? dropboxAccount;
  @override
  final Object? error;
  @override
  final Object? actionError;
  final List<AppMedia> _medias;
  @override
  @JsonKey()
  List<AppMedia> get medias {
    if (_medias is EqualUnmodifiableListView) return _medias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medias);
  }

  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final bool showActions;
  @override
  @JsonKey()
  final bool isVideoInitialized;
  @override
  @JsonKey()
  final bool isVideoBuffering;
  @override
  @JsonKey()
  final bool isImageZoomed;
  @override
  @JsonKey()
  final bool pointerOnSlider;
  @override
  @JsonKey()
  final double swipeDownPercentage;
  @override
  @JsonKey()
  final Duration videoPosition;
  @override
  @JsonKey()
  final Duration videoMaxDuration;
  @override
  final String? initializedVideoPath;
  @override
  @JsonKey()
  final bool isVideoPlaying;
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
  String toString() {
    return 'MediaPreviewState(googleAccount: $googleAccount, dropboxAccount: $dropboxAccount, error: $error, actionError: $actionError, medias: $medias, currentIndex: $currentIndex, showActions: $showActions, isVideoInitialized: $isVideoInitialized, isVideoBuffering: $isVideoBuffering, isImageZoomed: $isImageZoomed, pointerOnSlider: $pointerOnSlider, swipeDownPercentage: $swipeDownPercentage, videoPosition: $videoPosition, videoMaxDuration: $videoMaxDuration, initializedVideoPath: $initializedVideoPath, isVideoPlaying: $isVideoPlaying, uploadMediaProcesses: $uploadMediaProcesses, downloadMediaProcesses: $downloadMediaProcesses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaPreviewStateImpl &&
            (identical(other.googleAccount, googleAccount) ||
                other.googleAccount == googleAccount) &&
            (identical(other.dropboxAccount, dropboxAccount) ||
                other.dropboxAccount == dropboxAccount) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            const DeepCollectionEquality()
                .equals(other.actionError, actionError) &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.showActions, showActions) ||
                other.showActions == showActions) &&
            (identical(other.isVideoInitialized, isVideoInitialized) ||
                other.isVideoInitialized == isVideoInitialized) &&
            (identical(other.isVideoBuffering, isVideoBuffering) ||
                other.isVideoBuffering == isVideoBuffering) &&
            (identical(other.isImageZoomed, isImageZoomed) ||
                other.isImageZoomed == isImageZoomed) &&
            (identical(other.pointerOnSlider, pointerOnSlider) ||
                other.pointerOnSlider == pointerOnSlider) &&
            (identical(other.swipeDownPercentage, swipeDownPercentage) ||
                other.swipeDownPercentage == swipeDownPercentage) &&
            (identical(other.videoPosition, videoPosition) ||
                other.videoPosition == videoPosition) &&
            (identical(other.videoMaxDuration, videoMaxDuration) ||
                other.videoMaxDuration == videoMaxDuration) &&
            (identical(other.initializedVideoPath, initializedVideoPath) ||
                other.initializedVideoPath == initializedVideoPath) &&
            (identical(other.isVideoPlaying, isVideoPlaying) ||
                other.isVideoPlaying == isVideoPlaying) &&
            const DeepCollectionEquality()
                .equals(other._uploadMediaProcesses, _uploadMediaProcesses) &&
            const DeepCollectionEquality().equals(
                other._downloadMediaProcesses, _downloadMediaProcesses));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      googleAccount,
      dropboxAccount,
      const DeepCollectionEquality().hash(error),
      const DeepCollectionEquality().hash(actionError),
      const DeepCollectionEquality().hash(_medias),
      currentIndex,
      showActions,
      isVideoInitialized,
      isVideoBuffering,
      isImageZoomed,
      pointerOnSlider,
      swipeDownPercentage,
      videoPosition,
      videoMaxDuration,
      initializedVideoPath,
      isVideoPlaying,
      const DeepCollectionEquality().hash(_uploadMediaProcesses),
      const DeepCollectionEquality().hash(_downloadMediaProcesses));

  /// Create a copy of MediaPreviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaPreviewStateImplCopyWith<_$MediaPreviewStateImpl> get copyWith =>
      __$$MediaPreviewStateImplCopyWithImpl<_$MediaPreviewStateImpl>(
          this, _$identity);
}

abstract class _MediaPreviewState implements MediaPreviewState {
  const factory _MediaPreviewState(
          {final GoogleSignInAccount? googleAccount,
          final DropboxAccount? dropboxAccount,
          final Object? error,
          final Object? actionError,
          final List<AppMedia> medias,
          final int currentIndex,
          final bool showActions,
          final bool isVideoInitialized,
          final bool isVideoBuffering,
          final bool isImageZoomed,
          final bool pointerOnSlider,
          final double swipeDownPercentage,
          final Duration videoPosition,
          final Duration videoMaxDuration,
          final String? initializedVideoPath,
          final bool isVideoPlaying,
          final Map<String, UploadMediaProcess> uploadMediaProcesses,
          final Map<String, DownloadMediaProcess> downloadMediaProcesses}) =
      _$MediaPreviewStateImpl;

  @override
  GoogleSignInAccount? get googleAccount;
  @override
  DropboxAccount? get dropboxAccount;
  @override
  Object? get error;
  @override
  Object? get actionError;
  @override
  List<AppMedia> get medias;
  @override
  int get currentIndex;
  @override
  bool get showActions;
  @override
  bool get isVideoInitialized;
  @override
  bool get isVideoBuffering;
  @override
  bool get isImageZoomed;
  @override
  bool get pointerOnSlider;
  @override
  double get swipeDownPercentage;
  @override
  Duration get videoPosition;
  @override
  Duration get videoMaxDuration;
  @override
  String? get initializedVideoPath;
  @override
  bool get isVideoPlaying;
  @override
  Map<String, UploadMediaProcess> get uploadMediaProcesses;
  @override
  Map<String, DownloadMediaProcess> get downloadMediaProcesses;

  /// Create a copy of MediaPreviewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaPreviewStateImplCopyWith<_$MediaPreviewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
