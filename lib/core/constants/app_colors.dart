import 'package:flutter/material.dart';

class LightThemeColors {
  static const primary = Color(0xFF6750A4); // Indigo
  static const secondary = Color(0xFFA1B2FF); // Light Indigo
  static const background = Color(0xFFF8F7FA); // Off-white
  static const surface = Color(0xFFFFFFFF); // White
  static const text = Color(0xFF1C1B1F); // Dark Gray
  static const textSecondary = Color(0xFF6750A4); // Indigo
  static const accent = Color(0xFFFFB300); // Amber
  static const icon = Color(0xFF6750A4); // Indigo
  static const border = Color(0xFFE6E0E9); // Light border
}

class DarkThemeColors {
  static const primary = Color(0xFFD0BCFF); // Soft Purple
  static const secondary = Color(0xFFA1B2FF); // Light Indigo
  static const background = Color(0xFF18181B); // Very Dark Gray
  static const surface = Color(0xFF23232A); // Dark Surface
  static const text = Color(0xFFE6E1E5); // Light Gray
  static const textSecondary = Color(0xFF938F99); // Secondary text
  static const accent = Color(0xFFFFD54F); // Soft Amber
  static const icon = Color(0xFFD0BCFF); // Soft Purple
  static const border = Color(0xFF49454F); // Dark border
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

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? DarkThemeColors.textSecondary
      : LightThemeColors.textSecondary;

  static Color accent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? DarkThemeColors.accent
      : LightThemeColors.accent;

  static Color icon(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? DarkThemeColors.icon
      : LightThemeColors.icon;

  static Color border(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? DarkThemeColors.border
      : LightThemeColors.border;
}
