/// An abstract interface for HTTP clients.
///
/// This interface defines the contract for HTTP clients in the application,
/// allowing the concrete implementation to be swapped without affecting
/// the rest of the codebase.
abstract class HttpClient {
  /// Performs a GET request to the specified URL.
  ///
  /// [path] is the path to the resource, which will be appended to the base URL.
  /// [queryParameters] are optional query parameters to include in the request.
  /// [headers] are optional headers to include in the request.
  Future<HttpResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Performs a POST request to the specified URL.
  ///
  /// [path] is the path to the resource, which will be appended to the base URL.
  /// [data] is the body of the request.
  /// [queryParameters] are optional query parameters to include in the request.
  /// [headers] are optional headers to include in the request.
  Future<HttpResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Performs a PUT request to the specified URL.
  ///
  /// [path] is the path to the resource, which will be appended to the base URL.
  /// [data] is the body of the request.
  /// [queryParameters] are optional query parameters to include in the request.
  /// [headers] are optional headers to include in the request.
  Future<HttpResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Performs a PATCH request to the specified URL.
  ///
  /// [path] is the path to the resource, which will be appended to the base URL.
  /// [data] is the body of the request.
  /// [queryParameters] are optional query parameters to include in the request.
  /// [headers] are optional headers to include in the request.
  Future<HttpResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Performs a DELETE request to the specified URL.
  ///
  /// [path] is the path to the resource, which will be appended to the base URL.
  /// [data] is the optional body of the request.
  /// [queryParameters] are optional query parameters to include in the request.
  /// [headers] are optional headers to include in the request.
  Future<HttpResponse> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Updates the authentication token used by the client.
  ///
  /// [token] is the new token to use for authenticated requests.
  void updateToken(String token);

  /// Removes the authentication token from the client.
  void removeToken();
}

/// A class representing an HTTP response.
class HttpResponse {
  /// The HTTP status code.
  final int statusCode;

  /// The response body.
  final dynamic data;

  /// The response headers.
  final Map<String, dynamic> headers;

  HttpResponse({
    required this.statusCode,
    required this.data,
    this.headers = const {},
  });

  /// Returns true if the response is successful (status code 2xx).
  bool get isSuccessful => statusCode >= 200 && statusCode < 300;

  /// Returns true if the response is a client error (status code 4xx).
  bool get isClientError => statusCode >= 400 && statusCode < 500;

  /// Returns true if the response is a server error (status code 5xx).
  bool get isServerError => statusCode >= 500 && statusCode < 600;

  /// Returns true if the response is unauthorized (status code 401).
  bool get isUnauthorized => statusCode == 401;

  /// Returns true if the response is forbidden (status code 403).
  bool get isForbidden => statusCode == 403;

  /// Returns true if the response is not found (status code 404).
  bool get isNotFound => statusCode == 404;
}
