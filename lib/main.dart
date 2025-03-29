import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';

import 'core/constant/colors/theme.dart';
import 'core/services/app_initializer.dart';
import 'features/auth/presentation/pages/auth_wrapper.dart';

/// Main application entry point
Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    // Initialize Firebase
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
    // Continue without Firebase in case of error
  }

  // Initialize app services
  await AppInitializer.initialize();

  // Add this error handler for Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    // Check if the error is from MouseTracker
    if (details.exception.toString().contains('mouse_tracker.dart')) {
      // Just log the error but don't crash the app
      debugPrint('Suppressed MouseTracker error: ${details.exception}');
      return;
    }
    // For other errors, use the default error reporting
    FlutterError.presentError(details);
  };

  // Handle errors that don't occur within Flutter's callbacks
  PlatformDispatcher.instance.onError = (error, stack) {
    if (error.toString().contains('mouse_tracker.dart')) {
      debugPrint('Suppressed MouseTracker error: $error');
      return true;
    }
    // Let other errors propagate
    return false;
  };

  // Run the app
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// Application root widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
    );
  }
}
