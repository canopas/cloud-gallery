import 'package:flutter/cupertino.dart'
    show CupertinoTextThemeData, CupertinoThemeData;
import 'package:flutter/material.dart' show AppBarTheme, ColorScheme, ThemeData;
import 'theme.dart' show AppColorScheme;

class AppThemeBuilder {
  static ThemeData materialThemeFromColorScheme({
    required AppColorScheme colorScheme,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      primaryColor: colorScheme.primary,
      dividerColor: colorScheme.outline,
      colorScheme: ColorScheme(
        primary: colorScheme.primary,
        secondary: colorScheme.secondary,
        tertiary: colorScheme.tertiary,
        surface: colorScheme.surface,
        onPrimary: colorScheme.onPrimary,
        onSecondary: colorScheme.onSecondary,
        onSurface: colorScheme.textPrimary,
        outline: colorScheme.outline,
        brightness: colorScheme.brightness,
        error: colorScheme.alert,
        onError: colorScheme.onPrimary,
        surfaceBright: colorScheme.surface,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        centerTitle: true,
        surfaceTintColor: colorScheme.surface,
        foregroundColor: colorScheme.textPrimary,
        scrolledUnderElevation: 3,
      ),
    );
  }

  static CupertinoThemeData cupertinoThemeFromColorScheme({
    required AppColorScheme colorScheme,
  }) {
    return CupertinoThemeData(
      brightness: colorScheme.brightness,
      primaryColor: colorScheme.primary,
      primaryContrastingColor: colorScheme.onPrimary,
      barBackgroundColor: colorScheme.surface,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: CupertinoTextThemeData(
        primaryColor: colorScheme.textPrimary,
      ),
      applyThemeToAll: true,
    );
  }
}
