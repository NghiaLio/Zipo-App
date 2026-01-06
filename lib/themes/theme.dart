import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color.fromRGBO(32, 160, 144, 1.0),
    secondary: Colors.white,
    surface: Color.fromRGBO(0, 14, 8, 1.0),
    onSurface: Color.fromRGBO(121, 124, 123, 1.0),
    primaryContainer: Color.fromRGBO(243, 246, 246, 1.0),
    secondaryContainer: Color.fromRGBO(222, 236, 248, 1),
    error: Color.fromRGBO(255, 45, 27, 1.0),
  ),
  scaffoldBackgroundColor: Colors.white,
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.black),
);

ThemeData getTheme(Color primaryColor, Brightness brightness) {
  return ThemeData(
    brightness: brightness,
    colorScheme: ColorScheme(
      primary: primaryColor,
      secondary: brightness == Brightness.light ? Colors.white : Colors.black,
      surface:
          brightness == Brightness.light
              ? const Color.fromRGBO(0, 14, 8, 1.0)
              : const Color.fromRGBO(254, 254, 254, 1),
      onSurface: const Color.fromRGBO(121, 124, 123, 1.0),
      primaryContainer:
          brightness == Brightness.light
              ? const Color.fromRGBO(243, 246, 246, 1.0)
              : const Color.fromRGBO(35, 35, 35, 1),
      secondaryContainer: const Color.fromRGBO(222, 236, 248, 1),
      error: const Color.fromRGBO(255, 45, 27, 1.0),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onError: Colors.white,
      brightness: brightness,
    ),
    scaffoldBackgroundColor:
        brightness == Brightness.light ? Colors.white : Colors.black,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: brightness == Brightness.light ? Colors.black : Colors.white,
    ),
  );
}
