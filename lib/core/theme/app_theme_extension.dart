import 'package:flutter/material.dart';

class AppCustomTheme extends ThemeExtension<AppCustomTheme> {
  final Color badgeBackground;
  final Color badgeText;
  final Color urgentAccent;
  final Color secondaryAccent;
  final TextStyle headlineFont;

  AppCustomTheme({
    required this.badgeBackground,
    required this.badgeText,
    required this.urgentAccent,
    required this.secondaryAccent,
    required this.headlineFont,
  });

  @override
  AppCustomTheme copyWith({
    Color? badgeBackground,
    Color? badgeText,
    Color? urgentAccent,
    Color? secondaryAccent,
    TextStyle? headlineFont,
  }) {
    return AppCustomTheme(
      badgeBackground: badgeBackground ?? this.badgeBackground,
      badgeText: badgeText ?? this.badgeText,
      urgentAccent: urgentAccent ?? this.urgentAccent,
      secondaryAccent: secondaryAccent ?? this.secondaryAccent,
      headlineFont: headlineFont ?? this.headlineFont,
    );
  }

  @override
  AppCustomTheme lerp(ThemeExtension<AppCustomTheme>? other, double t) {
    if (other is! AppCustomTheme) return this;
    return AppCustomTheme(
      badgeBackground: Color.lerp(badgeBackground, other.badgeBackground, t)!,
      badgeText: Color.lerp(badgeText, other.badgeText, t)!,
      urgentAccent: Color.lerp(urgentAccent, other.urgentAccent, t)!,
      secondaryAccent: Color.lerp(secondaryAccent, other.secondaryAccent, t)!,
      headlineFont: TextStyle.lerp(headlineFont, other.headlineFont, t)!,
    );
  }
}
