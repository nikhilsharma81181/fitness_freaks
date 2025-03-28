import 'package:flutter/material.dart';

/// A widget that displays a loading indicator
///
/// This provides a consistent way to show loading states across the app
class LoadingWidget extends StatelessWidget {
  /// Message to display below the loading indicator
  final String? message;
  
  /// Size of the loading indicator
  final double size;
  
  /// Whether to use a linear progress indicator instead of circular
  final bool linear;
  
  /// Color of the loading indicator
  final Color? color;
  
  const LoadingWidget({
    super.key,
    this.message,
    this.size = 36.0,
    this.linear = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loadingColor = color ?? theme.colorScheme.primary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (linear)
            SizedBox(
              width: size * 4,
              child: LinearProgressIndicator(
                color: loadingColor,
                backgroundColor: loadingColor.withOpacity(0.2),
              ),
            )
          else
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                color: loadingColor,
                strokeWidth: 3,
              ),
            ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

/// A widget that overlays a loading indicator on top of existing content
///
/// This is useful for showing loading states while keeping the UI intact
class LoadingOverlay extends StatelessWidget {
  /// Whether the loading overlay is visible
  final bool isLoading;
  
  /// The content to display beneath the loading overlay
  final Widget child;
  
  /// Message to display below the loading indicator
  final String? message;
  
  /// Color of the loading overlay background
  final Color? color;
  
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: (color ?? Colors.black).withOpacity(0.5),
            child: LoadingWidget(message: message),
          ),
      ],
    );
  }
}
