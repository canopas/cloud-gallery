import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoogleDriveMediasScreen extends ConsumerStatefulWidget {
  const GoogleDriveMediasScreen({super.key});

  @override
  ConsumerState createState() => _GoogleDriveViewState();
}

class _GoogleDriveViewState extends ConsumerState<GoogleDriveMediasScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Google Drive'),
    );
  }
}
