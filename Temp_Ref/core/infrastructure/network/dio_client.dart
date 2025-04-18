import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../data/datasources/remote/http_client.dart';
import '../../data/datasources/remote/interceptors.dart';
import '../../data/exceptions.dart';

/// Implementation of HttpClient using Dio
class DioClient implements HttpClient {
  final Dio _dio;
  final List<RequestInterceptor> _requestInterceptors;
  final List<ResponseInterceptor> _responseInterceptors;
  
  DioClient({
    required String baseUrl,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 15),
    Map<String, String>? headers,
    List<RequestInterceptor> requestInterceptors = const [],
    List<ResponseInterceptor> responseInterceptors = const [],
    List<ErrorInterceptor> errorInterceptors = const [],
    bool logRequests = false,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
            headers: headers ?? {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ),
        _requestInterceptors = requestInterceptors,
        _responseInterceptors = responseInterceptors {
    // Add logging interceptor if needed
    if (logRequests) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
    
    // Add custom interceptor to handle our interceptor interfaces
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _handleRequest,
        onResponse: _handleResponse,
        onError: _handleError,
      ),
    );
  }
  
  @override
  Future<HttpResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return HttpResponse(
        statusCode: response.statusCode ?? 500,
        data: response.data,
        headers: response.headers.map,
      );
    } catch (e) {
      throw _handleDioError(e, path, 'GET');
    }
  }
  
  @override
  Future<HttpResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return HttpResponse(
        statusCode: response.statusCode ?? 500,
        data: response.data,
        headers: response.headers.map,
      );
    } catch (e) {
      throw _handleDioError(e, path, 'POST');
    }
  }
  
  @override
  Future<HttpResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return HttpResponse(
        statusCode: response.statusCode ?? 500,
        data: response.data,
        headers: response.headers.map,
      );
    } catch (e) {
      throw _handleDioError(e, path, 'PUT');
    }
  }
  
  @override
  Future<HttpResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return HttpResponse(
        statusCode: response.statusCode ?? 500,
        data: response.data,
        headers: response.headers.map,
      );
    } catch (e) {
      throw _handleDioError(e, path, 'PATCH');
    }
  }
  
  @override
  Future<HttpResponse> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return HttpResponse(
        statusCode: response.statusCode ?? 500,
        data: response.data,
        headers: response.headers.map,
      );
    } catch (e) {
      throw _handleDioError(e, path, 'DELETE');
    }
  }
  
  @override
  void updateToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
  
  @override
  void removeToken() {
    _dio.options.headers.remove('Authorization');
  }
  
  /// Handle request interception
  void _handleRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_requestInterceptors.isEmpty) {
      handler.next(options);
      return;
    }
    
    var currentPath = options.path;
    var currentMethod = options.method;
    var currentHeaders = Map<String, String>.from(options.headers);
    var currentQueryParams = options.queryParameters;
    var currentData = options.data;
    
    // Apply all request interceptors in sequence
    for (final interceptor in _requestInterceptors) {
      final result = await interceptor.intercept(
        path: currentPath,
        method: currentMethod,
        headers: currentHeaders,
        queryParameters: currentQueryParams,
        data: currentData,
      );
      
      currentPath = result.path;
      currentMethod = result.method;
      currentHeaders = result.headers ?? currentHeaders;
      currentQueryParams = result.queryParameters ?? currentQueryParams;
      currentData = result.data ?? currentData;
    }
    
    // Update the options with the modified values
    options.path = currentPath;
    options.method = currentMethod;
    options.headers = currentHeaders;
    options.queryParameters = currentQueryParams;
    options.data = currentData;
    
    handler.next(options);
  }
  
  /// Handle response interception
  void _handleResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (_responseInterceptors.isEmpty) {
      handler.next(response);
      return;
    }
    
    var currentData = response.data;
    var currentStatusCode = response.statusCode ?? 500;
    
    // Convert to Map<String, dynamic> as required by ResponseInterceptor
    Map<String, dynamic> currentHeaders = {};
    
    // Convert Dio headers to Map<String, dynamic>
    response.headers.map.forEach((key, values) {
      // For simplicity, we'll use the first value if it's a list
      // or the value itself if it's not a list
      if (values is List && values.isNotEmpty) {
        currentHeaders[key] = values.map((v) => v.toString()).join(', ');
      } else if (values is String) {
        currentHeaders[key] = values;
      } else if (values != null) {
        currentHeaders[key] = values.toString();
      } else {
        currentHeaders[key] = "";
      }
    });
    
    // Apply all response interceptors in sequence
    for (final interceptor in _responseInterceptors) {
      final result = await interceptor.intercept(
        response: currentData,
        statusCode: currentStatusCode,
        headers: currentHeaders,
        requestPath: response.requestOptions.path,
        requestMethod: response.requestOptions.method,
      );
      
      currentData = result.data;
      currentStatusCode = result.statusCode;
      currentHeaders = result.headers;
    }
    
    // Update the response with the modified values
    response.data = currentData;
    response.statusCode = currentStatusCode;
    response.headers.map.clear();
    
    // Add headers back to the response as individual strings
    currentHeaders.forEach((key, value) {
      // Convert any complex value to string
      final stringValue = value.toString();
      response.headers.set(key, stringValue);
    });
    
    handler.next(response);
  }
  
  /// Handle error interception
  void _handleError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    // Simply pass the error through
    handler.next(error);
  }
  
  /// Convert Dio errors to our own exception types
  Exception _handleDioError(Object error, String path, String method) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkException(message: 'Connection timeout');
        
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          
          if (statusCode == 401) {
            return AuthException(
              message: 'Unauthorized',
              code: 'UNAUTHORIZED',
            );
          } else if (statusCode == 403) {
            return PermissionException(
              message: 'Permission denied',
            );
          } else if (statusCode == 404) {
            return NotFoundException(
              message: 'Resource not found',
              resourceId: path,
            );
          } else if (statusCode != null && statusCode >= 500) {
            return ServerException(
              message: 'Server error occurred',
              statusCode: statusCode,
            );
          } else {
            return ServerException(
              message: 'Request failed with status: $statusCode',
              statusCode: statusCode,
            );
          }
        
        case DioExceptionType.cancel:
          return ServerException(message: 'Request was cancelled');
        
        case DioExceptionType.connectionError:
          return NetworkException(message: 'No internet connection');
        
        case DioExceptionType.badCertificate:
          return ServerException(message: 'Invalid SSL certificate');
        
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return NetworkException(message: 'No internet connection');
          }
          return ServerException(message: 'Unexpected error occurred: ${error.message}');
      }
    }
    
    return ServerException(message: 'Unknown error: $error');
  }
}