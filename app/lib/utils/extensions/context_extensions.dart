import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension BuildContextExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  EdgeInsets get systemPadding => MediaQuery.of(this).padding;
  Size get mediaQuerySize => MediaQuery.of(this).size;
}
