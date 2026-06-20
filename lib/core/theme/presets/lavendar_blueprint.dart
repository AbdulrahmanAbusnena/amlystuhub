import 'package:flutter/material.dart';
import '../theme_extension.dart';

final lavenderBlueprintTheme =
    ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF0F2FA), // Ice/Lavender base
      primaryColor: const Color(0xFF7B61FF), // Deep lavender violet
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black,
      ),
    ).copyWith(
      extensions: [
        RetroThemeExtension(
          windowHeaderColor: const Color(0xFFD6DBF9), // Pastel lavender header
          inputFillColor: Colors.white,
          crtCatAsset: 'assets/images/blueprint_cat.png',
          customFontFamily: 'Excalifont',
          enableBlockShadows: true,
        ),
      ],
    );
