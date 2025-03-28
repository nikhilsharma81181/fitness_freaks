/// Base interface for HTTP request interceptors
abstract class RequestInterceptor {
  /// Intercepts and potentially modifies a request before it is sent
  ///
  /// [path] is the request path
  /// [method] is the HTTP method (GET, POST, etc.)
  /// [headers] are the current request headers
  /// [queryParameters] are the current query parameters
  /// [data] is the request body (for POST, PUT, etc.)
  ///
  /// Returns a [ModifiedRequest] with potentially updated request parameters
  Future<ModifiedRequest> intercept({
    required String path,
    required String method,
    required Map<String, String>? headers,
    required Map<String, dynamic>? queryParameters,
    required dynamic data,
  });
}

/// Model representing a modified HTTP request
class ModifiedRequest {
  final String path;
  final String method;
  final Map<String, String>? headers;
  final Map<String, dynamic>? queryParameters;
  final dynamic data;

  ModifiedRequest({
    required this.path,
    required this.method,
    this.headers,
    this.queryParameters,
    this.data,
  });
}

/// Base interface for HTTP response interceptors
abstract class ResponseInterceptor {
  /// Intercepts and potentially modifies a response after it is received
  ///
  /// [response] is the raw response data
  /// [statusCode] is the HTTP status code
  /// [headers] are the response headers
  /// [requestPath] is the original request path
  /// [requestMethod] is the original HTTP method
  ///
  /// Returns a [ModifiedResponse] with potentially updated response data
  Future<ModifiedResponse> intercept({
    required dynamic response,
    required int statusCode,
    required Map<String, dynamic> headers,
    required String requestPath,
    required String requestMethod,
  });
}

/// Model representing a modified HTTP response
class ModifiedResponse {
  final dynamic data;
  final int statusCode;
  final Map<String, dynamic> headers;

  ModifiedResponse({
    required this.data,
    required this.statusCode,
    required this.headers,
  });
}

/// Interface for error handling interceptors
abstract class ErrorInterceptor {
  /// Intercepts and potentially transforms errors that occur during HTTP requests
  ///
  /// [error] is the error that occurred
  /// [requestPath] is the original request path
  /// [requestMethod] is the original HTTP method
  ///
  /// Returns the same error or a transformed/wrapped error
  Future<Exception> intercept({
    required Exception error,
    required String requestPath,
    required String requestMethod,
  });
}
