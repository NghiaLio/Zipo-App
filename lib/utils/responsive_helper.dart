import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double getResponsiveSize(BuildContext context, double size) {
    final diagonal = MediaQuery.of(context).size.shortestSide;
    return size * (diagonal / 400);
  }

  static double getAvatarSize(BuildContext context) {
    final diagonal = MediaQuery.of(context).size.shortestSide;
    return (diagonal * 0.16).clamp(56.0, 72.0);
  }

  static double getStoryAvatarSize(BuildContext context) {
    final diagonal = MediaQuery.of(context).size.shortestSide;
    return (diagonal * 0.14).clamp(50.0, 64.0);
  }

  static double getFontSize(BuildContext context, double baseSize) {
    final diagonal = MediaQuery.of(context).size.shortestSide;
    return (baseSize * (diagonal / 400)).clamp(baseSize * 0.8, baseSize * 1.2);
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) {
      return const EdgeInsets.symmetric(horizontal: 24);
    }
    return const EdgeInsets.symmetric(horizontal: 12);
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }
}
