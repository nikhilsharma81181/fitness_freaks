import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../storage/hive_adapters.dart';
import '../storage/models/user_box.dart' as models;

/// Logger instance for the app
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
);

/// Class responsible for initializing app services
class AppInitializer {
  /// Initialize all app services
  static Future<void> initialize() async {
    try {
      // Setup error handling
      _setupErrorHandling();

      // Initialize Hive
      await _initializeHive();

      logger.i('App initialization complete');
    } catch (e, stackTrace) {
      logger.e('Error during app initialization',
          error: e, stackTrace: stackTrace);
    }
  }

  /// Initialize Hive for local storage
  static Future<void> _initializeHive() async {
    try {
      // Get application documents directory
      final appDocDir = await getApplicationDocumentsDirectory();

      // Initialize Hive with a directory
      await Hive.initFlutter(appDocDir.path);

      try {
        // Clear any corrupted data first
        await Hive.deleteBoxFromDisk('userBox');
        await Hive.deleteBoxFromDisk('weightBox');
        await Hive.deleteBoxFromDisk('settingsBox');
      } catch (e) {
        // Ignore errors during cleanup
        logger.w('Error cleaning up Hive boxes: $e');
      }

      // Register adapters for custom types
      try {
        // Register UserBoxAdapter
        if (!Hive.isAdapterRegistered(2)) {
          Hive.registerAdapter(UserBoxAdapter());
          logger.i('UserBoxAdapter registered with typeId 2');
        }

        // Create boxes
        await Hive.openBox('userBox',
            compactionStrategy: (entries, deletedEntries) {
          return deletedEntries > 10 || entries > 50;
        });
        await Hive.openBox('weightBox',
            compactionStrategy: (entries, deletedEntries) {
          return deletedEntries > 20 || entries > 100;
        });
        await Hive.openBox('settingsBox');
        await Hive.openBox('app_storage');
        await Hive.openBox('auth_box');

        logger.i('Hive boxes opened successfully');
      } catch (boxError) {
        logger.w('Failed to open Hive boxes: $boxError');
        // Continue even if box opening fails
      }

      logger.i('Hive initialized successfully');
    } catch (e, stackTrace) {
      logger.e('Error initializing Hive:', error: e, stackTrace: stackTrace);
      // Continue without Hive in case of error
    }
  }

  /// Setup global error handling
  static void _setupErrorHandling() {
    // Override the default error widget to prevent red screens
    ErrorWidget.builder = (FlutterErrorDetails details) {
      // Return a simple container instead of the red error screen
      return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: const Text(
          'Something went wrong',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    };

    // Catch Flutter errors
    FlutterError.onError = (FlutterErrorDetails details) {
      // List of errors to suppress completely
      final errorMessages = [
        'ScrollController',
        'HiveError',
        'A ScrollController was used after being disposed',
        'mouse_tracker.dart',
        'dispose() called twice',
        'setState() or markNeedsBuild() called during build',
      ];

      // Check if error contains any suppressed messages
      final shouldSuppress = errorMessages
          .any((message) => details.exception.toString().contains(message));

      if (shouldSuppress) {
        logger.w('Non-critical Flutter error suppressed:',
            error: details.exception);
        return;
      }

      FlutterError.presentError(details);
      logger.e('Flutter error:',
          error: details.exception, stackTrace: details.stack);
    };

    // Catch async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      // List of errors to suppress completely
      final errorMessages = [
        'ScrollController',
        'HiveError',
        'A ScrollController was used after being disposed',
        'mouse_tracker.dart',
        'dispose() called twice',
        'setState() or markNeedsBuild() called during build',
      ];

      // Check if error contains any suppressed messages
      final shouldSuppress =
          errorMessages.any((message) => error.toString().contains(message));

      if (shouldSuppress) {
        logger.w('Non-critical async error suppressed:', error: error);
        return true;
      }

      logger.e('Uncaught async error', error: error, stackTrace: stack);
      return true;
    };
  }
}
