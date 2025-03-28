import 'package:equatable/equatable.dart';

/// Authentication status
enum AuthStatus {
  /// Initial state, authentication has not been checked yet
  initial,
  
  /// Authentication check is in progress
  loading,
  
  /// User is authenticated
  authenticated,
  
  /// User is not authenticated
  unauthenticated,
  
  /// Authentication error
  error,
}

/// Authentication state
class AuthState extends Equatable {
  final AuthStatus status;
  final bool? biometricConsent;
  final bool isLoggingOut;
  final String? errorMessage;
  
  const AuthState({
    this.status = AuthStatus.initial,
    this.biometricConsent,
    this.isLoggingOut = false,
    this.errorMessage,
  });
  
  /// Initial state
  factory AuthState.initial() => const AuthState(
    status: AuthStatus.initial,
  );
  
  /// Loading state
  factory AuthState.loading() => const AuthState(
    status: AuthStatus.loading,
  );
  
  /// Authenticated state
  factory AuthState.authenticated({bool? biometricConsent}) => AuthState(
    status: AuthStatus.authenticated,
    biometricConsent: biometricConsent,
  );
  
  /// Unauthenticated state
  factory AuthState.unauthenticated() => const AuthState(
    status: AuthStatus.unauthenticated,
  );
  
  /// Error state
  factory AuthState.error(String message) => AuthState(
    status: AuthStatus.error,
    errorMessage: message,
  );
  
  /// Create a copy with updated fields
  AuthState copyWith({
    AuthStatus? status,
    bool? biometricConsent,
    bool? isLoggingOut,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      biometricConsent: biometricConsent ?? this.biometricConsent,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  /// Check if the user is authenticated
  bool get isAuthenticated => status == AuthStatus.authenticated;
  
  @override
  List<Object?> get props => [
    status,
    biometricConsent,
    isLoggingOut,
    errorMessage,
  ];
}
