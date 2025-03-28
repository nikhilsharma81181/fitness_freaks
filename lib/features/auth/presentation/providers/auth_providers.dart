import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/network/api_providers.dart';
import '../../../../core/network/connection_checker.dart';
import '../../data/datasource/local/auth_local_datasource.dart';
import '../../data/datasource/remote/apple_auth_datasource.dart';
import '../../data/datasource/remote/auth_remote_datasource.dart';
import '../../data/datasource/remote/google_auth_datasource.dart';
import '../../data/repositories/apple_auth_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/google_auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_auth_status.dart';
import '../../domain/usecases/refresh_token.dart';
import '../../domain/usecases/sign_in_with_apple.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

/// Provider for GoogleSignIn
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

/// Provider for FirebaseAuth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Provider for AuthLocalDataSource
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl();
});

/// Provider for GoogleAuthDataSource
final googleAuthDataSourceProvider = Provider<GoogleAuthDataSource>((ref) {
  return GoogleAuthDataSourceImpl(
    ref.watch(googleSignInProvider),
    ref.watch(firebaseAuthProvider),
    ref.watch(apiClientProvider),
  );
});

/// Provider for AppleAuthDataSource
final appleAuthDataSourceProvider = Provider<AppleAuthDataSource>((ref) {
  return AppleAuthDataSourceImpl(
    ref.watch(firebaseAuthProvider),
    ref.watch(apiClientProvider),
  );
});

/// Provider for AuthRemoteDataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

/// Provider for GoogleAuthRepository
final googleAuthRepositoryProvider = Provider<GoogleAuthRepository>((ref) {
  return GoogleAuthRepositoryImpl(
    remoteDataSource: ref.watch(googleAuthDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    connectionChecker: ref.watch(connectionCheckerProvider),
  );
});

/// Provider for AppleAuthRepository
final appleAuthRepositoryProvider = Provider<AppleAuthRepository>((ref) {
  return AppleAuthRepositoryImpl(
    remoteDataSource: ref.watch(appleAuthDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    connectionChecker: ref.watch(connectionCheckerProvider),
  );
});

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    connectionChecker: ref.watch(connectionCheckerProvider),
    apiClient: ref.watch(apiClientProvider),
  );
});

/// Provider for SignInWithGoogle use case
final signInWithGoogleProvider = Provider<SignInWithGoogle>((ref) {
  return SignInWithGoogle(ref.watch(googleAuthRepositoryProvider));
});

/// Provider for SignInWithApple use case
final signInWithAppleProvider = Provider<SignInWithApple>((ref) {
  return SignInWithApple(ref.watch(appleAuthRepositoryProvider));
});

/// Provider for SignOut use case
final signOutProvider = Provider<SignOut>((ref) {
  return SignOut(ref.watch(authRepositoryProvider));
});

/// Provider for GetAuthStatus use case
final getAuthStatusProvider = Provider<GetAuthStatus>((ref) {
  return GetAuthStatus(ref.watch(authRepositoryProvider));
});

/// Provider for RefreshToken use case
final refreshTokenProvider = Provider<RefreshToken>((ref) {
  return RefreshToken(ref.watch(authRepositoryProvider));
});

/// Provider for AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    signInWithGoogle: ref.watch(signInWithGoogleProvider),
    signInWithApple: ref.watch(signInWithAppleProvider),
    signOut: ref.watch(signOutProvider),
    getAuthStatus: ref.watch(getAuthStatusProvider),
    refreshToken: ref.watch(refreshTokenProvider),
  );
});
