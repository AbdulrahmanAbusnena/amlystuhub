import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeKey { lightZinc, darkSlate, midnightOled, softTeal }

enum AppFontKey { inter, poppins, outfit, roboto }

class AppThemes {
  static TextTheme _getFontTextTheme(AppFontKey fontKey, TextTheme baseTheme) {
    switch (fontKey) {
      case AppFontKey.poppins:
        return GoogleFonts.poppinsTextTheme(baseTheme);
      case AppFontKey.outfit:
        return GoogleFonts.outfitTextTheme(baseTheme);
      case AppFontKey.roboto:
        return GoogleFonts.robotoTextTheme(baseTheme);
      case AppFontKey.inter:
        return GoogleFonts.interTextTheme(baseTheme);
    }
  }

  static ThemeData buildTheme({
    required AppThemeKey themeKey,
    required AppFontKey fontKey,
  }) {
    switch (themeKey) {
      case AppThemeKey.lightZinc:
        const colorScheme = ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF2563EB),
          onPrimary: Colors.white,
          secondary: Color(0xFF475569),
          onSecondary: Colors.white,
          error: Color(0xFFDC2626),
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xFF0F172A),
          surfaceContainerHighest: Color(0xFFF1F5F9),
          onSurfaceVariant: Color(0xFF475569),
          outline: Color(0xFFE2E8F0),
          outlineVariant: Color(0xFFCBD5E1),
        );
        return _buildBaseTheme(colorScheme, fontKey, const Color(0xFFF8FAFC));

      case AppThemeKey.darkSlate:
        const colorScheme = ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF38BDF8),
          onPrimary: Color(0xFF0C4A6E),
          secondary: Color(0xFF94A3B8),
          onSecondary: Color(0xFF0F172A),
          error: Color(0xFFF87171),
          onError: Color(0xFF450A0A),
          surface: Color(0xFF0F172A),
          onSurface: Color(0xFFF8FAFC),
          surfaceContainerHighest: Color(0xFF1E293B),
          onSurfaceVariant: Color(0xFF94A3B8),
          outline: Color(0xFF334155),
          outlineVariant: Color(0xFF1E293B),
        );
        return _buildBaseTheme(colorScheme, fontKey, const Color(0xFF020617));

      case AppThemeKey.midnightOled:
        const colorScheme = ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF818CF8),
          onPrimary: Color(0xFF1E1B4B),
          secondary: Color(0xFF9CA3AF),
          onSecondary: Color(0xFF111827),
          error: Color(0xFFF87171),
          onError: Color(0xFF450A0A),
          surface: Color(0xFF111827),
          onSurface: Color(0xFFF9FAFB),
          surfaceContainerHighest: Color(0xFF1F2937),
          onSurfaceVariant: Color(0xFF9CA3AF),
          outline: Color(0xFF374151),
          outlineVariant: Color(0xFF1F2937),
        );
        return _buildBaseTheme(colorScheme, fontKey, const Color(0xFF030712));

      case AppThemeKey.softTeal:
        const colorScheme = ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF0D9488),
          onPrimary: Colors.white,
          secondary: Color(0xFF52525B),
          onSecondary: Colors.white,
          error: Color(0xFFDC2626),
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xFF09090B),
          surfaceContainerHighest: Color(0xFFF4F4F5),
          onSurfaceVariant: Color(0xFF71717A),
          outline: Color(0xFFE4E4E7),
          outlineVariant: Color(0xFFD4D4D8),
        );
        return _buildBaseTheme(colorScheme, fontKey, const Color(0xFFFAFAFA));
    }
  }

  static ThemeData _buildBaseTheme(
    ColorScheme colorScheme,
    AppFontKey fontKey,
    Color scaffoldBg,
  ) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      dialogBackgroundColor: colorScheme.surface,
    );

    final fontTextTheme = _getFontTextTheme(fontKey, base.textTheme);

    return base.copyWith(
      textTheme: fontTextTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: colorScheme.outline, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        disabledColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.5,
        ),
        selectedColor: colorScheme.primary.withValues(alpha: 0.15),
        secondarySelectedColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        labelStyle: fontTextTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: fontTextTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        brightness: colorScheme.brightness,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
