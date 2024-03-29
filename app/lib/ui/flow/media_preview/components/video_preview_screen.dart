import 'dart:io';
import 'package:cloud_gallery/domain/formatter/duration_formatter.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  final AppMedia media;

  const VideoPreview({super.key, required this.media});

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview>  with SingleTickerProviderStateMixin{
  bool _isInitialized = false;
  bool _isBuffering = false;
  Duration _position = Duration.zero;
  Duration _maxDuration = Duration.zero;

  late VideoPlayerController _videoController;
  late AnimationController _playPauseController;


  @override
  void dispose() {
    _videoController.dispose();
    _playPauseController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.media.sources.contains(AppMediaSource.local)) {
      _videoController = VideoPlayerController.file(File(widget.media.path))
        ..initialize().then((_) {
          setState(() {});
        });
    }
    _playPauseController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _videoController.play();
    _videoController.addListener(_videoControllerListener);
    super.initState();
  }


  _videoControllerListener() {
    if (_videoController.value.position == _videoController.value.duration && _videoController.value.isCompleted ) {
      _playPauseController.forward();
    }
    _isInitialized = _videoController.value.isInitialized;
    _isBuffering = _videoController.value.isBuffering;
    _position = _videoController.value.position;
    _maxDuration = _videoController.value.duration;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _buildVideoPlayer(context);
  }

  Widget _buildVideoPlayer(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_isInitialized)
          Center(
            child: AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            ),
          ),
        if (!_isInitialized || _isBuffering)
          Center(
            child: AppCircularProgressIndicator(
              color: context.colorScheme.onPrimary,
            ),
          ),
        _videoActions(context),
        _videoDurationSlider(context),
      ],
    );
  }

  Widget _videoActions(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      OnTapScale(
        onTap: () {
          _videoController.seekTo(
            Duration(seconds: _position.inSeconds - 10),
          );
        },
        child: const Padding(
          padding:
          EdgeInsets.only(left: 22, right: 18, top: 18, bottom: 18),
          child: Icon(
            CupertinoIcons.gobackward_10,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
      OnTapScale(
        onTap: () async {
          if (_videoController.value.isPlaying) {
           await  _playPauseController.forward();
            _videoController.pause();
          } else {
            await _playPauseController.reverse();
            _videoController.play();
          }
        },
        child: AnimatedIcon(
          icon: AnimatedIcons.pause_play,
          progress: _playPauseController,
          color: Colors.white,
          size: 64,
        ),
      ),
      OnTapScale(
        onTap: () {
          _videoController.seekTo(Duration(seconds: _position.inSeconds + 10),
          );
        },
        child: const Padding(
          padding:
          EdgeInsets.only(left: 18, right: 22, top: 18, bottom: 18),
          child: Icon(
            CupertinoIcons.goforward_10,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    ],
  );

  Widget _videoDurationSlider(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 30,
            child: Material(
              color: Colors.transparent,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  activeTrackColor: Colors.white,
                  thumbShape: SliderComponentShape.noThumb,
                  inactiveTrackColor: Colors.grey.shade500,
                ),
                child: Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _maxDuration.inSeconds.toDouble(),
                  min: 0,
                  onChanged: (value) {
                    setState(() {
                      _position = Duration(seconds: value.toInt());
                    });
                    _videoController.seekTo(Duration(seconds: value.toInt()));
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _position.format,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _maxDuration.format,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
