import 'package:flutter/material.dart';
import '../theme_extension.dart';

final sakuraCreamTheme =
    ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(
        0xFFFDFBF7,
      ), // Warm creamy oatmeal background
      primaryColor: const Color(
        0xFFE5A4A4,
      ), // Muted pastel coral/pink for main button
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black,
      ),
    ).copyWith(
      extensions: [
        RetroThemeExtension(
          windowHeaderColor: const Color(0xFFF5C0C0), // Soft pink title bar
          inputFillColor: Colors.white,
          crtCatAsset: 'assets/images/peeking_cat_monitor.png',
          customFontFamily:
              'Excalifont', // Sketchy custom hand-drawn font package
          enableBlockShadows: true,
        ),
      ],
    );
