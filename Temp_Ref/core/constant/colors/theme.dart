// import 'package:flutter/material.dart';

// /// Theme and color constants for the app
// class AppTheme {
//   // Private constructor to prevent instantiation
//   AppTheme._();

//   // Primary colors
//   static const Color primaryColor = Color(0xFF3B82F6);
//   static const Color primaryLightColor = Color(0xFF60A5FA);
//   static const Color primaryDarkColor = Color(0xFF2563EB);

//   // Secondary colors
//   static const Color secondaryColor = Color(0xFFA78BFA);
//   static const Color secondaryLightColor = Color(0xFFC4B5FD);
//   static const Color secondaryDarkColor = Color(0xFF8B5CF6);

//   // Accent colors
//   static const Color accentColor = Color(0xFFEC4899);
//   static const Color accentLightColor = Color(0xFFF9A8D4);
//   static const Color accentDarkColor = Color(0xFFDB2777);

//   // Background colors
//   static const Color backgroundLight = Color(0xFFF9FAFB);
//   static const Color backgroundDark = Color(0xFF121212);

//   // Text colors
//   static const Color textPrimaryLight = Color(0xFF1F2937);
//   static const Color textSecondaryLight = Color(0xFF6B7280);
//   static const Color textPrimaryDark = Color(0xFFF9FAFB);
//   static const Color textSecondaryDark = Color(0xFFD1D5DB);

//   // Success, warning, error colors
//   static const Color success = Color(0xFF10B981);
//   static const Color warning = Color(0xFFF59E0B);
//   static const Color error = Color(0xFFEF4444);

//   // Gradient for buttons and backgrounds
//   static const LinearGradient primaryGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [primaryColor, secondaryColor],
//   );

//   static const LinearGradient accentGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [secondaryColor, accentColor],
//   );

//   // Common gradients
//   static const LinearGradient darkGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Colors.black, Color(0xFF111827), Colors.black],
//   );

//   // Theme configurations
//   static ThemeData lightTheme() {
//     return ThemeData(
//       primaryColor: primaryColor,
//       scaffoldBackgroundColor: backgroundLight,
//       fontFamily: 'Poppins',
//       brightness: Brightness.light,
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: primaryColor,
//         secondary: secondaryColor,
//         tertiary: accentColor,
//         brightness: Brightness.light,
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 16,
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryColor,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           padding: const EdgeInsets.symmetric(
//             horizontal: 24,
//             vertical: 16,
//           ),
//           textStyle: const TextStyle(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       cardTheme: CardTheme(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         elevation: 2,
//       ),
//       appBarTheme: const AppBarTheme(
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//     );
//   }

//   static ThemeData darkTheme() {
//     return ThemeData(
//       primaryColor: primaryColor,
//       scaffoldBackgroundColor: backgroundDark,
//       fontFamily: 'Poppins',
//       brightness: Brightness.dark,
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: primaryColor,
//         secondary: secondaryColor,
//         tertiary: accentColor,
//         brightness: Brightness.dark,
//       ),
//       cardTheme: CardTheme(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         elevation: 2,
//         color: const Color(0xFF1F2937),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 16,
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryColor,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           padding: const EdgeInsets.symmetric(
//             horizontal: 24,
//             vertical: 16,
//           ),
//           textStyle: const TextStyle(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       appBarTheme: const AppBarTheme(
//         backgroundColor: Color(0xFF1F2937),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//     );
//   }
// }
