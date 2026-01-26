import 'package:flutter/material.dart';

/// Định nghĩa tất cả màu sắc sử dụng trong ứng dụng
class AppColors {
  AppColors._();

  // ========== LIGHT THEME COLORS ==========

  // Primary Colors
  static const Color primaryLight = Color(0xFF0288D1);
  static const Color primaryLightVariant = Color(0xFF0277BD);
  static const Color primaryDark = Color(0xFF01579B);

  // Secondary Colors
  static const Color secondaryLight = Color(0xFF00ACC1);
  static const Color secondaryLightVariant = Color(0xFF0097A7);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Chat Colors
  static const Color chatBackgroundLight = Color(0xFFF5F5F5);
  static const Color myMessageBubbleLight = Color(0xFF0288D1);
  static const Color otherMessageBubbleLight = Color(0xFFFFFFFF);
  static const Color myMessageTextLight = Color(0xFFFFFFFF);
  static const Color otherMessageTextLight = Color(0xFF212121);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textHintLight = Color(0xFF9E9E9E);
  static const Color textDisabledLight = Color(0xFFBDBDBD);

  // ========== DARK THEME COLORS ==========

  // Primary Colors (Dark Mode)
  static const Color primaryDarkMode = Color(0xFF42A5F5);
  static const Color primaryDarkModeVariant = Color(0xFF1E88E5);

  // Background Colors (Dark Mode)
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);

  // Chat Colors (Dark Mode)
  static const Color chatBackgroundDark = Color(0xFF121212);
  static const Color myMessageBubbleDark = Color(0xFF0288D1);
  static const Color otherMessageBubbleDark = Color(0xFF2C2C2C);
  static const Color myMessageTextDark = Color(0xFFFFFFFF);
  static const Color otherMessageTextDark = Color(0xFFE0E0E0);

  // Text Colors (Dark Mode)
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textHintDark = Color(0xFF808080);
  static const Color textDisabledDark = Color(0xFF606060);

  // ========== COMMON COLORS ==========

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Online Status
  static const Color online = Color(0xFF4CAF50);
  static const Color offline = Color(0xFF9E9E9E);
  static const Color away = Color(0xFFFF9800);
  static const Color busy = Color(0xFFF44336);

  // Icon Colors
  static const Color iconActive = Color(0xFF0288D1);
  static const Color iconInactive = Color(0xFF9E9E9E);

  // Divider
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  // Shadow
  static const Color shadowLight = Color(0x1F000000);
  static const Color shadowDark = Color(0x3F000000);

  // Overlay
  static const Color overlayLight = Color(0x66000000);
  static const Color overlayDark = Color(0x99000000);

  // Chat Wallpaper Colors
  static const Color wallpaperDefault = Color(0xFFF5F5F5);
  static const Color wallpaperBlue = Color(0xFFE3F2FD);
  static const Color wallpaperGradientStart = Color(0xFFE1F5FE);
  static const Color wallpaperGradientEnd = Color(0xFFB3E5FC);

  // Message Status Colors
  static const Color messageSent = Color(0xFF9E9E9E);
  static const Color messageDelivered = Color(0xFF757575);
  static const Color messageRead = Color(0xFF0288D1);

  // Typing Indicator
  static const Color typingIndicator = Color(0xFF0288D1);

  // Link Color
  static const Color link = Color(0xFF1976D2);

  // Badge/Notification
  static const Color badgeBackground = Color(0xFFF44336);
  static const Color badgeText = Color(0xFFFFFFFF);
}
