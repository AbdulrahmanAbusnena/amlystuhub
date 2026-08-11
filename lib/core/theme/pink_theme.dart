import 'package:flutter/material.dart';

final ThemeData softPinkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFEC4899),
    brightness: Brightness.light,
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF881337),
  ),
  scaffoldBackgroundColor: const Color(0xFFFFF1F2),
  cardTheme: CardThemeData(
    color: const Color(0xFFFFFFFF),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Color(0xFFFBCFE8)),
    ),
  ),
);
