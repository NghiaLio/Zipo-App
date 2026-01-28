import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maintain_chat_app/themes/app_colors.dart';
import 'package:maintain_chat_app/themes/app_text_styles.dart';

class AppTheme {
  // Factory method to generate ThemeData dynamically
  static ThemeData lightTheme({
    required Color selectedItemColor,
    double fontSize = 16.0,
  }) {
    return ThemeData(
      brightness: Brightness.light,
      disabledColor: const Color(0xFF606060),
      colorScheme: ColorScheme.light(
        primary: selectedItemColor,
        primaryContainer: AppColors.primaryLightVariant,
        secondary: AppColors.secondaryLight,
        secondaryContainer: AppColors.secondaryLightVariant,
        surface: AppColors.surfaceLight,
        background: AppColors.surfaceLight,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
        onError: Colors.white,
      ),
      // Scaffold
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
        titleTextStyle: TextStyle(
          fontSize: fontSize + 2,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: fontSize + 2,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryLight,
        ),
        bodyLarge: TextStyle(
          fontSize: fontSize,
          color: AppColors.textPrimaryLight,
        ),
        bodyMedium: TextStyle(
          fontSize: fontSize - 2,
          color: AppColors.textPrimaryLight,
        ),
        bodySmall: TextStyle(
          fontSize: fontSize - 4,
          color: AppColors.textPrimaryLight,
        ),
        titleMedium: TextStyle(
          fontSize: fontSize,
          color: AppColors.textPrimaryLight,
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.iconInactive,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: AppTextStyles.h4Light,
        contentTextStyle: AppTextStyles.bodyMediumLight,
      ),
      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData darkTheme({
    required Color selectedItemColor,
    double fontSize = 16.0,
  }) {
    return ThemeData(
      brightness: Brightness.light,
      disabledColor: const Color(0xFF606060),
      colorScheme: ColorScheme.light(
        primary: selectedItemColor,
        primaryContainer: AppColors.primaryDarkModeVariant,
        secondary: AppColors.secondaryLight,
        secondaryContainer: AppColors.secondaryLightVariant,
        surface: AppColors.surfaceDark,
        background: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryDark,
        onError: Colors.white,
      ),
      // Scaffold
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
        titleTextStyle: TextStyle(
          fontSize: fontSize + 2,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: fontSize + 2,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryDark,
        ),
        bodyLarge: TextStyle(
          fontSize: fontSize,
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: TextStyle(
          fontSize: fontSize - 2,
          color: AppColors.textPrimaryDark,
        ),
        bodySmall: TextStyle(
          fontSize: fontSize - 4,
          color: AppColors.textPrimaryDark,
        ),
        titleMedium: TextStyle(
          fontSize: fontSize,
          color: AppColors.textPrimaryDark,
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primaryDarkMode,
        unselectedItemColor: AppColors.iconInactive,
        elevation: 8,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimaryDark,
          height: 1.5,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
