/// Exception thrown when there is a server error
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});
}

/// Exception thrown when there is a cache error
class CacheException implements Exception {
  final String message;

  CacheException({required this.message});
}

/// Exception thrown when there is a network error (no internet)
class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});
} 