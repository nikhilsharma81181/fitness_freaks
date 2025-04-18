/// Base exception class for data layer errors
class AppException implements Exception {
  final String message;
  final int? statusCode;
  
  AppException(this.message, {this.statusCode});
  
  @override
  String toString() => message;
}

/// Network-related exceptions
class ServerException extends AppException {
  ServerException(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}

/// Authentication exceptions
class AuthException extends AppException {
  final AuthExceptionType type;
  
  AuthException(
    String message, {
    this.type = AuthExceptionType.unknown,
    int? statusCode,
  }) : super(message, statusCode: statusCode);
}

/// Types of authentication exceptions
enum AuthExceptionType {
  /// Invalid credentials
  invalidCredentials,
  
  /// Expired token
  expiredToken,
  
  /// Unauthorized access
  unauthorized,
  
  /// User not found
  userNotFound,
  
  /// Account disabled
  accountDisabled,
  
  /// Unknown error
  unknown,
}

/// Cache-related exceptions
class CacheException extends AppException {
  CacheException(String message) : super(message);
}

/// Local storage exceptions
class StorageException extends AppException {
  StorageException(String message) : super(message);
}

/// Network connectivity exceptions
class ConnectivityException extends AppException {
  ConnectivityException([String message = 'No internet connection'])
      : super(message);
}

/// Timeout exceptions
class TimeoutException extends AppException {
  TimeoutException([String message = 'Request timed out']) : super(message);
}

/// Format exceptions
class FormatException extends AppException {
  FormatException(String message) : super(message);
}

/// Permission exceptions
class PermissionException extends AppException {
  PermissionException(String message) : super(message);
}
