import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Định nghĩa tất cả text styles sử dụng trong ứng dụng
class AppTextStyles {
  AppTextStyles._();

  // ========== FONT SIZES ==========
  static const double fontSizeXSmall = 11.0;
  static const double fontSizeSmall = 13.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeNormal = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeTitle = 28.0;

  // ========== FONT WEIGHTS ==========
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // ========== LIGHT THEME TEXT STYLES ==========

  // Headers
  static const TextStyle h1Light = TextStyle(
    fontSize: fontSizeTitle,
    fontWeight: bold,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.5,
  );

  static const TextStyle h2Light = TextStyle(
    fontSize: fontSizeXXLarge,
    fontWeight: bold,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle h3Light = TextStyle(
    fontSize: fontSizeXLarge,
    fontWeight: semiBold,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle h4Light = TextStyle(
    fontSize: fontSizeLarge,
    fontWeight: semiBold,
    color: AppColors.textPrimaryLight,
  );

  // Body Text
  static const TextStyle bodyLargeLight = TextStyle(
    fontSize: fontSizeNormal,
    fontWeight: regular,
    color: AppColors.textPrimaryLight,
    height: 1.5,
  );

  static const TextStyle bodyMediumLight = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: regular,
    color: AppColors.textPrimaryLight,
    height: 1.5,
  );

  static const TextStyle bodySmallLight = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: regular,
    color: AppColors.textSecondaryLight,
    height: 1.4,
  );

  // Subtitles
  static const TextStyle subtitle1Light = TextStyle(
    fontSize: fontSizeNormal,
    fontWeight: medium,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle subtitle2Light = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: medium,
    color: AppColors.textSecondaryLight,
  );

  // Captions
  static const TextStyle captionLight = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: regular,
    color: AppColors.textSecondaryLight,
  );

  static const TextStyle overlineLight = TextStyle(
    fontSize: fontSizeXSmall,
    fontWeight: medium,
    color: AppColors.textSecondaryLight,
    letterSpacing: 0.5,
  );

  // Buttons
  static const TextStyle buttonLight = TextStyle(
    fontSize: fontSizeNormal,
    fontWeight: semiBold,
    color: AppColors.surfaceLight,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonSmallLight = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: semiBold,
    color: AppColors.surfaceLight,
  );

  // ========== DARK THEME TEXT STYLES ==========

  // Headers
  static const TextStyle h1Dark = TextStyle(
    fontSize: fontSizeTitle,
    fontWeight: bold,
    color: AppColors.textPrimaryDark,
    letterSpacing: -0.5,
  );

  static const TextStyle h2Dark = TextStyle(
    fontSize: fontSizeXXLarge,
    fontWeight: bold,
    color: AppColors.textPrimaryDark,
  );

  static const TextStyle h3Dark = TextStyle(
    fontSize: fontSizeXLarge,
    fontWeight: semiBold,
    color: AppColors.textPrimaryDark,
  );

  static const TextStyle h4Dark = TextStyle(
    fontSize: fontSizeLarge,
    fontWeight: semiBold,
    color: AppColors.textPrimaryDark,
  );

  // Body Text
  static const TextStyle bodyLargeDark = TextStyle(
    fontSize: fontSizeNormal,
    fontWeight: regular,
    color: AppColors.textPrimaryDark,
    height: 1.5,
  );

  static const TextStyle bodyMediumDark = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: regular,
    color: AppColors.textPrimaryDark,
    height: 1.5,
  );

  static const TextStyle bodySmallDark = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: regular,
    color: AppColors.textSecondaryDark,
    height: 1.4,
  );

  // Subtitles
  static const TextStyle subtitle1Dark = TextStyle(
    fontSize: fontSizeNormal,
    fontWeight: medium,
    color: AppColors.textPrimaryDark,
  );

  static const TextStyle subtitle2Dark = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: medium,
    color: AppColors.textSecondaryDark,
  );

  // Captions
  static const TextStyle captionDark = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: regular,
    color: AppColors.textSecondaryDark,
  );

  static const TextStyle overlineDark = TextStyle(
    fontSize: fontSizeXSmall,
    fontWeight: medium,
    color: AppColors.textSecondaryDark,
    letterSpacing: 0.5,
  );

  // Buttons
  static const TextStyle buttonDark = TextStyle(
    fontSize: fontSizeNormal,
    fontWeight: semiBold,
    color: AppColors.surfaceDark,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonSmallDark = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: semiBold,
    color: AppColors.surfaceDark,
  );

  // ========== CHAT SPECIFIC TEXT STYLES ==========

  // Message Text
  static const TextStyle messageMyLight = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: regular,
    color: AppColors.myMessageTextLight,
    height: 1.4,
  );

  static const TextStyle messageOtherLight = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: regular,
    color: AppColors.otherMessageTextLight,
    height: 1.4,
  );

  static const TextStyle messageMyDark = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: regular,
    color: AppColors.myMessageTextDark,
    height: 1.4,
  );

  static const TextStyle messageOtherDark = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: regular,
    color: AppColors.otherMessageTextDark,
    height: 1.4,
  );

  // Message Time
  static const TextStyle messageTimeLight = TextStyle(
    fontSize: fontSizeXSmall,
    fontWeight: regular,
    color: AppColors.textHintLight,
  );

  static const TextStyle messageTimeDark = TextStyle(
    fontSize: fontSizeXSmall,
    fontWeight: regular,
    color: AppColors.textHintDark,
  );

  // Chat Name
  static const TextStyle chatNameLight = TextStyle(
    fontSize: fontSizeNormal,
    fontWeight: semiBold,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle chatNameDark = TextStyle(
    fontSize: fontSizeNormal,
    fontWeight: semiBold,
    color: AppColors.textPrimaryDark,
  );

  // Chat Preview
  static const TextStyle chatPreviewLight = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: regular,
    color: AppColors.textSecondaryLight,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle chatPreviewDark = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: regular,
    color: AppColors.textSecondaryDark,
    overflow: TextOverflow.ellipsis,
  );

  // Typing Indicator
  static const TextStyle typingLight = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: regular,
    color: AppColors.typingIndicator,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle typingDark = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: regular,
    color: AppColors.typingIndicator,
    fontStyle: FontStyle.italic,
  );

  // ========== SPECIAL TEXT STYLES ==========

  // App Bar Title
  static const TextStyle appBarTitleLight = TextStyle(
    fontSize: fontSizeXLarge,
    fontWeight: bold,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle appBarTitleDark = TextStyle(
    fontSize: fontSizeXLarge,
    fontWeight: bold,
    color: AppColors.textPrimaryDark,
  );

  // Section Title
  static const TextStyle sectionTitleLight = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: semiBold,
    color: AppColors.textSecondaryLight,
    letterSpacing: 0.5,
  );

  static const TextStyle sectionTitleDark = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: semiBold,
    color: AppColors.textSecondaryDark,
    letterSpacing: 0.5,
  );

  // Link
  static const TextStyle link = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: regular,
    color: AppColors.link,
    decoration: TextDecoration.underline,
  );

  // Error Text
  static const TextStyle error = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: regular,
    color: AppColors.error,
  );

  // Success Text
  static const TextStyle success = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: regular,
    color: AppColors.success,
  );
}
