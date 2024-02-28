import 'package:cloud_gallery/ui/flow/home/google_drive/google_drive_medias_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/buttons/primary_button.dart';
import 'package:style/extensions/context_extensions.dart';
import '../../../../components/snack_bar.dart';
import '../../../../domain/extensions/widget_extensions.dart';

class GoogleDriveMediasScreen extends ConsumerStatefulWidget {
  const GoogleDriveMediasScreen({super.key});

  @override
  ConsumerState createState() => _LocalSourceViewState();
}

class _LocalSourceViewState extends ConsumerState<GoogleDriveMediasScreen> {
  late GoogleDriveMediasStateNotifier notifier;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    notifier = ref.read(googleDriveMediasStateNotifierProvider.notifier);
    runPostFrame(() async {
      await notifier.init();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _observeError() {
    ref.listen(
        googleDriveMediasStateNotifierProvider.select((value) => value.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context: context, error: next);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //Listeners
    _observeError();

    //States
    final medias = ref.watch(
        googleDriveMediasStateNotifierProvider.select((state) => state.medias));

    final isLoading = ref.watch(googleDriveMediasStateNotifierProvider
        .select((state) => state.loading));

    final isSignedIn = ref.watch(googleDriveMediasStateNotifierProvider
        .select((state) => state.isSignedIn));

    //View
    if (!isSignedIn) {
      return Center(
        child: PrimaryButton(
          onPressed: notifier.signInWithGoogle,
          child: const Text('Sign in with Google'),
        ),
      );
    } else if (isLoading && medias.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    return Scrollbar(
      controller: _scrollController,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: medias.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: context.colorScheme.outline,
              image: DecorationImage(
                image: NetworkImage(medias[index].path),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
