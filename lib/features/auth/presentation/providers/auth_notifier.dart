import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/usecases/get_auth_status.dart';
import '../../domain/usecases/refresh_token.dart';
import '../../domain/usecases/sign_in_with_apple.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import 'auth_state.dart';

/// Notifier for authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  final SignInWithGoogle _signInWithGoogle;
  final SignInWithApple _signInWithApple;
  final SignOut _signOut;
  final GetAuthStatus _getAuthStatus;
  final RefreshToken _refreshToken;
  
  AuthNotifier({
    required SignInWithGoogle signInWithGoogle,
    required SignInWithApple signInWithApple,
    required SignOut signOut,
    required GetAuthStatus getAuthStatus,
    required RefreshToken refreshToken,
  })  : _signInWithGoogle = signInWithGoogle,
        _signInWithApple = signInWithApple,
        _signOut = signOut,
        _getAuthStatus = getAuthStatus,
        _refreshToken = refreshToken,
        super(AuthState.initial()) {
    // Check the authentication status when created
    checkAuthStatus();
  }
  
  /// Check authentication status
  Future<void> checkAuthStatus() async {
    state = AuthState.loading();
    
    final result = await _getAuthStatus(NoParams());
    
    state = result.fold(
      (failure) => AuthState.error(_mapFailureToMessage(failure)),
      (isAuthenticated) => isAuthenticated
          ? AuthState.authenticated()
          : AuthState.unauthenticated(),
    );
  }
  
  /// Sign in with Google
  Future<AuthToken?> signInWithGoogle() async {
    state = AuthState.loading();
    
    final result = await _signInWithGoogle(NoParams());
    
    return result.fold(
      (failure) {
        state = AuthState.error(_mapFailureToMessage(failure));
        return null;
      },
      (token) {
        state = AuthState.authenticated();
        return token;
      },
    );
  }
  
  /// Sign in with Apple
  Future<AuthToken?> signInWithApple() async {
    // Apple Sign-In is not yet implemented
    // Just return an error message
    state = AuthState.error('Apple Sign-In will be available soon');
    return null;
    
    /* COMMENTED OUT: Apple Authentication Implementation
    state = AuthState.loading();
    
    final result = await _signInWithApple(NoParams());
    
    return result.fold(
      (failure) {
        state = AuthState.error(_mapFailureToMessage(failure));
        return null;
      },
      (token) {
        state = AuthState.authenticated();
        return token;
      },
    );
    */
  }
  
  /// Sign out
  Future<bool> signOut() async {
    state = state.copyWith(isLoggingOut: true);
    
    final result = await _signOut(NoParams());
    
    final success = result.fold(
      (failure) {
        state = AuthState.error(_mapFailureToMessage(failure));
        return false;
      },
      (_) {
        state = AuthState.unauthenticated();
        return true;
      },
    );
    
    return success;
  }
  
  /// Refresh token
  Future<AuthToken?> refreshAuthToken() async {
    final result = await _refreshToken(NoParams());
    
    return result.fold(
      (failure) {
        // If the refresh fails because the user is not authenticated,
        // update the state to unauthenticated
        if (failure is AuthFailure &&
            failure.type == AuthFailureType.unauthorized) {
          state = AuthState.unauthenticated();
        }
        return null;
      },
      (token) => token,
    );
  }
  
  /// Save biometric consent
  void saveBiometricConsent(bool consent) {
    state = state.copyWith(biometricConsent: consent);
  }
  
  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    debugPrint('Auth Failure: ${failure.runtimeType} - ${failure.message}');
    
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case ConnectionFailure:
        return 'No internet connection. Please check your connection.';
      case CacheFailure:
        return 'Cache error. Please try again.';
      case AuthFailure:
        final authFailure = failure as AuthFailure;
        switch (authFailure.type) {
          case AuthFailureType.invalidCredentials:
            return 'Invalid credentials. Please try again.';
          case AuthFailureType.unauthorized:
            return 'Unauthorized. Please sign in again.';
          default:
            return authFailure.message;
        }
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
