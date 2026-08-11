import 'package:/flutter/material.dart';

final ThemeData darkSlateTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF38BDF8),
    brightness: Brightness.dark,
    surface: const Color(0xFF1E293B),
    onSurface: const Color(0xFFF8FAFC),
  ),
  scaffoldBackgroundColor: const Color(0xFF0F172A),
  cardTheme: CardThemeData(
    color: const Color(0xFF1E293B),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Color(0xFF334155)),
    ),
  ),
);
