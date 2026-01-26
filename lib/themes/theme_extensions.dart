import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Extension cho BuildContext để truy cập theme dễ dàng hơn
extension ThemeExtension on BuildContext {
  // Theme Data
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  // Colors
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => theme.scaffoldBackgroundColor;
  Color get surfaceColor => colorScheme.surface;
  Color get errorColor => colorScheme.error;

  // Text Colors
  Color get textPrimary =>
      isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  Color get textSecondary =>
      isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
  Color get textHint =>
      isDarkMode ? AppColors.textHintDark : AppColors.textHintLight;

  // Chat Colors
  Color get myMessageBubble =>
      isDarkMode
          ? AppColors.myMessageBubbleDark
          : AppColors.myMessageBubbleLight;
  Color get otherMessageBubble =>
      isDarkMode
          ? AppColors.otherMessageBubbleDark
          : AppColors.otherMessageBubbleLight;
  Color get myMessageText =>
      isDarkMode ? AppColors.myMessageTextDark : AppColors.myMessageTextLight;
  Color get otherMessageText =>
      isDarkMode
          ? AppColors.otherMessageTextDark
          : AppColors.otherMessageTextLight;

  // Status Colors
  Color get successColor => AppColors.success;
  Color get warningColor => AppColors.warning;
  Color get infoColor => AppColors.info;

  // Divider
  Color get dividerColor =>
      isDarkMode ? AppColors.dividerDark : AppColors.dividerLight;

  // Check if dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // Text Styles
  TextStyle? get h1 => textTheme.displayLarge;
  TextStyle? get h2 => textTheme.displayMedium;
  TextStyle? get h3 => textTheme.displaySmall;
  TextStyle? get h4 => textTheme.headlineMedium;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get subtitle1 => textTheme.titleMedium;
  TextStyle? get subtitle2 => textTheme.titleSmall;
  TextStyle? get caption => textTheme.labelSmall;
  TextStyle? get button => textTheme.labelLarge;

  // Custom Text Styles
  TextStyle get appBarTitle =>
      isDarkMode
          ? AppTextStyles.appBarTitleDark
          : AppTextStyles.appBarTitleLight;
  TextStyle get sectionTitle =>
      isDarkMode
          ? AppTextStyles.sectionTitleDark
          : AppTextStyles.sectionTitleLight;
  TextStyle get messageMyStyle =>
      isDarkMode ? AppTextStyles.messageMyDark : AppTextStyles.messageMyLight;
  TextStyle get messageOtherStyle =>
      isDarkMode
          ? AppTextStyles.messageOtherDark
          : AppTextStyles.messageOtherLight;
  TextStyle get messageTime =>
      isDarkMode
          ? AppTextStyles.messageTimeDark
          : AppTextStyles.messageTimeLight;
  TextStyle get chatName =>
      isDarkMode ? AppTextStyles.chatNameDark : AppTextStyles.chatNameLight;
  TextStyle get chatPreview =>
      isDarkMode
          ? AppTextStyles.chatPreviewDark
          : AppTextStyles.chatPreviewLight;

  // Media Query
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  // Responsive
  bool get isSmallScreen => screenWidth < 600;
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 900;
  bool get isLargeScreen => screenWidth >= 900;
}

/// Extension cho Color
extension ColorExtension on Color {
  /// Làm sáng màu
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }

  /// Làm tối màu
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  /// Chuyển đổi sang hex string
  String toHex({bool leadingHashSign = true}) {
    return '${leadingHashSign ? '#' : ''}'
        '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }
}
