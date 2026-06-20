import 'package:flutter/material.dart';

class RetroThemeExtension extends ThemeExtension<RetroThemeExtension> {
  final Color windowHeaderColor;
  final Color inputFillColor;
  final String crtCatAsset;
  final String customFontFamily;
  final bool enableBlockShadows;

  RetroThemeExtension({
    required this.windowHeaderColor,
    required this.inputFillColor,
    required this.crtCatAsset,
    required this.customFontFamily,
    required this.enableBlockShadows,
  });

  @override
  RetroThemeExtension copyWith({
    Color? windowHeaderColor,
    Color? inputFillColor,
    String? crtCatAsset,
    String? customFontFamily,
    bool? enableBlockShadows,
  }) {
    return RetroThemeExtension(
      windowHeaderColor: windowHeaderColor ?? this.windowHeaderColor,
      inputFillColor: inputFillColor ?? this.inputFillColor,
      crtCatAsset: crtCatAsset ?? this.crtCatAsset,
      customFontFamily: customFontFamily ?? this.customFontFamily,
      enableBlockShadows: enableBlockShadows ?? this.enableBlockShadows,
    );
  }

  @override
  RetroThemeExtension lerp(
    ThemeExtension<RetroThemeExtension>? other,
    double t,
  ) {
    if (other is! RetroThemeExtension) return this;
    return RetroThemeExtension(
      windowHeaderColor:
          Color.lerp(windowHeaderColor, other.windowHeaderColor, t) ??
          windowHeaderColor,
      inputFillColor:
          Color.lerp(inputFillColor, other.inputFillColor, t) ?? inputFillColor,
      crtCatAsset: other.crtCatAsset,
      customFontFamily: other.customFontFamily,
      enableBlockShadows: t < 0.5
          ? enableBlockShadows
          : other.enableBlockShadows,
    );
  }
}
