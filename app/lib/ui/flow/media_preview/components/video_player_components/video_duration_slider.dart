import 'dart:ui';
import 'package:style/theme/theme.dart';
import '../../../../../domain/formatter/duration_formatter.dart';
import 'package:flutter/material.dart';
import 'package:style/animations/cross_fade_animation.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class VideoDurationSlider extends StatelessWidget {
  final bool showSlider;
  final Duration duration;
  final void Function(Duration duration) onChangeStart;
  final void Function(Duration duration) onChanged;
  final void Function(Duration duration) onChangeEnd;
  final Duration position;

  const VideoDurationSlider({
    super.key,
    required this.showSlider,
    required this.duration,
    required this.position,
    required this.onChangeEnd,
    required this.onChanged,
    required this.onChangeStart,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CrossFadeAnimation(
        showChild: showSlider,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  appColorSchemeDark.surface.withValues(alpha: 0.2),
                  appColorSchemeDark.surface.withValues(alpha: 0.8),
                ],
              ),
            ),
            padding: EdgeInsets.only(
              bottom: context.systemPadding.bottom + 8,
              top: 8,
              left: 16,
              right: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  position.format,
                  style: AppTextStyles.caption
                      .copyWith(color: appColorSchemeDark.textPrimary),
                ),
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
                          activeColor: appColorSchemeDark.primary,
                          inactiveColor: appColorSchemeDark.outline,
                          onChangeStart: (value) => onChangeStart
                              .call(Duration(seconds: value.toInt())),
                          onChangeEnd: (value) => onChangeEnd
                              .call(Duration(seconds: value.toInt())),
                          onChanged: (double value) =>
                              onChanged.call(Duration(seconds: value.toInt())),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  duration.format,
                  style: AppTextStyles.caption
                      .copyWith(color: appColorSchemeDark.textPrimary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
