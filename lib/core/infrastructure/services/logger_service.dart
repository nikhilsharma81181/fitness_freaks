import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Service for logging across the application
class LoggerService {
  final bool _enableVerbose;
  final bool _enableInfo;
  final bool _enableWarning;
  final bool _enableError;
  
  const LoggerService({
    bool enableVerbose = kDebugMode,
    bool enableInfo = true,
    bool enableWarning = true,
    bool enableError = true,
  })  : _enableVerbose = enableVerbose,
        _enableInfo = enableInfo,
        _enableWarning = enableWarning,
        _enableError = enableError;
  
  /// Log a verbose message (debug)
  void v(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_enableVerbose) return;
    _log(
      'VERBOSE',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  /// Log an informational message
  void i(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_enableInfo) return;
    _log(
      'INFO',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  /// Log a warning message
  void w(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_enableWarning) return;
    _log(
      'WARNING',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  /// Log an error message
  void e(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_enableError) return;
    _log(
      'ERROR',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  /// Log a formatted message
  void _log(
    String level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final tagString = tag != null ? '[$tag] ' : '';
    final errorString = error != null ? '\nError: $error' : '';
    final stackTraceString = stackTrace != null ? '\nStack Trace:\n$stackTrace' : '';
    
    final formattedMessage = '[$timestamp] $level: $tagString$message$errorString$stackTraceString';
    
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? 'APP',
        time: DateTime.now(),
        level: _getLevelValue(level),
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      // In production, we might want to send logs to a remote service
      // or store them locally for later analysis
      debugPrint(formattedMessage);
    }
  }
  
  /// Convert level string to numeric value
  int _getLevelValue(String level) {
    switch (level) {
      case 'VERBOSE':
        return 500;
      case 'INFO':
        return 800;
      case 'WARNING':
        return 900;
      case 'ERROR':
        return 1000;
      default:
        return 0;
    }
  }
}
