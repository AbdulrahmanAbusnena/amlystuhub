import 'package:amlystuhub/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

enum AppThemeKey { lightStandard, darkSlate, midnightBlue, softPink }

enum AppFontFamily {
  standard, // System / Inter
  handwriting, // Architectural / Casual handwriting font style
  monospace, // Technical / Structured
}

class AppThemes {
  static String? _getFontFamily(AppFontFamily font) {
    switch (font) {
      case AppFontFamily.handwriting:
        return 'Caveat'; // Or your designated display font family name
      case AppFontFamily.monospace:
        return 'JetBrains Mono';
      case AppFontFamily.standard:
        return null; // Uses system default (Roboto / SF Pro)
    }
  }

  static ThemeData getTheme(AppThemeKey key, AppFontFamily fontFamily) {
    final font = _getFontFamily(fontFamily);

    switch (key) {
      case AppThemeKey.lightStandard:
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          fontFamily: font,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB),
            primary: const Color(0xFF2563EB),
            secondary: const Color(0xFF0EA5E9),
            tertiary: const Color(0xFF8B5CF6),
            surface: const Color(0xFFFFFFFF),
            surfaceContainerHighest: const Color(0xFFF1F5F9),
            onSurface: const Color(0xFF0F172A),
          ),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          extensions: [
            AppCustomTheme(
              badgeBackground: const Color(0xFFDBEAFE),
              badgeText: const Color(0xFF1E40AF),
              urgentAccent: const Color(0xFFEF4444),
              secondaryAccent: const Color(0xFF38BDF8),
              headlineFont: TextStyle(
                fontFamily: font,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );

      case AppThemeKey.darkSlate:
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          fontFamily: font,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF38BDF8),
            brightness: Brightness.dark,
            primary: const Color(0xFF38BDF8),
            secondary: const Color(0xFF818CF8),
            tertiary: const Color(0xFFF472B6),
            surface: const Color(0xFF1E293B),
            surfaceContainerHighest: const Color(0xFF334155),
            onSurface: const Color(0xFFF8FAFC),
          ),
          scaffoldBackgroundColor: const Color(0xFF0F172A),
          cardTheme: CardThemeData(
            color: const Color(0xFF1E293B),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF334155)),
            ),
          ),
          extensions: [
            AppCustomTheme(
              badgeBackground: const Color(0xFF0C4A6E),
              badgeText: const Color(0xFFBAE6FD),
              urgentAccent: const Color(0xFFF87171),
              secondaryAccent: const Color(0xFF818CF8),
              headlineFont: TextStyle(
                fontFamily: font,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );

      case AppThemeKey.midnightBlue:
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          fontFamily: font,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.dark,
            primary: const Color(0xFF6366F1),
            secondary: const Color(0xFF06B6D4),
            tertiary: const Color(0xFFA855F7),
            surface: const Color(0xFF0B132B),
            surfaceContainerHighest: const Color(0xFF1C2541),
            onSurface: const Color(0xFFE0E6ED),
          ),
          scaffoldBackgroundColor: const Color(0xFF050814),
          cardTheme: CardThemeData(
            color: const Color(0xFF0B132B),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF1C2541)),
            ),
          ),
          extensions: [
            AppCustomTheme(
              badgeBackground: const Color(0xFF1E1B4B),
              badgeText: const Color(0xFFC7D2FE),
              urgentAccent: const Color(0xFFFF5A5F),
              secondaryAccent: const Color(0xFF06B6D4),
              headlineFont: TextStyle(
                fontFamily: font,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );

      case AppThemeKey.softPink:
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          fontFamily: font,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFEC4899),
            brightness: Brightness.light,
            primary: const Color(0xFFEC4899),
            secondary: const Color(0xFFF43F5E),
            tertiary: const Color(0xFFA855F7),
            surface: const Color(0xFFFFFFFF),
            surfaceContainerHighest: const Color(0xFFFCE7F3),
            onSurface: const Color(0xFF881337),
          ),
          scaffoldBackgroundColor: const Color(0xFFFFF1F2),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFFBCFE8)),
            ),
          ),
          extensions: [
            AppCustomTheme(
              badgeBackground: const Color(0xFFFCE7F3),
              badgeText: const Color(0xFFBE185D),
              urgentAccent: const Color(0xFFE11D48),
              secondaryAccent: const Color(0xFFF43F5E),
              headlineFont: TextStyle(
                fontFamily: font,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
    }
  }
}
