import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_freaks/core/error/exceptions.dart';
import 'package:fitness_freaks/features/user/data/models/user_model.dart';
import 'package:dio/dio.dart';

import 'package:fitness_freaks/core/constant/endpoints/endpoints.dart';

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
  Future<String> exchangeFirebaseTokenForJWT(String firebaseToken);
}

class FirebaseAuthService implements AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final SharedPreferences _prefs;
  final Dio _dio;

  FirebaseAuthService({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required SharedPreferences prefs,
    required Dio dio,
  }) : _firebaseAuth = firebaseAuth,
       _prefs = prefs,
       _dio = dio;

  @override
  Stream<UserModel?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map((firebase_auth.User? user) {
      if (user != null) {
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
    return _mapFirebaseUserToUserModel(user);
  }

  @override
  Future<String?> getToken() async {
    return _prefs.getString('auth_token');
  }

  @override
  Future<void> saveToken(String token) async {
    log("Saving auth token: ${token.substring(0, min(10, token.length))}...");
    await _prefs.setString('auth_token', token);
  }

  // In the implementation:
  @override
  Future<String> exchangeFirebaseTokenForJWT(String firebaseToken) async {
    try {
      print("Exchanging Firebase token for JWT");
      // Use the correct endpoint from your Endpoint class
      // Make sure to import your Endpoint class
      const String endpoint = Endpoint.googleSSO; // Use your actual endpoint

      final response = await _dio.post(
        endpoint,
        data: {"idToken": firebaseToken},
      );

      print("Token exchange response status: ${response.statusCode}");

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['token'] != null) {
        final jwtToken = response.data['token'];
        print("Received JWT token");

        // Save the token in shared preferences
        await saveToken(jwtToken);

        return jwtToken;
      } else {
        print("Invalid response from token exchange: ${response.data}");
        throw ServerException(message: "Invalid response from token exchange");
      }
    } catch (e) {
      print("Error exchanging token: $e");
      throw ServerException(message: "Failed to exchange token: $e");
    }
  }

  UserModel _mapFirebaseUserToUserModel(firebase_auth.User user) {
    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      profileImageUrl: user.photoURL ?? '',
      fitnessLevel: 1,
      goals: [],
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

  int min(int a, int b) {
    return a < b ? a : b;
  }
}
