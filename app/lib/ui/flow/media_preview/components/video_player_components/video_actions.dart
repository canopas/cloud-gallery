import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:style/animations/cross_fade_animation.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/animations/animated_icon.dart';

class VideoActions extends StatelessWidget {
  final bool showActions;
  final void Function()? onBackward;
  final void Function()? onForward;
  final void Function()? onPlayPause;
  final bool isPlaying;

  const VideoActions({
    super.key,
    required this.showActions,
    this.onBackward,
    this.onForward,
    this.onPlayPause,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: CrossFadeAnimation(
        alignment: Alignment.center,
        replacement: const SizedBox(),
        showChild: showActions,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OnTapScale(
              onTap: onBackward,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 22,
                  right: 18,
                  top: 18,
                  bottom: 18,
                ),
                child: Icon(
                  CupertinoIcons.gobackward_10,
                  color: context.colorScheme.onPrimary,
                  size: 32,
                ),
              ),
            ),
            OnTapScale(
              onTap: onPlayPause,
              child: AnimatedIconAnimation(
                value: isPlaying,
                icon: AnimatedIcons.play_pause,
                size: 64,
              ),
            ),
            OnTapScale(
              onTap: onForward,
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
        ),
      ),
    );
  }
}
