import 'package:flutter/material.dart';

/// App color palette
class AppColors {
  // Primary colors
  static const primary = Color(0xFF3F51B5);
  static const primaryLight = Color(0xFF757DE8);
  static const primaryDark = Color(0xFF002984);

  // Secondary colors
  static const secondary = Color(0xFFFF9800);
  static const secondaryLight = Color(0xFFFFC947);
  static const secondaryDark = Color(0xFFC66900);

  // Accent colors for different purposes
  // static const accent1 = Color(0xFF00BCD4);
  static const accent1 = Color(0xFF00e5b3);
  static const accent2 = Color(0xFF8BC34A);
  static const accent3 = Color(0xFFE91E63);

    // Vibrant mint/teal for gradients
  static const Color vibrantMint = Color(0xFF00e5b3);
  static const Color vibrantTeal = Color(0xFF00bfcc);


  // Text colors
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const textLight = Color(0xFFFFFFFF);

  // Status colors
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFF44336);
  static const info = Color(0xFF2196F3);

  // Background colors
  static const background = Color(0xFFF5F5F5);
  static const surface = Color(0xFFFFFFFF);
  static const divider = Color(0xFFBDBDBD);

  // Dark theme colors
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkDivider = Color(0xFF424242);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryLight, secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accent1Gradient = LinearGradient(
    colors: [Color(0xFF4DD0E1), accent1, Color(0xFF0097A7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color homepageGradient1 =
      Color.fromRGBO(0, 115, 230, 1.0); // Deeper blue - trustworthy, stable
  static const Color homepageGradient2 =
      Color.fromRGBO(77, 38, 179, 1.0); // Rich purple - inspiring, aspiration

  // Fitness gradient colors - Exactly matching iOS values now
  static const Color fitnessGradient1 =
      Color.fromRGBO(26, 204, 102, 1.0); // Energetic green - vitality, action
  static const Color fitnessGradient2 =
      Color.fromRGBO(0, 179, 191, 1.0); // Teal - focus, endurance

  // Chat gradient colors - Exactly matching iOS values now
  static const Color chatGradient1 =
      Color.fromRGBO(128, 89, 230, 1.0); // Soft purple - wisdom, comfort
  static const Color chatGradient2 = Color.fromRGBO(
      230, 89, 153, 1.0); // Warm pink - communication, connection

  // Profile gradient colors - Exactly matching iOS values now
  static const Color profileGradient1 =
      Color.fromRGBO(0, 179, 166, 1.0); // Teal - balance, reliability
  static const Color profileGradient2 =
      Color.fromRGBO(38, 140, 204, 1.0); // Blue-green - personality, clarity
}
