import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import 'exceptions.dart';
import 'failures.dart';
import 'network_error_mapper.dart';

/// Centralized error handler for converting exceptions to failures
class ErrorHandler {
  /// Convert any exception to a Failure
  static Failure handleError(Object error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is AppException) {
      return _handleAppException(error);
    } else {
      return const ServerFailure(
        message: 'An unexpected error occurred',
      );
    }
  }
  
  /// Handle Dio errors
  static Failure _handleDioError(DioException error) {
    final exception = handleDioException(error);
    return _handleAppException(exception);
  }
  
  /// Convert AppException to Failure
  static Failure _handleAppException(AppException exception) {
    if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    } else if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        statusCode: exception.statusCode,
        type: _mapAuthExceptionType(exception.type),
      );
    } else if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    } else if (exception is ConnectivityException) {
      return ConnectionFailure(message: exception.message);
    } else if (exception is TimeoutException) {
      return TimeoutFailure(message: exception.message);
    } else if (exception is PermissionException) {
      return PermissionFailure(message: exception.message);
    } else {
      return ServerFailure(message: exception.message);
    }
  }
  
  /// Map AuthExceptionType to AuthFailureType
  static AuthFailureType _mapAuthExceptionType(AuthExceptionType type) {
    switch (type) {
      case AuthExceptionType.invalidCredentials:
        return AuthFailureType.invalidCredentials;
      case AuthExceptionType.expiredToken:
        return AuthFailureType.expiredToken;
      case AuthExceptionType.unauthorized:
        return AuthFailureType.unauthorized;
      case AuthExceptionType.userNotFound:
        return AuthFailureType.userNotFound;
      case AuthExceptionType.accountDisabled:
        return AuthFailureType.accountDisabled;
      case AuthExceptionType.unknown:
        return AuthFailureType.unknown;
    }
  }
}

/// Extension on Future to handle errors
extension FutureExtension<T> on Future<T> {
  /// Convert a Future<T> to a Future<Either<Failure, T>>
  Future<Either<Failure, T>> handleErrors() async {
    try {
      final result = await this;
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handleError(e));
    }
  }
}
