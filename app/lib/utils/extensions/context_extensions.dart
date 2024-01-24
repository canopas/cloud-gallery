import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:style/theme/theme.dart';

extension BuildContextExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  EdgeInsets get systemPadding => MediaQuery.of(this).padding;

  Size get mediaQuerySize => MediaQuery.of(this).size;

  AppColorScheme get colorScheme => appColorSchemeOf(this);

  Brightness get brightness => MediaQuery.of(this).platformBrightness;

  bool get isDarkMode => brightness == Brightness.dark;

  FocusScopeNode get focusScope => FocusScope.of(this);

  bool get use24Hour => MediaQuery.of(this).alwaysUse24HourFormat;
}
