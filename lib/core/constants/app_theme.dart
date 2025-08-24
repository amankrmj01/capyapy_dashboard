import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: LightThemeColors.primary,
    scaffoldBackgroundColor: LightThemeColors.background,
    colorScheme: ColorScheme.light(
      primary: LightThemeColors.primary,
      surface: LightThemeColors.surface,
      secondary: LightThemeColors.accent,
      onPrimary: LightThemeColors.text,
      onSurface: LightThemeColors.text,
      onSecondary: LightThemeColors.text,
    ),
    iconTheme: IconThemeData(color: LightThemeColors.icon),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: LightThemeColors.text),
      bodyMedium: TextStyle(color: LightThemeColors.text),
      bodySmall: TextStyle(color: LightThemeColors.text),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: LightThemeColors.surface,
      iconTheme: IconThemeData(color: LightThemeColors.icon),
      titleTextStyle: TextStyle(
        color: LightThemeColors.text,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: DarkThemeColors.primary,
    scaffoldBackgroundColor: DarkThemeColors.background,
    colorScheme: ColorScheme.dark(
      primary: DarkThemeColors.primary,
      surface: DarkThemeColors.surface,
      secondary: DarkThemeColors.accent,
      onPrimary: DarkThemeColors.text,
      onSurface: DarkThemeColors.text,
      onSecondary: DarkThemeColors.text,
    ),
    iconTheme: IconThemeData(color: DarkThemeColors.icon),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: DarkThemeColors.text),
      bodyMedium: TextStyle(color: DarkThemeColors.text),
      bodySmall: TextStyle(color: DarkThemeColors.text),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: DarkThemeColors.surface,
      iconTheme: IconThemeData(color: DarkThemeColors.icon),
      titleTextStyle: TextStyle(
        color: DarkThemeColors.text,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
