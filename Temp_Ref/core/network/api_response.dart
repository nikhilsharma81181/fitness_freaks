import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../error/error_handler.dart';
import '../error/failures.dart';

/// Generic API response handler to standardize all API calls
class ApiResponse<T> {
  /// Process a Dio API call and return Either<Failure, T>
  static Future<Either<Failure, T>> handle<T>(
    Future<T> Function() apiCall,
  ) async {
    try {
      final result = await apiCall();
      return right(result);
    } on DioException catch (e) {
      return left(ErrorHandler.handleError(e));
    } catch (e) {
      return left(
        ServerFailure(message: 'An unexpected error occurred: $e'),
      );
    }
  }

  /// Process a Dio API call with a custom response mapper
  static Future<Either<Failure, R>> handleWithMapper<T, R>(
    Future<T> Function() apiCall,
    R Function(T) mapper,
  ) async {
    try {
      final result = await apiCall();
      return right(mapper(result));
    } on DioException catch (e) {
      return left(ErrorHandler.handleError(e));
    } catch (e) {
      return left(
        ServerFailure(message: 'An unexpected error occurred: $e'),
      );
    }
  }

  /// Process a Dio API call with offline fallback
  static Future<Either<Failure, T>> handleWithOffline<T>(
    Future<T> Function() apiCall,
    Future<T?> Function() offlineData,
  ) async {
    try {
      final result = await apiCall();
      return right(result);
    } on DioException catch (e) {
      final fallbackData = await offlineData();
      if (fallbackData != null) {
        return right(fallbackData);
      }
      return left(ErrorHandler.handleError(e));
    } catch (e) {
      final fallbackData = await offlineData();
      if (fallbackData != null) {
        return right(fallbackData);
      }
      return left(
        ServerFailure(message: 'An unexpected error occurred: $e'),
      );
    }
  }
}
