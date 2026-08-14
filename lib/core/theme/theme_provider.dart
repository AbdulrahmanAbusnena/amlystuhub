import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'app_themes.dart';

class ThemeSettings {
  final AppThemeKey themeKey;
  final AppFontKey fontKey;

  const ThemeSettings({
    this.themeKey = AppThemeKey.softTeal,
    this.fontKey = AppFontKey.poppins,
  });

  ThemeSettings copyWith({AppThemeKey? themeKey, AppFontKey? fontKey}) {
    return ThemeSettings(
      themeKey: themeKey ?? this.themeKey,
      fontKey: fontKey ?? this.fontKey,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeSettings> {
  ThemeNotifier() : super(const ThemeSettings());

  void setTheme(AppThemeKey themeKey) {
    state = state.copyWith(themeKey: themeKey);
  }

  void setFont(AppFontKey fontKey) {
    state = state.copyWith(fontKey: fontKey);
  }
}

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeSettings>((ref) {
      return ThemeNotifier();
    });

final currentThemeProvider = Provider<ThemeData>((ref) {
  final settings = ref.watch(themeNotifierProvider);
  return AppThemes.buildTheme(
    themeKey: settings.themeKey,
    fontKey: settings.fontKey,
  );
});
