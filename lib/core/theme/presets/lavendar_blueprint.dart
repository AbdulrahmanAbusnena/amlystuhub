import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Palette 2: Classic Cyber-Deck
final ThemeData cyberDeckMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF1E1E24), // Slate dark backdrop
  primaryColor: const Color(0xFF38B2AC), // Cyber Mint / Teal
  cardColor: const Color(0xFF2D3748), // Gray frame header bar
  textTheme: GoogleFonts.architectsDaughterTextTheme(
    ThemeData.dark().textTheme,
  ),
);
