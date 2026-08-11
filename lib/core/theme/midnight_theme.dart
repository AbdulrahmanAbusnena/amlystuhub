import 'package:flutter/material.dart';

final ThemeData midnightBlueTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6366F1),
    brightness: Brightness.dark,
    surface: const Color(0xFF0B132B),
    onSurface: const Color(0xFFE0E6ED),
  ),
  scaffoldBackgroundColor: const Color(0xFF050814),
  cardTheme: CardThemeData(
    color: const Color(0xFF0B132B),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Color(0xFF1C2541)),
    ),
  ),
);
