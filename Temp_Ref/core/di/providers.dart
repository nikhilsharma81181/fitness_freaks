import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fitness_freaks/core/constant/endpoints/endpoints.dart'
    as app_endpoints;
import 'package:fitness_freaks/core/services/app_initializer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Use only one endpoints import to avoid conflicts
// import '../constants/endpoints.dart';
import '../data/datasources/local/local_storage.dart';
import '../data/datasources/remote/http_client.dart';
import '../data/datasources/remote/network_info.dart';
import '../infrastructure/local_storage/storage_encryption.dart';
import '../infrastructure/network/dio_client.dart';
import '../infrastructure/network/network_info_impl.dart';
import '../infrastructure/services/logger_service.dart';
import '../storage/utils/secure_storage_helper.dart';

/// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  // This uses FutureProvider's .future property to synchronously access the value
  // Make sure to properly initialize this before app startup
  throw UnimplementedError(
      'Initialize in main.dart with ref.read(sharedPreferencesProvider.future)');
});

/// Provider for Connectivity
final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

/// Provider for NetworkInfo
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return NetworkInfoImpl(connectivity);
});

/// Provider for storage encryption
final storageEncryptionProvider = Provider<StorageEncryption>((ref) {
  return BasicEncryption();
});

/// Provider for LocalStorage
/// This is a placeholder until a proper implementation is added
final localStorageProvider = Provider<LocalStorage>((ref) {
  throw UnimplementedError('Storage implementation needs to be added');
});

/// Legacy DioProvider for backward compatibility
/// This can be used by existing code until migration to httpClientProvider is complete
///
/// IMPORTANT: For new code, please use httpClientProvider instead of dioProvider
/// This provider is kept for backward compatibility only
final dioProvider = StateNotifierProvider<DioNotifier, Dio>((ref) {
  return DioNotifier();
});

class DioNotifier extends StateNotifier<Dio> {
  DioNotifier() : super(_createDio());

  static Dio _createDio() {
    var dio = Dio();
    dio.options.receiveTimeout = const Duration(seconds: 30);
    // dio.options.baseUrl = "http://localhost:9090";
    dio.options.baseUrl = "https://fitness-0j1s.onrender.com";

    // Add default headers
    SecureStorageHelper.getAuthToken().then((token) {
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
        logger.i('Token added to headers: $token');
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

/// Provider for HttpClient
///
/// RECOMMENDED: Use this provider for all new network requests
/// This provides a more structured approach to network requests with better error handling
final httpClientProvider = Provider<HttpClient>((ref) {
  return DioClient(
    baseUrl:
        "http://localhost:9090", // Use the same baseUrl as in legacy provider
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    // TODO: Fix token interceptor after checking the expected type for requestInterceptors
    requestInterceptors: [],
    responseInterceptors: [],
    errorInterceptors: [],
    logRequests: true, // Consider setting based on environment
  );
});

/// Provider for LoggerService
final loggerServiceProvider = Provider<LoggerService>((ref) {
  return const LoggerService(
    enableVerbose: true, // Consider setting based on environment
    enableInfo: true,
    enableWarning: true,
    enableError: true,
  );
});

/// MIGRATION GUIDE:
/// 
/// To migrate from dioProvider to httpClientProvider:
/// 
/// 1. Replace:
///    final dio = ref.read(dioProvider);
///    dio.get('/endpoint');
/// 
/// 2. With:
///    final client = ref.read(httpClientProvider);
///    client.get('/endpoint');
/// 
/// 3. For token management, replace:
///    ref.read(dioProvider.notifier).updateToken('token');
/// 
/// 4. With:
///    ref.read(httpClientProvider).updateToken('token');
