import 'dart:io';
import 'package:dio/dio.dart';

import 'exceptions.dart';

/// Handle Dio exceptions and convert them to our custom exceptions
/// This is kept for backward compatibility
/// New code should use network_error_mapper.dart
ServerException handleDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return ServerException('Connection timeout. Please try again later.');
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;
      String message = 'Server error';
      
      if (data is Map && data.containsKey('message')) {
        message = data['message'].toString();
      }
      
      return ServerException(message, statusCode: statusCode);
    case DioExceptionType.cancel:
      return ServerException('Request was cancelled');
    case DioExceptionType.connectionError:
      return ServerException('Connection error. Please check your internet.');
    case DioExceptionType.badCertificate:
      return ServerException('Invalid server certificate');
    case DioExceptionType.unknown:
      if (error.error is SocketException) {
        return ServerException('No internet connection');
      }
      return ServerException(error.message ?? 'An unexpected error occurred');
  }
}
