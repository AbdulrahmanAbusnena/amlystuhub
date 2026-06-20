import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Palette 3: Lavender Blueprint
final ThemeData lavenderBlueprintMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF0F2FA), // Lavender ice canvas
  primaryColor: const Color(0xFF7B61FF), // Deep violet button color
  cardColor: const Color(0xFFD6DBF9), // Pastel lavender title bar
  textTheme: GoogleFonts.architectsDaughterTextTheme(
    ThemeData.light().textTheme,
  ),
);
