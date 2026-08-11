import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'app_themes.dart';

class ThemeState {
  final AppThemeKey themeKey;
  final AppFontFamily fontFamily;

  const ThemeState({required this.themeKey, required this.fontFamily});

  ThemeState copyWith({AppThemeKey? themeKey, AppFontFamily? fontFamily}) {
    return ThemeState(
      themeKey: themeKey ?? this.themeKey,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier()
    : super(
        const ThemeState(
          themeKey: AppThemeKey.lightStandard,
          fontFamily: AppFontFamily.standard,
        ),
      );

  void setTheme(AppThemeKey key) {
    state = state.copyWith(themeKey: key);
  }

  void setFont(AppFontFamily font) {
    state = state.copyWith(fontFamily: font);
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((
  ref,
) {
  return ThemeNotifier();
});

final currentThemeProvider = Provider<ThemeData>((ref) {
  final state = ref.watch(themeNotifierProvider);
  return AppThemes.getTheme(state.themeKey, state.fontFamily);
});
