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
          final token = await authService.getToken();
          if (token != null) {
            dio.options.headers['Authorization'] = 'Bearer $token';
            final response = await dio.get('/api/user/profile');
            return UserModel.fromJson(response.data);
          }
        } catch (e) {
          // If API call fails, just return the basic Firebase user
          return firebaseUser;
        }
        return firebaseUser;
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

      dio.options.headers['Authorization'] = 'Bearer $token';
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

      // Configure API client with token
      dio.options.headers['Authorization'] = 'Bearer $token';

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

      // Configure API client with token
      dio.options.headers['Authorization'] = 'Bearer $token';

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
        final token = await authService.getToken();
        if (token != null) {
          dio.options.headers['Authorization'] = 'Bearer $token';
          await dio.post('/api/auth/logout');
        }
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
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw ServerException(
          message: 'Google sign in was cancelled or failed',
        );
      }

      try {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credential
        final userCredential = await firebaseAuth.signInWithCredential(
          credential,
        );

        if (userCredential.user == null) {
          throw ServerException(
            message: 'Failed to get user data from Google sign in',
          );
        }

        // Get the Firebase token for backend API auth
        final token = await userCredential.user!.getIdToken();
        if (token == null) {
          throw ServerException(message: 'Failed to get authentication token');
        }

        // Save the token for future API calls
        await authService.saveToken(token);

        // Configure API client with token
        dio.options.headers['Authorization'] = 'Bearer $token';

        // Try to authenticate with the backend using Google credentials
        try {
          final response = await dio.post(
            '/api/auth/google',
            data: {
              'idToken': googleAuth.idToken,
              'email': userCredential.user!.email,
              'name': userCredential.user!.displayName,
              'photoUrl': userCredential.user!.photoURL,
            },
          );

          // If backend provides a token, save it
          if (response.data['token'] != null) {
            await authService.saveToken(response.data['token']);
          }

          // Return user profile from API if available
          if (response.data['user'] != null) {
            return UserModel.fromJson(response.data['user']);
          }
        } catch (e) {
          // If API call fails, we'll continue with just the Firebase user
          // but log the error for debugging
          print('Failed to authenticate with Google: ${e.toString()}');
          throw ServerException(
            message: 'Google authentication failed: ${e.toString()}',
          );
        }

        return UserModel.fromFirebase(userCredential.user!);
      } catch (e) {
        // If API call fails, we'll continue with just the Firebase user
        // but log the error for debugging
        print('Failed to authenticate with Google: ${e.toString()}');
        throw ServerException(
          message: 'Google authentication failed: ${e.toString()}',
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Google authentication failed: ${e.toString()}',
      );
    }
  }
}
