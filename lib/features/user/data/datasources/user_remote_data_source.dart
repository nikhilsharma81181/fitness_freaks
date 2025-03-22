import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:fitness_freaks/core/constant/endpoints/endpoints.dart';
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

  /// Calls the backend API to sign out the user
  /// Throws a [ServerException] for all error codes
  Future<void> signOut();

  /// Calls the backend API to sign in a user with Google
  /// Throws a [ServerException] for all error codes
  Future<UserModel> signInWithGoogle();

  /// Creates or updates user profile in the backend after authentication
  /// Throws a [ServerException] for all error codes
  Future<UserModel> createOrUpdateUser();
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
      log("Token: ${dio.options.headers}");
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
  Future<void> signOut() async {
    try {
      await authService.signOut();
      await googleSignIn.signOut();
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

      // Get Firebase token
      final firebaseToken = await userCredential.user!.getIdToken();
      if (firebaseToken == null) {
        print('Failed to get Firebase token');
        throw ServerException(message: 'Failed to get Firebase token');
      }

      try {
        // Exchange Firebase token for JWT from your backend
        // Use your GoogleSSO endpoint from AuthService
        print('Exchanging Firebase token for JWT from backend');
        final tokenExchangeEndpoint = Endpoint.googleSSO;

        // Use the exact same data format as in your other project
        final response = await dio.post(
          tokenExchangeEndpoint,
          data: {"idToken": firebaseToken},
        );

        print('Token exchange response: ${response.data}');

        // Check if the response contains a JWT token
        if ((response.statusCode == 200 || response.statusCode == 201) &&
            response.data['token'] != null) {
          final jwtToken = response.data['token'];

          // Save the JWT token
          await authService.saveToken(jwtToken);

          print('Saved JWT token from backend');

          // Return user profile from backend if available
          if (response.data['user'] != null) {
            print('Using user profile from backend');
            return UserModel.fromJson(response.data['user']);
          }
        } else {
          print('Invalid response from token exchange: ${response.data}');
          throw ServerException(
            message: 'Invalid response from token exchange',
          );
        }
      } catch (e) {
        print('Error exchanging token: $e');
        throw ServerException(message: 'Failed to exchange token: $e');
      }

      // Fall back to Firebase user if backend token exchange fails
      return UserModel.fromFirebase(userCredential.user!);
    } catch (e) {
      print('Google authentication failed with error: ${e.toString()}');
      throw ServerException(
        message: 'Google authentication failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel> createOrUpdateUser() async {
    try {
      // Get the current user from Firebase
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw ServerException(message: 'No authenticated user found');
      }

      // Create user data from Firebase user
      final userData = UserModel.fromFirebase(firebaseUser);

      // Send user data to backend
      final response = await dio.post(
        '/api/user/create-or-update',
        data: userData.toJson(),
      );

      // Return user model from API response
      if (response.data != null) {
        return UserModel.fromJson(response.data);
      }

      // If API doesn't return user data, return the Firebase user data
      return userData;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Failed to create or update user: ${e.toString()}',
      );
    }
  }
}
