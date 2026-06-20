import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Palette 1: Sakura Cream (Your Main Theme)
final ThemeData sakuraCreamMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFFDFBF7), // Warm cream background
  primaryColor: const Color(0xFFF08080), // Coral pink prominent button color
  cardColor: const Color(0xFFF5C0C0), // Title bar header accent pink
  textTheme: GoogleFonts.architectsDaughterTextTheme(
    ThemeData.light().textTheme,
  ),
);
