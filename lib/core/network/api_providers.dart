import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'api_client.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

/// Provider for the API client's base URL
final apiBaseUrlProvider = Provider<String>((ref) {
  // This can be switched between development and production URLs
  const useProduction = false;

  if (useProduction) {
    return 'https://fitness-0j1s.onrender.com';
  } else {
    // return 'http://localhost:9090';
    return 'https://fitness-0j1s.onrender.com';
  }
});

/// Provider for API client with all the necessary interceptors
final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);

  // Create a plain Dio instance for the auth interceptor
  final authDio = Dio(BaseOptions(baseUrl: baseUrl));

  // Create the API client
  final apiClient = ApiClient(
    baseUrl: baseUrl,
    timeout: const Duration(seconds: 60),
    interceptors: [
      LoggingInterceptor(),
      AuthInterceptor(authDio),
      RetryInterceptor(Dio()),
    ],
  );

  return apiClient;
});

/// Provider for the raw Dio instance for direct access if needed
final dioProvider = Provider<Dio>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return apiClient.dio;
});
