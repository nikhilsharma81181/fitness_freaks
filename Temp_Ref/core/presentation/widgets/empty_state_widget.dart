import 'package:flutter/material.dart';

/// A widget that displays an empty state with an illustration and message
///
/// This provides a consistent way to show empty states across the app
class EmptyStateWidget extends StatelessWidget {
  /// Title to display
  final String title;
  
  /// Message to display
  final String message;
  
  /// Icon to display
  final IconData icon;
  
  /// Action button text
  final String? actionText;
  
  /// Callback when the action button is pressed
  final VoidCallback? onActionPressed;
  
  /// Color of the icon
  final Color? iconColor;
  
  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionText,
    this.onActionPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: iconColor ?? theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            if (actionText != null && onActionPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onActionPressed,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Predefined empty state for when no data is available
class NoDataEmptyState extends StatelessWidget {
  final String? message;
  final VoidCallback? onRefresh;
  
  const NoDataEmptyState({
    super.key,
    this.message,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.data_array_outlined,
      title: 'No Data Available',
      message: message ?? 'There is no data to display at the moment.',
      actionText: onRefresh != null ? 'Refresh' : null,
      onActionPressed: onRefresh,
    );
  }
}

/// Predefined empty state for search results
class NoSearchResultsEmptyState extends StatelessWidget {
  final String searchTerm;
  final VoidCallback? onClear;
  
  const NoSearchResultsEmptyState({
    super.key,
    required this.searchTerm,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off_outlined,
      title: 'No Results Found',
      message: 'We couldn\'t find anything matching "$searchTerm"',
      actionText: onClear != null ? 'Clear Search' : null,
      onActionPressed: onClear,
    );
  }
}

/// Predefined empty state for when the user hasn't created any items yet
class NoItemsYetEmptyState extends StatelessWidget {
  final String itemName;
  final VoidCallback? onCreate;
  
  const NoItemsYetEmptyState({
    super.key,
    required this.itemName,
    this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.add_circle_outline,
      title: 'No $itemName Yet',
      message: 'You haven\'t created any $itemName yet. Tap the button below to get started.',
      actionText: onCreate != null ? 'Create $itemName' : null,
      onActionPressed: onCreate,
    );
  }
}
