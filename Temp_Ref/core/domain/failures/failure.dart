import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
///
/// All failures should extend this class and provide a message that explains
/// the failure in a user-friendly way.
abstract class Failure extends Equatable {
  final String message;
  
  const Failure({this.message = 'An unexpected error occurred'});
  
  @override
  List<Object> get props => [message];
}

/// Failure related to server issues
class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server failure occurred'}) 
    : super(message: message);
}

/// Failure related to local cache issues
class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache failure occurred'}) 
    : super(message: message);
}

/// Failure related to network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Network failure occurred'}) 
    : super(message: message);
}

/// Failure related to validation errors
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;
  
  const ValidationFailure({
    String message = 'Validation failure occurred',
    this.fieldErrors,
  }) : super(message: message);
  
  @override
  List<Object> get props => [message, fieldErrors ?? {}];
}

/// Failure related to authentication issues
class AuthFailure extends Failure {
  const AuthFailure({String message = 'Authentication failure occurred'}) 
    : super(message: message);
}

/// Failure when a requested resource is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure({String message = 'Resource not found'}) 
    : super(message: message);
}

/// Failure when user doesn't have permission to access a resource
class PermissionFailure extends Failure {
  const PermissionFailure({String message = 'Permission denied'}) 
    : super(message: message);
}
