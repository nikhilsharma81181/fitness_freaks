import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'empty_state_widget.dart';
import 'error_widget.dart';
import 'loading_widget.dart';

/// A widget that handles the different states of an AsyncValue
///
/// This provides a consistent way to handle async data across the app
class AsyncValueWidget<T> extends StatelessWidget {
  /// The async value to display
  final AsyncValue<T> value;
  
  /// Builder for when data is available
  final Widget Function(T data) data;
  
  /// Widget to display when loading
  final Widget? loadingWidget;
  
  /// Widget to display when an error occurs
  final Widget Function(Object error, StackTrace? stackTrace)? errorWidget;
  
  /// Widget to display when data is empty
  final Widget? emptyWidget;
  
  /// Whether to show a retry button on error
  final bool showRetryOnError;
  
  /// Callback when the retry button is pressed
  final VoidCallback? onRetry;
  
  /// Function to determine if data is empty
  final bool Function(T data)? isEmpty;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.showRetryOnError = true,
    this.onRetry,
    this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (valueData) {
        if (_isEmptyData(valueData)) {
          return emptyWidget ?? const NoDataEmptyState();
        }
        return data(valueData);
      },
      loading: () => loadingWidget ?? const LoadingWidget(),
      error: (error, stackTrace) {
        if (errorWidget != null) {
          return errorWidget!(error, stackTrace);
        }
        return AppErrorWidget(
          error: error,
          onRetry: showRetryOnError ? onRetry : null,
          showRetry: showRetryOnError && onRetry != null,
        );
      },
    );
  }
  
  /// Determine if the data is considered empty
  bool _isEmptyData(T valueData) {
    if (isEmpty != null) {
      return isEmpty!(valueData);
    }
    
    if (valueData == null) {
      return true;
    }
    
    if (valueData is List) {
      return valueData.isEmpty;
    }
    
    if (valueData is Map) {
      return valueData.isEmpty;
    }
    
    if (valueData is String) {
      return valueData.isEmpty;
    }
    
    return false;
  }
}
