import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor for logging network requests and responses
class LoggingInterceptor extends Interceptor {
  final bool logRequestBody;
  final bool logResponseBody;
  
  LoggingInterceptor({
    this.logRequestBody = kDebugMode,
    this.logResponseBody = kDebugMode,
  });
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method;
    final baseUrl = options.baseUrl;
    final path = options.path;
    final url = baseUrl + path;
    
    log('┌─────────────────────────────────────────────────────');
    log('│ 🚀 REQUEST: $method $path');
    log('│ 🔗 URL: $url');
    log('│ 📋 Headers: ${_formatHeaders(options.headers)}');
    
    if (logRequestBody && options.data != null) {
      log('│ 📦 Body: ${_formatData(options.data)}');
    }
    
    log('└─────────────────────────────────────────────────────');
    
    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final method = response.requestOptions.method;
    final path = response.requestOptions.path;
    final statusCode = response.statusCode;
    
    log('┌─────────────────────────────────────────────────────');
    log('│ ✅ RESPONSE: $method $path');
    log('│ 🔢 Status: $statusCode');
    
    if (logResponseBody && response.data != null) {
      log('│ 📦 Body: ${_formatData(response.data)}');
    }
    
    log('└─────────────────────────────────────────────────────');
    
    super.onResponse(response, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final method = err.requestOptions.method;
    final path = err.requestOptions.path;
    final statusCode = err.response?.statusCode;
    final errorType = err.type;
    final errorMessage = err.message;
    
    log('┌─────────────────────────────────────────────────────');
    log('│ ❌ ERROR: $method $path');
    log('│ 🔢 Status: $statusCode');
    log('│ 📋 Type: $errorType');
    log('│ 📝 Message: $errorMessage');
    
    if (err.response != null && logResponseBody && err.response?.data != null) {
      log('│ 📦 Response: ${_formatData(err.response?.data)}');
    }
    
    log('└─────────────────────────────────────────────────────');
    
    super.onError(err, handler);
  }
  
  /// Format headers for logging (hide sensitive data)
  String _formatHeaders(Map<String, dynamic> headers) {
    final formattedHeaders = Map<String, dynamic>.from(headers);
    
    // Hide sensitive headers
    if (formattedHeaders.containsKey('Authorization')) {
      formattedHeaders['Authorization'] = 'Bearer [HIDDEN]';
    }
    
    return formattedHeaders.toString();
  }
  
  /// Format data for logging (limit length for large payloads)
  String _formatData(dynamic data) {
    // Limit large data output
    const maxLength = 1000;
    final String stringData = data.toString();
    
    if (stringData.length > maxLength) {
      return '${stringData.substring(0, maxLength)}... [TRUNCATED]';
    }
    
    return stringData;
  }
}
