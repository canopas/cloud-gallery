import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:style/extensions/context_extensions.dart';
import '../../../../components/error_view.dart';

class DownloadRequireView extends StatelessWidget {
  final AppMedia media;
  const DownloadRequireView({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: media,
            child: Image.network(
              height: double.infinity,
              width: double.infinity,
              media.thumbnailLink!,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black38,
            child: ErrorView(
              foregroundColor: context.colorScheme.onPrimary,
              icon: Icon(CupertinoIcons.cloud_download,
                  size: 68, color: context.colorScheme.onPrimary),
              title: "Download Required",
              message:
              "To watch the video, simply download it first. Tap the download button to begin.",
              action: ErrorViewAction(title: "Download", onPressed: () {}),
            ),
          ),
        ],
      ),
    );
  }
}
