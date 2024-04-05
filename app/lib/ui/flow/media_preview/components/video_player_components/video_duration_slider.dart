import 'dart:ui';
import 'package:cloud_gallery/domain/formatter/duration_formatter.dart';
import 'package:flutter/material.dart';
import 'package:style/animations/cross_fade_animation.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class VideoDurationSlider extends StatelessWidget {
  final bool showSlider;
  final Duration duration;
  final void Function(Duration duration) onChanged;
  final Duration position;

  const VideoDurationSlider(
      {super.key,
        required this.showSlider,
        required this.duration,
        required this.position,
        required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CrossFadeAnimation(
        showChild: showSlider,
        child: Container(
          padding: EdgeInsets.only(
              bottom: context.systemPadding.bottom + 8,
              top: 8,
              left: 16,
              right: 16),
          color: context.colorScheme.barColor,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(position.format,
                    style: AppTextStyles.caption
                        .copyWith(color: context.colorScheme.textPrimary)),
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: Material(
                      color: Colors.transparent,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4,
                          trackShape: const RoundedRectSliderTrackShape(),
                          rangeTrackShape:
                          const RoundedRectRangeSliderTrackShape(),
                          thumbShape: SliderComponentShape.noThumb,
                        ),
                        child: Slider(
                          value: position.inSeconds.toDouble(),
                          max: duration.inSeconds.toDouble(),
                          min: 0,
                          activeColor: context.colorScheme.primary,
                          inactiveColor: context.colorScheme.outline,
                          onChanged: (value) => onChanged.call(Duration(seconds: value.toInt())),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(duration.format,
                    style: AppTextStyles.caption
                        .copyWith(color: context.colorScheme.textPrimary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
