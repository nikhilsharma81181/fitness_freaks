/// Exception thrown when there is a server error
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = 'Server error occurred', this.statusCode});
  
  @override
  String toString() => 'ServerException: $message (Status code: $statusCode)';
}

/// Exception thrown when there is a cache error
class CacheException implements Exception {
  final String message;

  CacheException({this.message = 'Cache error occurred'});
  
  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when there is a network error (no internet)
class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'Network error occurred'});
  
  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when a resource is not found
class NotFoundException implements Exception {
  final String message;
  final String? resourceType;
  final String? resourceId;

  NotFoundException({
    this.message = 'Resource not found',
    this.resourceType,
    this.resourceId,
  });
  
  @override
  String toString() {
    if (resourceType != null && resourceId != null) {
      return 'NotFoundException: $resourceType with id $resourceId not found';
    }
    return 'NotFoundException: $message';
  }
}

/// Exception thrown when there is an authentication error
class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException({this.message = 'Authentication error occurred', this.code});
  
  @override
  String toString() => 'AuthException: $message (Code: $code)';
}

/// Exception thrown when there is a validation error
class ValidationException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;

  ValidationException({
    this.message = 'Validation error occurred',
    this.fieldErrors,
  });
  
  @override
  String toString() {
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      return 'ValidationException: $message, Field errors: $fieldErrors';
    }
    return 'ValidationException: $message';
  }
}

/// Exception thrown when a permission is denied
class PermissionException implements Exception {
  final String message;
  final String? permission;

  PermissionException({
    this.message = 'Permission denied',
    this.permission,
  });
  
  @override
  String toString() {
    if (permission != null) {
      return 'PermissionException: $message for permission $permission';
    }
    return 'PermissionException: $message';
  }
}
