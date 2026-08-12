import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum AppThemeMode { light, dark }

class AppThemes {
  // Primary typography setup using standard desktop/web font fallbacks
  static const String bodyFont = 'Calibri';
  static const String serifFont = 'Times New Roman';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: bodyFont,
      fontFamilyFallback: const ['Segoe UI', 'Arial', 'sans-serif'],
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1E3A8A), // Deep Slate Blue
        secondary: Color(0xFF0284C7), // Accent Sky Blue
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF0F172A),
        error: Color(0xFFDC2626),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontFamily: serifFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
        titleLarge: TextStyle(
          fontFamily: serifFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
        bodyLarge: TextStyle(fontFamily: bodyFont, fontSize: 16),
        bodyMedium: TextStyle(fontFamily: bodyFont, fontSize: 14),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: bodyFont,
      fontFamilyFallback: const ['Segoe UI', 'Arial', 'sans-serif'],
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF60A5FA),
        secondary: Color(0xFF38BDF8),
        surface: Color(0xFF1E293B),
        onSurface: Color(0xFFF8FAFC),
        error: Color(0xFFF87171),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E293B),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF334155)),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontFamily: serifFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF8FAFC),
        ),
        titleLarge: TextStyle(
          fontFamily: serifFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF8FAFC),
        ),
        bodyLarge: TextStyle(fontFamily: bodyFont, fontSize: 16),
        bodyMedium: TextStyle(fontFamily: bodyFont, fontSize: 14),
      ),
    );
  }
}

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.light);

  void toggleTheme() {
    state = state == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
  }

  void setTheme(AppThemeMode mode) {
    state = mode;
  }
}

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
      return ThemeNotifier();
    });

final currentThemeProvider = Provider<ThemeData>((ref) {
  final mode = ref.watch(themeNotifierProvider);
  return mode == AppThemeMode.light
      ? AppThemes.lightTheme
      : AppThemes.darkTheme;
});
