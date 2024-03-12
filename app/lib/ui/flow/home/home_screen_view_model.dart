import 'dart:async';
import 'package:cloud_gallery/domain/extensions/date_extensions.dart';
import 'package:collection/collection.dart';
import 'package:data/models/media/media.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:style/extensions/list_extensions.dart';

part 'home_screen_view_model.freezed.dart';

final homeViewStateNotifier =
    StateNotifierProvider.autoDispose<HomeViewStateNotifier, HomeViewState>(
        (ref) {
  final homeViewStateNotifier = HomeViewStateNotifier(
    ref.read(localMediaServiceProvider),
    ref.read(googleDriveServiceProvider),
    ref.read(authServiceProvider),
    ref.read(AppPreferences.canTakeAutoBackUpInGoogleDrive),
  );
  final subscription = ref.listen(AppPreferences.canTakeAutoBackUpInGoogleDrive,
      (previous, next) {
    homeViewStateNotifier.updateAutoBackUpStatus(next);
  });
  ref.onDispose(() {
    subscription.close();
  });
  return homeViewStateNotifier;
});

class HomeViewStateNotifier extends StateNotifier<HomeViewState> {
  final GoogleDriveService _googleDriveService;
  final AuthService _authService;
  final LocalMediaService _localMediaService;
  StreamSubscription? _googleAccountSubscription;
  bool _isAutoBackUpEnabled = false;
  bool _isAutoBackUpWorking = false;

  String? _backUpFolderId;
  List<AppMedia> _localMedias = [];
  int? _localMediaCount;
  bool _loading = false;
  List<AppMedia> _googleDriveMedias = [];

  HomeViewStateNotifier(this._localMediaService, this._googleDriveService,
      this._authService, this._isAutoBackUpEnabled)
      : super(const HomeViewState()) {
    _googleAccountSubscription =
        _authService.onGoogleAccountChange.listen((event) {
      state = state.copyWith(googleAccount: event);
      loadMedias();
    });
    if (_isAutoBackUpEnabled) {
      _autoBackUpMedias();
    }
    loadMedias();
  }

  @override
  Future<void> dispose() async {
    await _googleAccountSubscription?.cancel();
    super.dispose();
  }

  Future<void> _autoBackUpMedias() async {
    _backUpFolderId ??= await _googleDriveService.getBackupFolderId();
    _isAutoBackUpWorking = true;
    for (final media in state.medias.values.expand((element) => element)) {
      if (!_isAutoBackUpEnabled) {
        _isAutoBackUpWorking = false;
        return;
      }
      if (!media.sources.contains(AppMediaSource.googleDrive)) {
        state = state.copyWith(
            uploadingMedias: state.uploadingMedias.toList()..add(media.id));
        await _googleDriveService.uploadInGoogleDrive(
          media: media,
          folderID: _backUpFolderId!,
        );
        state = state.copyWith(
          uploadingMedias: state.uploadingMedias.toList()..remove(media.id),
          medias: state.medias.map((key, value) {
            value.updateElement(
                newElement: media.copyWith(
                    sources: media.sources.toList()
                      ..add(AppMediaSource.googleDrive)),
                oldElement: media);
            return MapEntry(key, value);
          }),
        );
      }
    }
    _isAutoBackUpWorking = false;
  }

  Future<void> updateAutoBackUpStatus(bool status) async {
    _isAutoBackUpEnabled = status;
    if (_isAutoBackUpEnabled && !_isAutoBackUpWorking) {
      _autoBackUpMedias();
    }
  }

  Future<void> loadMedias() async {
    if (_loading == true) return;
    _loading = true;
    _googleDriveMedias = [];
    _localMedias = [];
    state = state.copyWith(loading: state.medias.isEmpty, error: null);
    try {
      _localMediaCount ??= await _getLocalMediaCount();
      if (_localMediaCount != null) {
        await Future.wait([
          _getGoogleDriveMedias(),
          _getLocalMedias(),
        ]);
      } else {
        await _getGoogleDriveMedias();
      }
      state = state.copyWith(
        loading: false,
        medias: _sortMedias(medias: _getAllMedias()),
        hasLocalMediaAccess: _localMediaCount != null,
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error);
    } finally {
      _loading = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
      state = state.copyWith(googleAccount: _authService.googleAccount);
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  List<AppMedia> _getAllMedias() {
    final commonMedias = <AppMedia>[];

    for (AppMedia localMedia in _localMedias.toList()) {
      _googleDriveMedias
          .toList()
          .where((element) => element.path == localMedia.path)
          .forEach((googleDriveMedia) {
        _googleDriveMedias
            .removeWhere((media) => media.id == googleDriveMedia.id);
        _localMedias.removeWhere((media) => media.id == localMedia.id);
        commonMedias.add(localMedia.copyWith(
            sources: [AppMediaSource.local, AppMediaSource.googleDrive],
            thumbnailPath: googleDriveMedia.thumbnailPath));
      });
    }

    return [..._localMedias, ..._googleDriveMedias, ...commonMedias];
  }

  Map<DateTime, List<AppMedia>> _sortMedias({required List<AppMedia> medias}) {
    medias.sort((a, b) => (b.createdTime ?? DateTime.now())
        .compareTo(a.createdTime ?? DateTime.now()));
    return groupBy<AppMedia, DateTime>(
      medias,
      (AppMedia media) =>
          media.createdTime?.dateOnly ?? DateTime.now().dateOnly,
    );
  }

  Future<void> _getGoogleDriveMedias() async {
    if (_authService.signedInWithGoogle) {
      _backUpFolderId ??= await _googleDriveService.getBackupFolderId();
      _googleDriveMedias = await _googleDriveService.getDriveMedias(
          backUpFolderId: _backUpFolderId!);
    }
  }

  Future<int?> _getLocalMediaCount() async {
    final hasAccess = await _localMediaService.requestPermission();
    if (hasAccess) {
      return await _localMediaService.getMediaCount();
    }
    return null;
  }

  Future<void> _getLocalMedias() async {
    if (_localMediaCount != null) {
      _localMedias = await _localMediaService.getLocalMedia(
        start: 0,
        end: _localMediaCount!,
      );
    }
  }

  void toggleMediaSelection(AppMedia media) {
    final selectedMedias = state.selectedMedias.toList();
    selectedMedias.addOrRemove(element: media);
    state = state.copyWith(selectedMedias: selectedMedias);
  }

  Future<void> uploadMediaOnGoogleDrive() async {
    try {
      if (!_authService.signedInWithGoogle) {
        await _authService.signInWithGoogle();
        loadMedias();
      }
      List<AppMedia> uploadingMedias = state.selectedMedias
          .where((element) =>
              !element.sources.contains(AppMediaSource.googleDrive))
          .toList();

      state = state.copyWith(
        uploadingMedias: uploadingMedias.map((e) => e.id).toList(),
        error: null,
      );
      _backUpFolderId ??= await _googleDriveService.getBackupFolderId();

      for (final media in uploadingMedias) {
        await _googleDriveService.uploadInGoogleDrive(
          media: media,
          folderID: _backUpFolderId!,
        );

        state = state.copyWith(
          medias: state.medias.map((key, value) {
            value.updateElement(
                newElement: media.copyWith(
                    sources: media.sources.toList()
                      ..add(AppMediaSource.googleDrive)),
                oldElement: media);
            return MapEntry(key, value);
          }),
          uploadingMedias: state.uploadingMedias.toList()..remove(media.id),
        );
      }

      state = state.copyWith(uploadingMedias: [], selectedMedias: []);
    } catch (error) {
      state = state.copyWith(error: error, uploadingMedias: []);
    }
  }
}

@freezed
class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    Object? error,
    @Default(false) bool hasLocalMediaAccess,
    @Default(false) bool loading,
    GoogleSignInAccount? googleAccount,
    @Default({}) Map<DateTime, List<AppMedia>> medias,
    @Default([]) List<AppMedia> selectedMedias,
    @Default([]) List<String> uploadingMedias,
  }) = _HomeViewState;
}
