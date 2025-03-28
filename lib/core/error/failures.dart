import 'package:equatable/equatable.dart';

/// Base failure class for domain layer errors
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  
  const Failure({
    required this.message,
    this.statusCode,
  });
  
  @override
  List<Object?> get props => [message, statusCode];
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

/// Network connection failures
class ConnectionFailure extends Failure {
  const ConnectionFailure({
    String message = 'No internet connection',
  }) : super(message: message);
}

/// Authentication failures
class AuthFailure extends Failure {
  final AuthFailureType type;
  
  const AuthFailure({
    required String message,
    this.type = AuthFailureType.unknown,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
  
  @override
  List<Object?> get props => [message, statusCode, type];
}

/// Types of authentication failures
enum AuthFailureType {
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

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
  }) : super(message: message);
}

/// Input validation failures
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;
  
  const ValidationFailure({
    required String message,
    this.errors,
  }) : super(message: message);
  
  @override
  List<Object?> get props => [message, errors];
}

/// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    required String message,
  }) : super(message: message);
}

/// Timeout failures
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String message = 'Request timed out',
  }) : super(message: message);
}
