import 'package:data/models/dropbox/account/dropbox_account.dart';
import 'package:data/models/media/media.dart';
import 'package:data/services/local_media_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AddAlbumStateNotifier extends StateNotifier<AddAlbumsState> {
  final GoogleSignInAccount? googleAccount;
  final DropboxAccount? dropboxAccount;

  AddAlbumStateNotifier(
    super.state,
    this.googleAccount,
    this.dropboxAccount,
  );

  void onGoogleDriveAccountChange(GoogleSignInAccount? googleAccount) {
    state = state.copyWith(googleAccount: googleAccount);
  }

  void onDropboxAccountChange(DropboxAccount? dropboxAccount) {
    state = state.copyWith(dropboxAccount: dropboxAccount);
  }

  void  createAlbum(){
    state = state.copyWith(loading: true);


  }
}

@freezed
class AddAlbumsState with _$AddAlbumsState {
  const factory AddAlbumsState({
    @Default(false) bool loading,
    AppMediaSource? mediaSource,
    required TextEditingController albumNameController,
    GoogleSignInAccount? googleAccount,
    DropboxAccount? dropboxAccount,
    Object? error,
  }) = _AddAlbumsState;
}
