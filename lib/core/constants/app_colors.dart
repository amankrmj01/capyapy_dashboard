import 'package:flutter/material.dart';

class LightThemeColors {
  static const primary = Color(0xFF6750A4); // Indigo
  static const secondary = Color(0xFFA1B2FF); // Light Indigo
  static const background = Color(0xFFF8F7FA); // Off-white
  static const surface = Color(0xFFFFFFFF); // White
  static const text = Color(0xFF1C1B1F); // Dark Gray
  static const accent = Color(0xFFFFB300); // Amber
  static const icon = Color(0xFF6750A4); // Indigo
}

class DarkThemeColors {
  static const primary = Color(0xFFD0BCFF); // Soft Purple
  static const secondary = Color(0xFFA1B2FF); // Light Indigo
  static const background = Color(0xFF18181B); // Very Dark Gray
  static const surface = Color(0xFF23232A); // Dark Surface
  static const text = Color(0xFFE6E1E5); // Light Gray
  static const accent = Color(0xFFFFD54F); // Soft Amber
  static const icon = Color(0xFFD0BCFF); // Soft Purple
}

class AppColors {
  static Color primary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? DarkThemeColors.primary
      : LightThemeColors.primary;

  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? DarkThemeColors.background
      : LightThemeColors.background;

  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? DarkThemeColors.surface
      : LightThemeColors.surface;

  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? DarkThemeColors.text
      : LightThemeColors.text;

  static Color accent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? DarkThemeColors.accent
      : LightThemeColors.accent;

  static Color icon(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? DarkThemeColors.icon
      : LightThemeColors.icon;

  static Color secondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? DarkThemeColors.secondary
      : LightThemeColors.secondary;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? DarkThemeColors.text.withAlpha(180)
      : LightThemeColors.text.withAlpha(180);
}
