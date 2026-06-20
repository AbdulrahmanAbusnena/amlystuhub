import 'package:flutter/material.dart';
import '../theme_extension.dart';

final cyberDeckTheme =
    ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(
        0xFF1E1E24,
      ), // Slate dark gray canvas
      primaryColor: const Color(0xFF38B2AC), // Cyber Mint/Teal
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
    ).copyWith(
      extensions: [
        RetroThemeExtension(
          windowHeaderColor: const Color(
            0xFF2D3748,
          ), // Deep hardware gray header
          inputFillColor: const Color(0xFF1A202C),
          crtCatAsset: 'assets/images/cyber_cat.png',
          customFontFamily: 'CourierPrime', // Fixed-width terminal font
          enableBlockShadows: false,
        ),
      ],
    );
