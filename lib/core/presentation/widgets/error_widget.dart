import 'package:flutter/material.dart';

import '../../domain/failures/failure.dart';

/// A widget that displays an error message with an optional retry button
///
/// This provides a consistent way to show errors across the app
class AppErrorWidget extends StatelessWidget {
  /// The error to display
  final dynamic error;
  
  /// Callback when the retry button is pressed
  final VoidCallback? onRetry;
  
  /// Whether to show the retry button
  final bool showRetry;
  
  /// Whether to show the error details
  final bool showDetails;
  
  const AppErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.showRetry = true,
    this.showDetails = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _getErrorMessage(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (showDetails && _getErrorDetails() != null) ...[
              const SizedBox(height: 8),
              Text(
                _getErrorDetails() ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (showRetry && onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Extract a user-friendly error message from the error
  String _getErrorMessage() {
    if (error is Failure) {
      return (error as Failure).message;
    } else if (error is Exception) {
      return 'An error occurred: ${error.toString()}';
    } else {
      return 'Something went wrong. Please try again later.';
    }
  }
  
  /// Extract technical details from the error for debugging
  String? _getErrorDetails() {
    if (error is Exception) {
      return error.toString();
    } else if (error is Error) {
      return '${error.toString()}\n${(error as Error).stackTrace}';
    }
    return null;
  }
}
