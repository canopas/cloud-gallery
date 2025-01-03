import 'package:collection/collection.dart';
import 'package:data/domain/config.dart';
import 'package:data/errors/app_error.dart';
import 'package:data/log/logger.dart';
import 'package:data/models/dropbox/account/dropbox_account.dart';
import 'package:data/models/media/media.dart';
import 'package:data/services/auth_service.dart';
import 'package:data/services/dropbox_services.dart';
import 'package:data/services/google_drive_service.dart';
import 'package:data/services/local_media_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

part 'media_selection_state_notifier.freezed.dart';

final mediaSelectionStateNotifierProvider = StateNotifierProvider.autoDispose
    .family<MediaSelectionStateNotifier, MediaSelectionState, AppMediaSource>(
  (ref, state) {
    return MediaSelectionStateNotifier(
      ref.read(localMediaServiceProvider),
      ref.read(googleDriveServiceProvider),
      ref.read(dropboxServiceProvider),
      ref.read(googleUserAccountProvider),
      ref.read(AppPreferences.dropboxCurrentUserAccount),
      ref.read(loggerProvider),
      state,
    );
  },
);

class MediaSelectionStateNotifier extends StateNotifier<MediaSelectionState> {
  final GoogleDriveService _googleDriveService;
  final DropboxService _dropboxService;
  final LocalMediaService _localMediaService;
  final GoogleSignInAccount? _googleAccount;
  final DropboxAccount? _dropboxAccount;
  final Logger _logger;
  final AppMediaSource _source;

  MediaSelectionStateNotifier(
    this._localMediaService,
    this._googleDriveService,
    this._dropboxService,
    this._googleAccount,
    this._dropboxAccount,
    this._logger,
    this._source,
  ) : super(const MediaSelectionState()) {
    loadMedias(reload: true);
  }

  String? _pageToken;
  String? _backupFolderId;
  bool _maxLoaded = false;

  Future<void> loadMedias({bool reload = false}) async {
    try {
      if (state.loading || _maxLoaded) return;

      if (reload) {
        _pageToken = null;
        _maxLoaded = false;
      }

      state = state.copyWith(
        loading: true,
        error: null,
        actionError: null,
        noAccess: false,
        medias: reload ? {} : state.medias,
      );

      if (_source == AppMediaSource.googleDrive) {
        if (_googleAccount == null) {
          state = state.copyWith(
            loading: false,
            noAccess: true,
          );
          return;
        }
        _backupFolderId ??= await _googleDriveService.getBackUpFolderId();
        if (_backupFolderId == null) {
          throw BackUpFolderNotFound();
        }
        final res = await _googleDriveService.getPaginatedMedias(
          folder: _backupFolderId!,
          nextPageToken: _pageToken,
        );

        _pageToken = res.nextPageToken;
        if (res.nextPageToken == null) {
          _maxLoaded = true;
        }
        final groupedMedias = groupBy<AppMedia, DateTime>(
          [...state.medias.values.expand((element) => element), ...res.medias],
          (media) => media.createdTime ?? media.modifiedTime ?? DateTime.now(),
        );

        state = state.copyWith(
          medias: groupedMedias,
          loading: false,
        );
      } else if (_source == AppMediaSource.dropbox) {
        if (_dropboxAccount == null) {
          state = state.copyWith(
            loading: false,
            noAccess: true,
          );
          return;
        }

        final res = await _dropboxService.getPaginatedMedias(
          nextPageToken: _pageToken,
          folder: ProviderConstants.backupFolderPath,
        );

        _pageToken = res.nextPageToken;
        if (res.nextPageToken == null) {
          _maxLoaded = true;
        }

        final groupedMedias = groupBy<AppMedia, DateTime>(
          [...state.medias.values.expand((element) => element), ...res.medias],
          (media) => media.createdTime ?? media.modifiedTime ?? DateTime.now(),
        );

        state = state.copyWith(
          medias: groupedMedias,
          loading: false,
        );
      } else if (_source == AppMediaSource.local) {
        final hasPermission = await _localMediaService.requestPermission();

        if (!hasPermission) {
          state = state.copyWith(
            loading: false,
            noAccess: true,
          );
          return;
        }
        final mediasLength =
            state.medias.values.expand((element) => element).length;
        final medias = await _localMediaService.getLocalMedia(
          start: mediasLength,
          end: mediasLength + 30,
        );

        if (medias.length < 30) {
          _maxLoaded = true;
        }

        final groupedMedias = groupBy<AppMedia, DateTime>(
          [...state.medias.values.expand((element) => element), ...medias],
          (media) => media.createdTime ?? media.modifiedTime ?? DateTime.now(),
        );

        state = state.copyWith(
          medias: groupedMedias,
          loading: false,
        );
      } else {
        state = state.copyWith(
          loading: false,
        );
      }
    } catch (e, s) {
      state = state.copyWith(
        loading: false,
        error: state.medias.isEmpty ? e : null,
        actionError: state.medias.isNotEmpty ? e : null,
      );
      _logger.e(
        "MediaSelectionStateNotifier: Error loading medias",
        error: e,
        stackTrace: s,
      );
    }
  }

  void toggleMediaSelection(AppMedia media) {
    String id = media.id;

    if (_source == AppMediaSource.googleDrive) {
      id = media.driveMediaRefId!;
    } else if (_source == AppMediaSource.dropbox) {
      id = media.dropboxMediaRefId!;
    }

    if (state.selectedMedias.contains(id)) {
      state = state.copyWith(
        selectedMedias: [
          ...state.selectedMedias.where((element) => element != id),
        ],
      );
    } else {
      state = state.copyWith(
        selectedMedias: [
          ...state.selectedMedias,
          media.id,
        ],
      );
    }
  }
}

@freezed
class MediaSelectionState with _$MediaSelectionState {
  const factory MediaSelectionState({
    @Default({}) Map<DateTime, List<AppMedia>> medias,
    @Default([]) List<String> selectedMedias,
    @Default(false) bool loading,
    @Default(false) bool noAccess,
    Object? error,
    Object? actionError,
  }) = _MediaSelectionState;
}
