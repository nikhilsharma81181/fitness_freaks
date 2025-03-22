import 'dart:developer';

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
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'providers.g.dart';

// Network providers
class DioNotifier extends StateNotifier<Dio> {
  final Ref ref;

  DioNotifier(this.ref) : super(_createDio()) {
    _setupAuthListener();
  }

  static Dio _createDio() {
    return Dio(
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
  }

  void _setupAuthListener() async {
    try {
      final authService = await ref.read(authServiceProvider.future);
      authService.onAuthStateChanged.listen((user) async {
        if (user != null) {
          final token = await authService.getToken();
          if (token != null) {
            updateToken(token);
          }
        } else {
          // Remove token when signed out
          removeToken();
        }
      });

      // Check for existing token on initialization
      final token = await authService.getToken();
      if (token != null) {
        updateToken(token);
      }
    } catch (e) {
      log("Error setting up auth listener for Dio: $e");
    }
  }

  void updateToken(String token) {
    final headers = <String, dynamic>{
      ...state.options.headers,
      'Authorization': 'Bearer $token',
    };

    final options = state.options.copyWith(headers: headers);
    state = Dio(options);
    log("Token updated: ${token.substring(0, 10)}...");
  }

  void removeToken() {
    final headers = Map<String, dynamic>.from(state.options.headers);
    headers.remove('Authorization');

    final options = state.options.copyWith(headers: headers);
    state = Dio(options);
    log("Token removed from Dio headers");
  }
}

final dioProvider = StateNotifierProvider<DioNotifier, Dio>((ref) {
  return DioNotifier(ref);
});

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
  final auth = firebase_auth.FirebaseAuth.instance;
  // Ensure persistence is set to LOCAL (this is the default, but let's be explicit)
  auth.setPersistence(firebase_auth.Persistence.LOCAL);
  return auth;
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
    googleSignIn: ref.watch(googleSignInProvider),
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

@riverpod
GoogleSignIn googleSignIn(GoogleSignInRef ref) {
  return GoogleSignIn(
    scopes: ['email', 'profile'],
    signInOption: SignInOption.standard,
    // Uncomment and add your web client ID from Firebase console if needed
    // webClientId: 'YOUR_WEB_CLIENT_ID_HERE',
  );
}
