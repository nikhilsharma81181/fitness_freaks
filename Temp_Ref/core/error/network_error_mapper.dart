import 'dart:io';
import 'package:dio/dio.dart';
import 'exceptions.dart';

/// Maps Dio errors to our custom exceptions
AppException handleDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return TimeoutException('Connection timed out. Please try again.');
      
    case DioExceptionType.badCertificate:
      return ServerException(
        'Invalid server certificate. Please contact support.',
      );
      
    case DioExceptionType.badResponse:
      return _handleBadResponse(error);
      
    case DioExceptionType.cancel:
      return ServerException('Request was cancelled');
      
    case DioExceptionType.connectionError:
      return ConnectivityException('Connection error. Please check your internet.');
      
    case DioExceptionType.unknown:
      if (error.error is SocketException) {
        return ConnectivityException();
      }
      return ServerException(
        error.message ?? 'An unexpected error occurred',
      );
  }
}

/// Handle bad response errors with specific status codes
AppException _handleBadResponse(DioException error) {
  final statusCode = error.response?.statusCode;
  final data = error.response?.data;
  
  // Extract error message from response if available
  String errorMessage = 'An error occurred';
  if (data != null && data is Map && data.containsKey('message')) {
    errorMessage = data['message'];
  }
  
  switch (statusCode) {
    case 400:
      return ServerException(
        errorMessage,
        statusCode: statusCode,
      );
      
    case 401:
      return AuthException(
        errorMessage,
        type: AuthExceptionType.unauthorized,
        statusCode: statusCode,
      );
      
    case 403:
      return AuthException(
        errorMessage,
        type: AuthExceptionType.unauthorized,
        statusCode: statusCode,
      );
      
    case 404:
      return ServerException(
        errorMessage,
        statusCode: statusCode,
      );
      
    case 408:
      return TimeoutException(errorMessage);
      
    case 409:
      return ServerException(
        errorMessage,
        statusCode: statusCode,
      );
      
    case 422:
      return ServerException(
        errorMessage,
        statusCode: statusCode,
      );
      
    case 429:
      return ServerException(
        'Too many requests. Please try again later.',
        statusCode: statusCode,
      );
      
    case 500:
    case 501:
    case 502:
    case 503:
    case 504:
      return ServerException(
        'Server error. Please try again later.',
        statusCode: statusCode,
      );
      
    default:
      return ServerException(
        errorMessage,
        statusCode: statusCode,
      );
  }
}
