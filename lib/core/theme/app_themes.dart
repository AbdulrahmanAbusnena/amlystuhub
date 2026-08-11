import 'package:amlystuhub/core/theme/light_theme.dart';
import 'package:amlystuhub/core/theme/pink_theme.dart';
import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'midnight_theme.dart';

enum AppThemeKey { lightStandard, darkSlate, midnightBlue, softPink }

class AppThemes {
  static ThemeData getTheme(AppThemeKey key) {
    switch (key) {
      case AppThemeKey.lightStandard:
        return lightStandardTheme;
      case AppThemeKey.darkSlate:
        return darkSlateTheme;
      case AppThemeKey.midnightBlue:
        return midnightBlueTheme;
      case AppThemeKey.softPink:
        return softPinkTheme;
    }
  }
}
