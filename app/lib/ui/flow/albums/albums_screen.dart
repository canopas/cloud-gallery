import 'package:flutter/cupertino.dart';

import '../../../components/app_page.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Albums',
      body: const Center(
        child: Text('Albums Screen'),
      ),
    );
  }
}
