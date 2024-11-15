import 'package:flutter/cupertino.dart';
import '../theme/theme.dart';

extension BuildContextExtensions on BuildContext {
  EdgeInsets get systemPadding => MediaQuery.paddingOf(this);

  Size get mediaQuerySize => MediaQuery.sizeOf(this);

  AppColorScheme get colorScheme => appColorSchemeOf(this);

  Brightness get brightness => MediaQuery.platformBrightnessOf(this);

  bool get systemThemeIsDark => brightness == Brightness.dark;

  FocusScopeNode get focusScope => FocusScope.of(this);

  bool get use24Hour => MediaQuery.alwaysUse24HourFormatOf(this);
}
