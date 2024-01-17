import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final container = ProviderContainer();
  runApp(UncontrolledProviderScope(
      container: container, child: const CloudGalleryApp()));
}

class CloudGalleryApp extends StatefulWidget {
  const CloudGalleryApp({super.key});

  @override
  State<CloudGalleryApp> createState() => _CloudGalleryAppState();
}

class _CloudGalleryAppState extends State<CloudGalleryApp> {
  @override
  Widget build(BuildContext context) {
    return const App();
  }
}
