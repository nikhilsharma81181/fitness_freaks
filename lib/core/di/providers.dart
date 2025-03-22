import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:fitness_freaks/core/network/network_info.dart';
import 'package:fitness_freaks/features/user/data/datasources/auth_service.dart';
import 'package:fitness_freaks/features/user/data/datasources/user_remote_data_source.dart';
import 'package:fitness_freaks/features/user/data/repositories/user_repository_impl.dart';
import 'package:fitness_freaks/features/user/domain/repositories/user_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'providers.g.dart';

// Network providers
@riverpod
Dio dio(DioRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: "https://fitness-0j1s.onrender.com",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // You can add interceptors here for logging, auth tokens, etc.
  // dio.interceptors.add(LogInterceptor());

  return dio;
}

@riverpod
NetworkInfo networkInfo(NetworkInfoRef ref) {
  return NetworkInfoImpl();
}

// Firebase and Auth providers
@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) {
  return SharedPreferences.getInstance();
}

@riverpod
firebase_auth.FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return firebase_auth.FirebaseAuth.instance;
}

@riverpod
Future<AuthService> authService(AuthServiceRef ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return FirebaseAuthService(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    prefs: prefs,
  );
}

// Data sources providers
@riverpod
Future<UserRemoteDataSource> userRemoteDataSource(
  UserRemoteDataSourceRef ref,
) async {
  return UserRemoteDataSourceImpl(
    dio: ref.watch(dioProvider),
    authService: await ref.watch(authServiceProvider.future),
    firebaseAuth: ref.watch(firebaseAuthProvider),
    googleSignIn: GoogleSignIn(
      scopes: ['email', 'profile'],
      signInOption: SignInOption.standard,
    ),
  );
}

// Repository providers
@riverpod
Future<UserRepository> userRepository(UserRepositoryRef ref) async {
  return UserRepositoryImpl(
    remoteDataSource: await ref.watch(userRemoteDataSourceProvider.future),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
