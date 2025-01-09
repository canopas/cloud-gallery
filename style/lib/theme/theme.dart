import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme extends InheritedWidget {
  final AppColorScheme colorScheme;

  const AppTheme({
    super.key,
    required this.colorScheme,
    required super.child,
  });

  @override
  bool updateShouldNotify(AppTheme oldWidget) {
    return colorScheme != oldWidget.colorScheme;
  }
}

AppColorScheme appColorSchemeOf(BuildContext context) {
  return context.dependOnInheritedWidgetOfExactType<AppTheme>()!.colorScheme;
}

class AppColorScheme {
  final Color primary;
  final Color secondary;
  final Color secondaryInverse;
  final Color tertiary;
  final Color tertiaryInverse;
  final Color surface;
  final Color surfaceInverse;
  final Color outline;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color outlineInverse;
  final Color textInversePrimary;
  final Color textInverseSecondary;
  final Color textInverseDisabled;
  final Color containerHighInverse;
  final Color containerNormalInverse;
  final Color containerLowInverse;
  final Color containerHigh;
  final Color containerNormal;
  final Color containerLow;
  final Color positive;
  final Color alert;
  final Color warning;
  final Color onPrimary;
  final Color onSecondary;
  final Color onDisabled;
  final Brightness brightness;

  AppColorScheme({
    required this.primary,
    required this.secondary,
    required this.secondaryInverse,
    required this.tertiary,
    required this.tertiaryInverse,
    required this.surface,
    required this.surfaceInverse,
    required this.outline,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.outlineInverse,
    required this.textInversePrimary,
    required this.textInverseSecondary,
    required this.textInverseDisabled,
    required this.containerNormalInverse,
    required this.containerHighInverse,
    required this.containerLowInverse,
    required this.containerHigh,
    required this.containerNormal,
    required this.containerLow,
    required this.positive,
    required this.alert,
    required this.warning,
    required this.onPrimary,
    required this.onSecondary,
    required this.onDisabled,
    required this.brightness,
  });

  Color get containerNormalOnSurface =>
      Color.alphaBlend(containerNormal, surface);

  Color get containerHighOnSurface => Color.alphaBlend(containerHigh, surface);

  Color get containerLowOnSurface => Color.alphaBlend(containerLow, surface);
}

final appColorSchemeLight = AppColorScheme(
  primary: AppColors.primaryColor,
  secondary: AppColors.secondaryLightColor,
  secondaryInverse: AppColors.secondaryDarkColor,
  tertiary: AppColors.tertiaryLightColor,
  tertiaryInverse: AppColors.tertiaryDarkColor,
  surface: AppColors.surfaceLightColor,
  surfaceInverse: AppColors.surfaceDarkColor,
  outline: AppColors.outlineLightColor,
  outlineInverse: AppColors.outlineDarkColor,
  textPrimary: AppColors.textPrimaryLightColor,
  textSecondary: AppColors.textSecondaryLightColor,
  textDisabled: AppColors.textDisabledLightColor,
  textInversePrimary: AppColors.textPrimaryDarkColor,
  textInverseSecondary: AppColors.textSecondaryDarkColor,
  textInverseDisabled: AppColors.textDisabledDarkColor,
  containerHigh: AppColors.containerHighLightColor,
  containerNormal: AppColors.containerNormalLightColor,
  containerLow: AppColors.containerLowLightColor,
  containerHighInverse: AppColors.containerHighDarkColor,
  containerNormalInverse: AppColors.containerNormalDarkColor,
  containerLowInverse: AppColors.containerLowDarkColor,
  positive: AppColors.awarenessPositiveColor,
  alert: AppColors.awarenessAlertColor,
  warning: AppColors.awarenessWarningColor,
  onPrimary: AppColors.textPrimaryDarkColor,
  onSecondary: AppColors.textSecondaryDarkColor,
  onDisabled: AppColors.textDisabledLightColor,
  brightness: Brightness.light,
);

final appColorSchemeDark = AppColorScheme(
  primary: AppColors.primaryColor,
  secondary: AppColors.secondaryDarkColor,
  secondaryInverse: AppColors.secondaryLightColor,
  tertiary: AppColors.tertiaryDarkColor,
  tertiaryInverse: AppColors.tertiaryLightColor,
  surface: AppColors.surfaceDarkColor,
  surfaceInverse: AppColors.surfaceLightColor,
  outline: AppColors.outlineDarkColor,
  outlineInverse: AppColors.outlineLightColor,
  textPrimary: AppColors.textPrimaryDarkColor,
  textSecondary: AppColors.textSecondaryDarkColor,
  textDisabled: AppColors.textDisabledDarkColor,
  textInversePrimary: AppColors.textPrimaryLightColor,
  textInverseSecondary: AppColors.textSecondaryLightColor,
  textInverseDisabled: AppColors.textDisabledLightColor,
  containerHighInverse: AppColors.containerHighLightColor,
  containerNormalInverse: AppColors.containerNormalLightColor,
  containerLowInverse: AppColors.containerLowLightColor,
  containerHigh: AppColors.containerHighDarkColor,
  containerNormal: AppColors.containerNormalDarkColor,
  containerLow: AppColors.containerLowDarkColor,
  positive: AppColors.awarenessPositiveColor,
  alert: AppColors.awarenessAlertColor,
  warning: AppColors.awarenessWarningColor,
  onPrimary: AppColors.textPrimaryDarkColor,
  onSecondary: AppColors.textSecondaryDarkColor,
  onDisabled: AppColors.textDisabledDarkColor,
  brightness: Brightness.dark,
);
