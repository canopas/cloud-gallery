import 'package:flutter/cupertino.dart';
import 'app.dart';

void main() {
  runApp(const CloudGalleryApp());
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

