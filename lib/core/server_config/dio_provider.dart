import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../network/api_client.dart';
import '../storage/utils/secure_storage_helper.dart';

/// Legacy DioProvider for backward compatibility
/// 
/// This is kept for backward compatibility with existing code
/// New code should use apiClientProvider from core/network/api_providers.dart
final dioProvider = StateNotifierProvider<DioNotifier, Dio>((ref) {
  return DioNotifier();
});

class DioNotifier extends StateNotifier<Dio> {
  DioNotifier() : super(_createDio());

  static Dio _createDio() {
    var dio = Dio();
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.baseUrl = "http://localhost:9090";
    // dio.options.baseUrl = "https://fitness-0j1s.onrender.com";

    // Add default headers
    SecureStorageHelper.getAuthToken().then((token) {
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
    });
    
    return dio;
  }

  void updateToken({required String newToken}) {
    if (newToken.isNotEmpty) {
      state.options.headers['Authorization'] = 'Bearer $newToken';
      // Also update secure storage
      SecureStorageHelper.saveAuthToken(newToken);
    } else {
      state.options.headers.remove('Authorization');
      // Clear token from secure storage
      SecureStorageHelper.deleteAuthToken();
    }
  }
}
