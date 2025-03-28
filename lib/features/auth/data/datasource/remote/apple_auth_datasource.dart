import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../../core/constant/endpoints/endpoints.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/network_error_mapper.dart';
import '../../../../../core/network/api_client.dart';
import '../../models/auth_token_model.dart';

abstract class AppleAuthDataSource {
  /// Sign in with Apple
  Future<AuthTokenModel> appleSignIn();
}

class AppleAuthDataSourceImpl implements AppleAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final ApiClient _apiClient;
  
  AppleAuthDataSourceImpl(this._firebaseAuth, this._apiClient);
  
  @override
  Future<AuthTokenModel> appleSignIn() async {
    // Apple Sign-In functionality is not yet implemented
    throw  ServerException(
      'Apple Sign-In is not available yet',
    );
    
    /* COMMENTED OUT: Apple Authentication Implementation
    // Check if platform is iOS or macOS
    if (!Platform.isIOS && !Platform.isMacOS) {
      throw const ServerException(
        'Apple Sign-In is only available on iOS and macOS',
      );
    }
    
    try {
      // Get Apple credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      
      log("Apple authentication successful");
      
      // Create an OAuthCredential from the Apple credential
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      
      // Sign in to Firebase with the Apple credential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);
      
      if (userCredential.user == null) {
        throw const ServerException('Failed to authenticate with Firebase');
      }
      
      log("Firebase authentication successful. User: ${userCredential.user?.displayName}");
      
      // Get the user's name from the Apple credential, since it might not be in Firebase
      String? displayName;
      if (appleCredential.givenName != null || appleCredential.familyName != null) {
        displayName = '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim();
      }
      
      // Update the user's display name in Firebase if needed
      if (displayName != null && displayName.isNotEmpty &&
          (userCredential.user?.displayName == null ||
              userCredential.user?.displayName?.isEmpty == true)) {
        await userCredential.user?.updateDisplayName(displayName);
      }
      
      // Get ID token from Firebase
      final String? idToken = await userCredential.user!.getIdToken();
      
      if (idToken == null) {
        throw const ServerException('Failed to get ID token from Firebase');
      }
      
      // Send the Firebase token to our backend
      final response = await _apiClient.post(
        Endpoint.appleSSO,
        data: {"idToken": idToken},
      );
      
      log("Backend authentication response: ${response.data}");
      
      if (response.data['token'] != null) {
        // Parse the token response
        return AuthTokenModel.fromJson(response.data);
      } else {
        throw const ServerException('Backend authentication failed');
      }
    } on DioException catch (e) {
      debugPrint('DioException during Apple sign-in: $e');
      throw handleDioException(e);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: $e');
      throw ServerException('Firebase authentication error: ${e.message}');
    } on SignInWithAppleException catch (e) {
      debugPrint('SignInWithAppleException: $e');
      throw ServerException('Apple Sign-In error: ${e.message}');
    } on ServerException {
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error during Apple sign-in: $e');
      throw ServerException('An unexpected error occurred: $e');
    }
    */
  }
}
