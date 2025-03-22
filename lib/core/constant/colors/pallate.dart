import 'package:flutter/material.dart';

/// Palette class that mirrors the Swift color extensions exactly
class Pallate {
  // Background colors
  static const Color darkBackground = Colors.black;
  static final Color cardBackground = Color.fromRGBO(20, 20, 23, 0.6);
  static final Color cardBackgroundAlt = Color.fromRGBO(31, 31, 36, 0.5);

  // Text colors
  static const Color textPrimary = Colors.white;
  static final Color textSecondary = Colors.white.withOpacity(0.7);
  static final Color textTertiary = Colors.white.withOpacity(0.5);

  // Glass effect colors
  static final Color glassOverlay = Colors.white.withOpacity(0.07);
  static final Color glassBorder = Colors.white.withOpacity(0.12);
  static final Color glassShadow = Colors.black.withOpacity(0.2);

  // Vibrant mint/teal for gradients
  static const Color vibrantMint = Color.fromRGBO(0, 230, 179, 1.0);
  static const Color vibrantTeal = Color.fromRGBO(0, 191, 204, 1.0);

  // Homepage gradient colors - Exactly matching iOS values now
  static const Color homepageGradient1 = Color.fromRGBO(0, 115, 230, 1.0); // Deeper blue - trustworthy, stable
  static const Color homepageGradient2 = Color.fromRGBO(77, 38, 179, 1.0); // Rich purple - inspiring, aspiration

  // Fitness gradient colors - Exactly matching iOS values now
  static const Color fitnessGradient1 = Color.fromRGBO(26, 204, 102, 1.0); // Energetic green - vitality, action
  static const Color fitnessGradient2 = Color.fromRGBO(0, 179, 191, 1.0); // Teal - focus, endurance

  // Chat gradient colors - Exactly matching iOS values now
  static const Color chatGradient1 = Color.fromRGBO(128, 89, 230, 1.0); // Soft purple - wisdom, comfort
  static const Color chatGradient2 = Color.fromRGBO(230, 89, 153, 1.0); // Warm pink - communication, connection

  // Profile gradient colors - Exactly matching iOS values now
  static const Color profileGradient1 = Color.fromRGBO(0, 179, 166, 1.0); // Teal - balance, reliability
  static const Color profileGradient2 = Color.fromRGBO(38, 140, 204, 1.0); // Blue-green - personality, clarity

  // Accent colors
  static const Color accentGreen = Color.fromRGBO(38, 217, 140, 1.0);
  static const Color accentBlue = Color.fromRGBO(0, 204, 242, 1.0);
  static const Color accentPurple = Color.fromRGBO(140, 89, 242, 1.0);
  static const Color accentRed = Color.fromRGBO(242, 77, 89, 1.0);
  static const Color accentOrange = Color.fromRGBO(242, 153, 77, 1.0);

  // Health metric colors
  static const Color sleepTeal = Color.fromRGBO(0, 204, 179, 1.0);
  static const Color recoveryGreen = Color.fromRGBO(51, 179, 77, 1.0);
  static const Color stressRed = Color.fromRGBO(242, 77, 64, 1.0);
  static const Color stressBlue = Color.fromRGBO(77, 153, 242, 1.0);
}