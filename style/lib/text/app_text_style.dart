import 'package:flutter/material.dart' show TextStyle, FontWeight;

class AppTextStyles {
  static const TextStyle header1 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 24,
    fontFamily: AppFontFamilies.inter,
    package: 'style',
  );

  static const TextStyle header2 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 22,
    fontFamily: AppFontFamilies.inter,
    package: 'style',
  );

  static const TextStyle header3 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    fontFamily: AppFontFamilies.inter,
    package: 'style',
  );

  static const TextStyle header4 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    fontFamily: AppFontFamilies.inter,
    package: 'style',
  );

  static const TextStyle subtitle1 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    fontFamily: AppFontFamilies.inter,
    package: 'style',
  );

  static const TextStyle subtitle2 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    fontFamily: AppFontFamilies.inter,
    package: 'style',
  );

  static const TextStyle button = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    fontFamily: AppFontFamilies.inter,
    package: 'style',
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 17,
    fontFamily: AppFontFamilies.inter,
    package: 'style',
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontFamily: AppFontFamilies.inter,
    package: 'style',
  );

  static const TextStyle bodyBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    fontFamily: AppFontFamilies.inter,
    package: 'style',
  );

  static const TextStyle body2 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    fontFamily: AppFontFamilies.inter,
    package: 'style',
  );

  static const TextStyle caption = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    fontFamily: AppFontFamilies.inter,
    package: 'style',
  );
}

class AppFontFamilies {
  static const String inter = 'Inter';
}
