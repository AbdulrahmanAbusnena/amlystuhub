import 'package:flutter/material.dart';

final ThemeData lightStandardTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2563EB),
    brightness: Brightness.light,
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF0F172A),
  ),
  scaffoldBackgroundColor: const Color(0xFFF8FAFC),
  cardTheme: CardThemeData(
    color: const Color(0xFFFFFFFF),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
  ),
);
