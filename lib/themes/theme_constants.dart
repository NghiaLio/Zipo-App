import 'package:flutter/material.dart';

/// Các hằng số liên quan đến theme và UI
class ThemeConstants {
  ThemeConstants._();

  // ========== BORDER RADIUS ==========
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 10.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  static const double radiusCircular = 50.0;

  static BorderRadius borderRadiusSmall = BorderRadius.circular(radiusSmall);
  static BorderRadius borderRadiusMedium = BorderRadius.circular(radiusMedium);
  static BorderRadius borderRadiusLarge = BorderRadius.circular(radiusLarge);
  static BorderRadius borderRadiusXLarge = BorderRadius.circular(radiusXLarge);
  static BorderRadius borderRadiusCircular = BorderRadius.circular(
    radiusCircular,
  );

  // Message Bubble Radius
  static const BorderRadius messageBubbleMyRadius = BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
    bottomLeft: Radius.circular(16),
    bottomRight: Radius.circular(4),
  );

  static const BorderRadius messageBubbleOtherRadius = BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
    bottomLeft: Radius.circular(4),
    bottomRight: Radius.circular(16),
  );

  // ========== SPACING ==========
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingNormal = 16.0;
  static const double spacingLarge = 20.0;
  static const double spacingXLarge = 24.0;
  static const double spacingXXLarge = 32.0;

  // ========== PADDING ==========
  static const EdgeInsets paddingXSmall = EdgeInsets.all(spacingXSmall);
  static const EdgeInsets paddingSmall = EdgeInsets.all(spacingSmall);
  static const EdgeInsets paddingMedium = EdgeInsets.all(spacingMedium);
  static const EdgeInsets paddingNormal = EdgeInsets.all(spacingNormal);
  static const EdgeInsets paddingLarge = EdgeInsets.all(spacingLarge);
  static const EdgeInsets paddingXLarge = EdgeInsets.all(spacingXLarge);

  static const EdgeInsets paddingHorizontalNormal = EdgeInsets.symmetric(
    horizontal: spacingNormal,
  );
  static const EdgeInsets paddingVerticalNormal = EdgeInsets.symmetric(
    vertical: spacingNormal,
  );

  static const EdgeInsets paddingHorizontalSmall = EdgeInsets.symmetric(
    horizontal: spacingSmall,
  );
  static const EdgeInsets paddingVerticalSmall = EdgeInsets.symmetric(
    vertical: spacingSmall,
  );

  // ========== ELEVATION ==========
  static const double elevationNone = 0.0;
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;

  // ========== ICON SIZES ==========
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeNormal = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // ========== AVATAR SIZES ==========
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 40.0;
  static const double avatarSizeNormal = 48.0;
  static const double avatarSizeLarge = 64.0;
  static const double avatarSizeXLarge = 80.0;

  // ========== BUTTON SIZES ==========
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 44.0;
  static const double buttonHeightLarge = 52.0;

  static const EdgeInsets buttonPaddingSmall = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 8.0,
  );
  static const EdgeInsets buttonPaddingMedium = EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 12.0,
  );
  static const EdgeInsets buttonPaddingLarge = EdgeInsets.symmetric(
    horizontal: 24.0,
    vertical: 14.0,
  );

  // ========== INPUT FIELD ==========
  static const double inputFieldHeight = 48.0;
  static const EdgeInsets inputFieldPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  // ========== CHAT SPECIFIC ==========
  static const double messageBubbleMaxWidth = 280.0;
  static const EdgeInsets messageBubblePadding = EdgeInsets.symmetric(
    horizontal: 12.0,
    vertical: 8.0,
  );
  static const double messageSpacing = 4.0;
  static const double messageGroupSpacing = 12.0;

  // Online Status Indicator
  static const double onlineIndicatorSize = 12.0;
  static const double onlineIndicatorBorderWidth = 2.0;

  // Typing Indicator
  static const double typingIndicatorDotSize = 8.0;
  static const double typingIndicatorSpacing = 4.0;

  // ========== APP BAR ==========
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0;

  // ========== BOTTOM NAVIGATION BAR ==========
  static const double bottomNavBarHeight = 60.0;
  static const double bottomNavBarElevation = 8.0;

  // ========== DIVIDER ==========
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;

  // ========== LIST TILE ==========
  static const EdgeInsets listTilePadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );
  static const double listTileHeight = 72.0;

  // ========== ANIMATION DURATION ==========
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ========== OPACITY ==========
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.60;
  static const double opacityHigh = 0.87;

  // ========== CONSTRAINTS ==========
  static const double maxContentWidth = 600.0;
  static const double maxDialogWidth = 400.0;
  static const double minTapTargetSize = 48.0;
}
