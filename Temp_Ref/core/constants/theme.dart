// import 'package:flutter/material.dart';
// import 'colors.dart';

// /// Theme configuration for the app
// class AppTheme {
//   // Private constructor to prevent instantiation
//   AppTheme._();
  
//   /// Light theme configuration
//   static ThemeData get lightTheme {
//     return ThemeData(
//       useMaterial3: true,
//       colorScheme: ColorScheme.light(
//         primary: AppColors.primary,
//         onPrimary: Colors.white,
//         primaryContainer: AppColors.primaryLight,
//         onPrimaryContainer: Colors.white,
//         secondary: AppColors.secondary,
//         onSecondary: Colors.white,
//         secondaryContainer: AppColors.secondaryLight,
//         onSecondaryContainer: Colors.white,
//         tertiary: AppColors.accent1,
//         onTertiary: Colors.white,
//         error: AppColors.error,
//         onError: Colors.white,
//         background: AppColors.background,
//         onBackground: AppColors.textPrimary,
//         surface: AppColors.surface,
//         onSurface: AppColors.textPrimary,
//       ),
//       scaffoldBackgroundColor: AppColors.background,
//       appBarTheme: AppBarTheme(
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       cardTheme: CardTheme(
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           foregroundColor: Colors.white,
//           backgroundColor: AppColors.primary,
//           elevation: 2,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: AppColors.primary,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: OutlinedButton.styleFrom(
//           foregroundColor: AppColors.primary,
//           side: BorderSide(color: AppColors.primary),
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: AppColors.divider),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: AppColors.divider),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: AppColors.primary),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: AppColors.error),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       ),
//       dividerTheme: DividerThemeData(
//         color: AppColors.divider,
//         thickness: 1,
//         space: 1,
//       ),
//       textTheme: TextTheme(
//         displayLarge: TextStyle(color: AppColors.textPrimary),
//         displayMedium: TextStyle(color: AppColors.textPrimary),
//         displaySmall: TextStyle(color: AppColors.textPrimary),
//         headlineLarge: TextStyle(color: AppColors.textPrimary),
//         headlineMedium: TextStyle(color: AppColors.textPrimary),
//         headlineSmall: TextStyle(color: AppColors.textPrimary),
//         titleLarge: TextStyle(color: AppColors.textPrimary),
//         titleMedium: TextStyle(color: AppColors.textPrimary),
//         titleSmall: TextStyle(color: AppColors.textPrimary),
//         bodyLarge: TextStyle(color: AppColors.textPrimary),
//         bodyMedium: TextStyle(color: AppColors.textPrimary),
//         bodySmall: TextStyle(color: AppColors.textSecondary),
//         labelLarge: TextStyle(color: AppColors.textPrimary),
//         labelMedium: TextStyle(color: AppColors.textSecondary),
//         labelSmall: TextStyle(color: AppColors.textSecondary),
//       ),
//     );
//   }
  
//   /// Dark theme configuration
//   static ThemeData get darkTheme {
//     return ThemeData(
//       useMaterial3: true,
//       colorScheme: ColorScheme.dark(
//         primary: AppColors.primaryLight,
//         onPrimary: Colors.black,
//         primaryContainer: AppColors.primary,
//         onPrimaryContainer: Colors.white,
//         secondary: AppColors.secondaryLight,
//         onSecondary: Colors.black,
//         secondaryContainer: AppColors.secondary,
//         onSecondaryContainer: Colors.white,
//         tertiary: AppColors.accent1,
//         onTertiary: Colors.black,
//         error: AppColors.error,
//         onError: Colors.white,
//         background: AppColors.darkBackground,
//         onBackground: Colors.white,
//         surface: AppColors.darkSurface,
//         onSurface: Colors.white,
//       ),
//       scaffoldBackgroundColor: AppColors.darkBackground,
//       appBarTheme: AppBarTheme(
//         backgroundColor: AppColors.darkSurface,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       cardTheme: CardTheme(
//         color: AppColors.darkSurface,
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           foregroundColor: Colors.black,
//           backgroundColor: AppColors.primaryLight,
//           elevation: 2,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: AppColors.primaryLight,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: OutlinedButton.styleFrom(
//           foregroundColor: AppColors.primaryLight,
//           side: BorderSide(color: AppColors.primaryLight),
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: AppColors.darkSurface,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: AppColors.darkDivider),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: AppColors.darkDivider),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: AppColors.primaryLight),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: AppColors.error),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       ),
//       dividerTheme: DividerThemeData(
//         color: AppColors.darkDivider,
//         thickness: 1,
//         space: 1,
//       ),
//       textTheme: TextTheme(
//         displayLarge: const TextStyle(color: Colors.white),
//         displayMedium: const TextStyle(color: Colors.white),
//         displaySmall: const TextStyle(color: Colors.white),
//         headlineLarge: const TextStyle(color: Colors.white),
//         headlineMedium: const TextStyle(color: Colors.white),
//         headlineSmall: const TextStyle(color: Colors.white),
//         titleLarge: const TextStyle(color: Colors.white),
//         titleMedium: const TextStyle(color: Colors.white),
//         titleSmall: const TextStyle(color: Colors.white),
//         bodyLarge: const TextStyle(color: Colors.white),
//         bodyMedium: const TextStyle(color: Colors.white),
//         bodySmall: TextStyle(color: Colors.white.withOpacity(0.7)),
//         labelLarge: const TextStyle(color: Colors.white),
//         labelMedium: TextStyle(color: Colors.white.withOpacity(0.7)),
//         labelSmall: TextStyle(color: Colors.white.withOpacity(0.7)),
//       ),
//     );
//   }
// }
