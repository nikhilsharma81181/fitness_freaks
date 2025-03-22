import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_freaks/core/error/exceptions.dart';
import 'package:fitness_freaks/features/user/data/models/user_model.dart';

abstract class AuthService {
  Future<UserModel> signInWithEmailPassword(String email, String password);
  Future<UserModel> signUpWithEmailPassword(
    String email,
    String password,
    String name,
  );
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Stream<UserModel?> get onAuthStateChanged;
}

class FirebaseAuthService implements AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final SharedPreferences _prefs;

  FirebaseAuthService({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required SharedPreferences prefs,
  }) : _firebaseAuth = firebaseAuth,
       _prefs = prefs;

  @override
  Stream<UserModel?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map((firebase_auth.User? user) {
      if (user != null) {
        // Get and save token when auth state changes
        user.getIdToken().then((token) {
          if (token != null) {
            saveToken(token);
          }
        });
        return _mapFirebaseUserToUserModel(user);
      }
      return null;
    });
  }

  @override
  Future<UserModel> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw ServerException(message: 'Failed to sign in');
      }

      // Get token for API requests
      final token = await user.getIdToken();
      if (token != null) {
        await saveToken(token);
      }

      return _mapFirebaseUserToUserModel(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(
        message: _getFirebaseAuthErrorMessage(e.code),
        statusCode: 401,
      );
    } catch (e) {
      throw ServerException(message: 'Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw ServerException(message: 'Failed to create account');
      }

      // Update user display name
      await user.updateDisplayName(name);

      // Get token for API requests
      final token = await user.getIdToken();
      if (token != null) {
        await saveToken(token);
      }

      return _mapFirebaseUserToUserModel(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(
        message: _getFirebaseAuthErrorMessage(e.code),
        statusCode: 400,
      );
    } catch (e) {
      throw ServerException(message: 'Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _prefs.remove('auth_token');
    } catch (e) {
      throw ServerException(message: 'Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    // Refresh token
    final token = await user.getIdToken(true);
    if (token != null) {
      await saveToken(token);
    }

    return _mapFirebaseUserToUserModel(user);
  }

  @override
  Future<String?> getToken() async {
    return _prefs.getString('auth_token');
  }

  @override
  Future<void> saveToken(String token) async {
    print("Saving auth token: ${token.substring(0, 10)}...");
    await _prefs.setString('auth_token', token);
  }

  UserModel _mapFirebaseUserToUserModel(firebase_auth.User user) {
    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      profileImageUrl: user.photoURL ?? '',
      fitnessLevel: 1, // Default value
      goals: [], // Default empty goals
    );
  }

  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
