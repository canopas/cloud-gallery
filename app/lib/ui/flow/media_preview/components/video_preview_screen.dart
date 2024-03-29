import 'package:cloud_gallery/components/app_page.dart';
import 'package:flutter/cupertino.dart';

class VideoPreviewScreen extends StatefulWidget {
  const VideoPreviewScreen({super.key});

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return const AppPage(
      title: '',
      body: Center(
        child: Text('Video Preview Screen'),
      ),
    );
  }
}
