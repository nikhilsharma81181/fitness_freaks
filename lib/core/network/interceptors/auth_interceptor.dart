import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../storage/utils/secure_storage_helper.dart';

/// Interceptor for handling authentication
/// - Adds authorization header to requests
/// - Handles token refresh on 401 errors
class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final String _refreshEndpoint;
  bool _isRefreshing = false;
  
  // Queue of requests that are waiting for token refresh
  final _pendingRequests = <RequestOptions>[];
  
  AuthInterceptor(this._dio, {String refreshEndpoint = '/auth/refresh'})
      : _refreshEndpoint = refreshEndpoint;
  
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip authorization header for auth endpoints
    if (options.path.contains('/auth/')) {
      return handler.next(options);
    }
    
    final token = await SecureStorageHelper.getAuthToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    return handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      // Don't try to refresh if we're already refreshing or if the error is from the refresh endpoint
      if (_isRefreshing || err.requestOptions.path.contains(_refreshEndpoint)) {
        return handler.next(err);
      }
      
      // Try to refresh the token
      final refreshedToken = await _refreshToken();
      if (refreshedToken != null) {
        // Retry the original request with the new token
        return _retry(err.requestOptions, handler);
      }
    }
    
    // For other errors, just pass them through
    return handler.next(err);
  }
  
  /// Refresh the token
  Future<String?> _refreshToken() async {
    _isRefreshing = true;
    
    try {
      // Get the refresh token
      final refreshToken = await SecureStorageHelper.getRefreshToken();
      if (refreshToken == null) {
        return null;
      }
      
      // Call the refresh endpoint
      final response = await _dio.post(
        _refreshEndpoint,
        data: {'refreshToken': refreshToken},
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final newToken = response.data['token'];
        
        // Save the new token
        await SecureStorageHelper.saveAuthToken(newToken);
        
        // Process any pending requests
        _processPendingRequests(newToken);
        
        return newToken;
      }
      
      return null;
    } catch (e) {
      debugPrint('Error refreshing token: $e');
      return null;
    } finally {
      _isRefreshing = false;
    }
  }
  
  /// Process requests that were waiting for token refresh
  void _processPendingRequests(String token) {
    _pendingRequests.forEach((request) {
      request.headers['Authorization'] = 'Bearer $token';
      _dio.fetch(request);
    });
    _pendingRequests.clear();
  }
  
  /// Retry a request with the updated token
  Future<void> _retry(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    final token = await SecureStorageHelper.getAuthToken();
    if (token == null) {
      return handler.reject(
        DioException(
          requestOptions: requestOptions,
          error: 'No token available',
          type: DioExceptionType.unknown,
        ),
      );
    }
    
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $token',
      },
    );
    
    try {
      final response = await _dio.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options,
      );
      
      handler.resolve(response);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: requestOptions,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
}
