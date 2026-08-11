import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'app_themes.dart';

class ThemeNotifier extends StateNotifier<AppThemeKey> {
  ThemeNotifier() : super(AppThemeKey.lightStandard);

  void setTheme(AppThemeKey key) {
    state = key;
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppThemeKey>(
  (ref) {
    return ThemeNotifier();
  },
);

final currentThemeProvider = Provider<ThemeData>((ref) {
  final activeKey = ref.watch(themeNotifierProvider);
  return AppThemes.getTheme(activeKey);
});
