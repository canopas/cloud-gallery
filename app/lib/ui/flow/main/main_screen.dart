import 'dart:io';
import 'package:cloud_gallery/components/app_page.dart';
import 'package:data/models/media/media.dart';
import 'package:data/services/local_media_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/animations/parallex_effect.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<HomeScreen> {
  late LocalMediaService localMediaService;

  @override
  void initState() {
    localMediaService = ref.read(localMediaServiceProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Cloud Gallery',
      body: FutureBuilder(
        future: localMediaService.getAssets(),
        builder: (context, snapshot) {
          final res = snapshot.data;
          if (res is List<AppMedia>) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: res.length,
              itemBuilder: (context, index) => ImageItem(
                imageProvider: FileImage(File(res[index].path)),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ImageItem extends StatefulWidget {
  final ImageProvider imageProvider;

  const ImageItem({super.key, required this.imageProvider});

  @override
  State<ImageItem> createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  final _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Flow(
          delegate: ParallaxFlowDelegate(
            scrollable: Scrollable.of(context),
            listItemContext: context,
            backgroundImageKey: _backgroundImageKey,
          ),
          children: [
            Image(
              key: _backgroundImageKey,
              image: widget.imageProvider,
              fit: BoxFit.cover,
              width: constraints.maxWidth,
              height: constraints.maxHeight * 1.25,
            ),
          ],
        ),
      );
    });
  }
}
