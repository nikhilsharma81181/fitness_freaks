import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../core/constant/endpoints/endpoints.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/network_error_mapper.dart';
import '../../../../../core/network/api_client.dart';
import '../../models/auth_token_model.dart';

abstract class GoogleAuthDataSource {
  /// Sign in with Google
  Future<AuthTokenModel> googleSignIn();
}

class GoogleAuthDataSourceImpl implements GoogleAuthDataSource {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;
  final ApiClient _apiClient;

  GoogleAuthDataSourceImpl(
    this._googleSignIn,
    this._firebaseAuth,
    this._apiClient,
  );

  @override
  Future<AuthTokenModel> googleSignIn() async {
    try {
      // Sign out first to ensure a fresh sign-in
      await _googleSignIn.signOut();

      // Trigger Google sign-in
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        throw ServerException('Google Sign-In cancelled by user');
      }

      // Get authentication details
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      log("Google authentication successful");

      // Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw ServerException('Failed to authenticate with Firebase');
      }

      log("Firebase authentication successful. User: ${userCredential.user?.displayName}");

      // Get ID token from Firebase
      final String? idToken = await userCredential.user!.getIdToken();

      if (idToken == null) {
        throw ServerException('Failed to get ID token from Firebase');
      }

      // Send the Firebase token to our backend
      final response = await _apiClient.post(
        Endpoint.googleSSO,
        data: {"idToken": idToken},
      );

      log("Backend authentication response: ${response.data}");

      if (response.data['token'] != null) {
        // Parse the token response
        return AuthTokenModel.fromJson(response.data);
      } else {
        throw ServerException('Backend authentication failed');
      }
    } on DioException catch (e) {
      debugPrint('DioException during Google sign-in: $e');
      throw handleDioException(e);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: $e');
      throw ServerException('Firebase authentication error: ${e.message}');
    } on ServerException {
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error during Google sign-in: $e');
      throw ServerException('An unexpected error occurred: $e');
    }
  }
}
