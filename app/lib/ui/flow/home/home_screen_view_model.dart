import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_screen_view_model.freezed.dart';

final homeViewStateNotifier =
    StateNotifierProvider.autoDispose<HomeViewStateNotifier, HomeViewState>(
  (ref) => HomeViewStateNotifier(),
);

enum MediaSource { local, googleDrive }

class HomeViewStateNotifier extends StateNotifier<HomeViewState> {
  HomeViewStateNotifier() : super(const HomeViewState());

  Future<void> updateMediaSource(
      {required MediaSource source, required bool isChangedByScroll}) async {
    state = state.copyWith(
        sourcePage: SourcePage(
            sourcePage: source, viewChangedByScroll: isChangedByScroll));
  }
}

@freezed
class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    @Default(SourcePage()) SourcePage sourcePage,
    @Default(false) bool isLastViewChangedByScroll,
  }) = _HomeViewState;
}

class SourcePage {
  final MediaSource sourcePage;
  final bool viewChangedByScroll;

  const SourcePage({
    this.sourcePage = MediaSource.local,
    this.viewChangedByScroll = false,
  });
}
