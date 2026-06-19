import 'package:flutter/material.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final String registrationGif;
  final String fontName;
  final bool showDotMatrix;
  final bool useSketchyBorders;
  final Color customAccent;

  AppThemeExtension({
    required this.registrationGif,
    required this.fontName,
    required this.showDotMatrix,
    required this.useSketchyBorders,
    required this.customAccent,
  });

  @override
  AppThemeExtension copyWith({
    String? registrationGif,
    String? fontName,
    bool? showDotMatrix,
    bool? useSketchyBorders,
    Color? customAccent,
  }) {
    return AppThemeExtension(
      registrationGif: registrationGif ?? this.registrationGif,
      fontName: fontName ?? this.fontName,
      showDotMatrix: showDotMatrix ?? this.showDotMatrix,
      useSketchyBorders: useSketchyBorders ?? this.useSketchyBorders,
      customAccent: customAccent ?? this.customAccent,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      registrationGif: other.registrationGif,
      fontName: other.fontName,
      showDotMatrix: t < 0.5 ? showDotMatrix : other.showDotMatrix,
      useSketchyBorders: t < 0.5 ? useSketchyBorders : other.useSketchyBorders,
      customAccent:
          Color.lerp(customAccent, other.customAccent, t) ?? customAccent,
    );
  }
}
