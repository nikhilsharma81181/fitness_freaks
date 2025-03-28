import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_token.dart';

/// Repository interface for Google authentication
abstract class GoogleAuthRepository {
  /// Sign in with Google
  Future<Either<Failure, AuthToken>> signInWithGoogle();
}

/// Repository interface for Apple authentication
abstract class AppleAuthRepository {
  /// Sign in with Apple
  Future<Either<Failure, AuthToken>> signInWithApple();
}

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Sign out
  Future<Either<Failure, void>> signOut();
  
  /// Get current authentication status
  Future<Either<Failure, bool>> isAuthenticated();
  
  /// Refresh token
  Future<Either<Failure, AuthToken>> refreshToken();
  
  /// Get current token
  Future<Either<Failure, AuthToken?>> getToken();
  
  /// Save token
  Future<Either<Failure, void>> saveToken(AuthToken token);
  
  /// Delete token
  Future<Either<Failure, void>> deleteToken();
}
