// app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryColor = Color(0xFF02E9AE);
  static const Color primaryDarkColor = Color(0xFF00bfcc);
  static const Color vibrantMint = Color(0xFF00e5b3);
  static const Color vibrantTeal = Color(0xFF00bfcc);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF252525);

  // Glass effect colors
  static Color glassBackground = Colors.white.withOpacity(0.05);
  static Color glassBorder = Colors.white.withOpacity(0.1);
  static Color glassOverlay = Colors.black.withOpacity(0.1);

  // Gradient colors matching iOS implementation
  static const Color homepageGradient1 =
      Color(0xFF0073E6); // Deeper blue - trustworthy, stable
  static const Color homepageGradient2 =
      Color(0xFF4D26B3); // Rich purple - inspiring, aspiration

  static const Color fitnessGradient1 =
      Color(0xFF1ACC66); // Energetic green - vitality, action
  static const Color fitnessGradient2 =
      Color(0xFF00B3BF); // Teal - focus, endurance

  static const Color chatGradient1 =
      Color(0xFF8059E6); // Soft purple - wisdom, comfort
  static const Color chatGradient2 =
      Color(0xFFE65999); // Warm pink - communication, connection

  static const Color profileGradient1 =
      Color(0xFF00B3A6); // Teal - balance, reliability
  static const Color profileGradient2 =
      Color(0xFF268CCC); // Blue-green - personality, clarity

  // Background gradients for various screens
  static const List<Color> loginGradient = [
    Color(0xFF121212),
    Color(0xFF1E1E1E),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF00e5b3),
    Color(0xFF00bfcc),
  ];

  // Special feature gradients (based on the screenshots)
  static const List<Color> sleepGradient = [
    Color(0xFF002538), // Dark Blue/Teal Start
    Color(0xFF00546c), // Dark Blue/Teal End
  ];

  static const List<Color> stressGradient = [
    Color(0xFF1f0020),
    Color(0xFF3b0029),
  ];

  static const List<Color> recoveryGradient = [
    Color(0xFF002014),
    Color(0xFF00391d),
  ];

  static const List<Color> movementGradient = [
    Color(0xFF331500),
    Color(0xFF512300),
  ];

  static const List<Color> metabolicGradient = [
    Color(0xFF002217),
    Color(0xFF003c25),
  ];

  static const List<Color> powerPlugsGradient = [
    Color(0xFF200025),
    Color(0xFF330033),
  ];

  static const List<Color> womensHealthGradient = [
    Color(0xFF000a33),
    Color(0xFF00144d),
  ];

  // Text colors
  static const Color primaryTextColor = Colors.white;
  static const Color secondaryTextColor = Color(0xFFB0B0B0);
  static const Color tertiaryTextColor = Color(0xFF757575);

  // UI elements
  static const Color cardColor = Color(0xFF252525);
  static const Color dividerColor = Color(0xFF303030);

  // Button colors
  static const Color googleButtonColor = Color(0xFF252525);
  static const Color appleButtonColor = Colors.black;

  // Status colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE53935);
  static const Color warningColor = Color(0xFFFFB300);

  // Chart colors
  static const Color chartLineColor = Color(0xFF00e5b3);
  static const Color chartBarColor = Color(0xFF00bfcc);

  // Apple-style health metrics colors (from screenshots)
  static const Color sleepMetricColor = Color(0xFF00e5b3);
  static const Color heartRateColor = Color(0xFFFF375F);
  static const Color stepsColor = Color(0xFFFFB340);
  static const Color caloriesColor = Color(0xFFFF9500);
  static const Color stressColor = Color(0xFFFF2D55);
  static const Color relaxedColor = Color(0xFF5AC8FA);
  static const Color optimalIndicator = Color(0xFF30D158);
  static const Color warningIndicator = Color(0xFFFF9F0A);
  static const Color alertIndicator = Color(0xFFFF3B30);
}
