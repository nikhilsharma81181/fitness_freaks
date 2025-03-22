import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitness_freaks/core/error/exceptions.dart';
import 'package:fitness_freaks/features/user/data/datasources/auth_service.dart';
import 'package:fitness_freaks/features/user/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

abstract class UserRemoteDataSource {
  /// Calls the backend API to get the current user profile
  /// Throws a [ServerException] for all error codes
  Future<UserModel> getCurrentUser();

  /// Calls the backend API to update the user profile
  /// Throws a [ServerException] for all error codes
  Future<UserModel> updateUser(UserModel user);

  /// Calls the backend API to sign in a user with email and password
  /// Throws a [ServerException] for all error codes
  Future<UserModel> signInWithEmailAndPassword(String email, String password);

  /// Calls the backend API to sign up a user with email and password
  /// Throws a [ServerException] for all error codes
  Future<UserModel> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  );

  /// Calls the backend API to sign out the user
  /// Throws a [ServerException] for all error codes
  Future<void> signOut();

  /// Calls the backend API to sign in a user with Google
  /// Throws a [ServerException] for all error codes
  Future<UserModel> signInWithGoogle();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;
  final AuthService authService;
  final firebase_auth.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  UserRemoteDataSourceImpl({
    required this.dio,
    required this.authService,
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      // First try to get user from Firebase Auth
      final firebaseUser = await authService.getCurrentUser();
      if (firebaseUser != null) {
        // If we have a Firebase user, try to get more user data from the API
        try {
          final response = await dio.get('/api/user/profile');
          return UserModel.fromJson(response.data);
        } catch (e) {
          // If API call fails, just return the basic Firebase user
          return firebaseUser;
        }
      }
      throw ServerException(message: 'User not authenticated');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Failed to get current user: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final token = await authService.getToken();
      if (token == null) {
        throw ServerException(message: 'Not authenticated');
      }

      final response = await dio.put('/api/user/profile', data: user.toJson());
      return UserModel.fromJson(response.data);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Failed to update user: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // First authenticate with Firebase
      final firebaseUser = await authService.signInWithEmailPassword(
        email,
        password,
      );

      // Get Firebase token for API auth
      final token = await authService.getToken();
      if (token == null) {
        throw ServerException(message: 'Failed to get authentication token');
      }

      // Authenticate with backend API and get full user profile
      try {
        final response = await dio.post(
          '/api/auth/login',
          data: {'email': email, 'password': password},
        );

        // Save new token if provided
        if (response.data['token'] != null) {
          await authService.saveToken(response.data['token']);
        }

        // Return complete user profile from API
        if (response.data['user'] != null) {
          return UserModel.fromJson(response.data['user']);
        }

        // If API doesn't return user data, throw exception
        throw ServerException(message: 'Failed to get user profile from API');
      } catch (e) {
        // If API call fails, sign out from Firebase to maintain consistency
        await authService.signOut();
        throw ServerException(
          message: 'Failed to authenticate with backend: ${e.toString()}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Authentication failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      // First create user with Firebase
      final firebaseUser = await authService.signUpWithEmailPassword(
        email,
        password,
        name,
      );

      // Get Firebase token for API auth
      final token = await authService.getToken();
      if (token == null) {
        throw ServerException(message: 'Failed to get authentication token');
      }

      // Register with backend API and get full user profile
      try {
        final response = await dio.post(
          '/api/auth/register',
          data: {'email': email, 'password': password, 'name': name},
        );

        // Save new token if provided
        if (response.data['token'] != null) {
          await authService.saveToken(response.data['token']);
        }

        // Return complete user profile from API
        if (response.data['user'] != null) {
          return UserModel.fromJson(response.data['user']);
        }

        // If API doesn't return user data, throw exception
        throw ServerException(message: 'Failed to get user profile from API');
      } catch (e) {
        // If API call fails, delete Firebase user to maintain consistency
        await firebaseAuth.currentUser?.delete();
        await authService.signOut();
        throw ServerException(
          message: 'Failed to register with backend: ${e.toString()}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await authService.signOut();
      // Also call API logout if needed
      try {
        await dio.post('/api/auth/logout');
      } catch (e) {
        // Ignore API logout errors
      }
    } catch (e) {
      throw ServerException(message: 'Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In process...');

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print('Google Sign-In was cancelled by user or failed');
        throw ServerException(
          message: 'Google sign in was cancelled or failed',
        );
      }

      print('Successfully obtained GoogleSignInAccount: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('Got authentication tokens from Google');

      if (googleAuth.idToken == null) {
        print('Failed to get ID token from Google');
        throw ServerException(message: 'Failed to get ID token from Google');
      }

      // Create a new credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      print('Signing in to Firebase with Google credential...');
      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user == null) {
        print('Firebase user is null after Google sign in');
        throw ServerException(
          message: 'Failed to get user data from Google sign in',
        );
      }

      print(
        'Successfully signed in to Firebase with Google: ${userCredential.user!.email}',
      );

      // Get token and save it
      final token = await userCredential.user!.getIdToken();
      if (token != null) {
        await authService.saveToken(token);
      }

      // The backend API call can be simplified or temporarily bypassed if it's failing
      try {
        // You can comment out this API call if your backend isn't set up yet
        print('Calling backend API for Google auth...');
        final response = await dio.post(
          '/api/auth/google',
          data: {
            'idToken': googleAuth.idToken,
            'email': userCredential.user!.email,
            'name': userCredential.user!.displayName,
            'photoUrl': userCredential.user!.photoURL,
          },
        );

        if (response.data['token'] != null) {
          await authService.saveToken(response.data['token']);
        }

        if (response.data['user'] != null) {
          print('Successfully got user profile from backend');
          return UserModel.fromJson(response.data['user']);
        }
      } catch (e) {
        print('Backend API call failed: ${e.toString()}');
        // Fall back to Firebase user instead of throwing exception
      }

      // If backend API call failed or didn't return user data, use Firebase user
      print('Using Firebase user profile as fallback');
      return UserModel.fromFirebase(userCredential.user!);
    } catch (e) {
      print('Google authentication failed with error: ${e.toString()}');
      throw ServerException(
        message: 'Google authentication failed: ${e.toString()}',
      );
    }
  }
}
