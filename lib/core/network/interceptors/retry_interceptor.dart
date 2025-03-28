import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor for automatically retrying failed requests
class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int maxRetries;
  final Duration initialDelay;
  final bool enableExponentialBackoff;

  RetryInterceptor(
    this._dio, {
    this.maxRetries = 3,
    this.initialDelay = const Duration(milliseconds: 500),
    this.enableExponentialBackoff = true,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Get the retry count for this request
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    // Check if we should retry the request
    if (_shouldRetry(err, retryCount)) {
      // Calculate the delay before retrying
      final delay = _calculateDelay(retryCount);

      // Wait before retrying
      await Future.delayed(delay);

      try {
        // Update the retry count for this request
        final options = RequestOptions(
          path: err.requestOptions.path,
          method: err.requestOptions.method,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          headers: err.requestOptions.headers,
          baseUrl: err.requestOptions.baseUrl,
          extra: {
            ...err.requestOptions.extra,
            'retryCount': retryCount + 1,
          },
        );

        debugPrint(
            '⟲ Retrying request (${retryCount + 1}/$maxRetries): ${options.path}');

        // Retry the request
        final response = await _dio.fetch(options);

        // If successful, resolve with the response
        handler.resolve(response);
        return;
      } catch (e) {
        // If the retry failed, pass the error to the next interceptor
        debugPrint('⚠️ Retry failed: $e');

        // If it's a DioException, keep the original error type
        if (e is DioException) {
          return handler.next(e);
        }

        // Otherwise, create a new DioException
        return handler.next(
          DioException(
            requestOptions: err.requestOptions,
            error: e,
            type: DioExceptionType.unknown,
          ),
        );
      }
    }

    // If we shouldn't retry, pass the error to the next interceptor
    return handler.next(err);
  }

  /// Determine if we should retry the request
  bool _shouldRetry(DioException err, int retryCount) {
    // Don't retry if we've reached the max number of retries
    if (retryCount >= maxRetries) {
      return false;
    }

    // Retry on connection errors and server errors (5xx)
    final hasNetworkError = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.error is SocketException;

    final hasServerError =
        err.response?.statusCode != null && err.response!.statusCode! >= 500;

    // Also retry on some specific response codes
    final hasRetryableStatusCode = err.response?.statusCode ==
            429 || // Too Many Requests
        err.response?.statusCode ==
            404; // Not Found - could be a temporary issue or endpoint change

    return hasNetworkError || hasServerError || hasRetryableStatusCode;
  }

  /// Calculate the delay before retrying
  Duration _calculateDelay(int retryCount) {
    if (!enableExponentialBackoff) {
      return initialDelay;
    }

    // Use exponential backoff with jitter
    // Formula: delay = initialDelay * 2^retry * (0.5 + random(0, 0.5))
    final exponentialDelay = initialDelay.inMilliseconds * pow(2, retryCount);
    final jitter = 0.5 + (Random().nextDouble() * 0.5);

    return Duration(milliseconds: (exponentialDelay * jitter).toInt());
  }
}
