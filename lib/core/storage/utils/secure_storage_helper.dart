import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

/// Helper class for secure storage operations
/// Used for storing sensitive data like tokens
class SecureStorageHelper {
  static const _storage = FlutterSecureStorage();
  
  /// Keys for secure storage
  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyBiometricConsent = 'biometric_consent';
  
  /// Save authentication token
  static Future<void> saveAuthToken(String token) async {
    try {
      await _storage.write(key: _keyAuthToken, value: token);
    } catch (e) {
      debugPrint('Error saving auth token: $e');
      rethrow;
    }
  }
  
  /// Get authentication token
  static Future<String?> getAuthToken() async {
    try {
      return await _storage.read(key: _keyAuthToken);
    } catch (e) {
      debugPrint('Error getting auth token: $e');
      return null;
    }
  }
  
  /// Delete authentication token
  static Future<void> deleteAuthToken() async {
    try {
      await _storage.delete(key: _keyAuthToken);
    } catch (e) {
      debugPrint('Error deleting auth token: $e');
      rethrow;
    }
  }
  
  /// Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _keyRefreshToken, value: token);
    } catch (e) {
      debugPrint('Error saving refresh token: $e');
      rethrow;
    }
  }
  
  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _keyRefreshToken);
    } catch (e) {
      debugPrint('Error getting refresh token: $e');
      return null;
    }
  }
  
  /// Delete refresh token
  static Future<void> deleteRefreshToken() async {
    try {
      await _storage.delete(key: _keyRefreshToken);
    } catch (e) {
      debugPrint('Error deleting refresh token: $e');
      rethrow;
    }
  }
  
  /// Save biometric consent
  static Future<void> saveBiometricConsent(bool consent) async {
    try {
      await _storage.write(
        key: _keyBiometricConsent, 
        value: consent.toString(),
      );
    } catch (e) {
      debugPrint('Error saving biometric consent: $e');
      rethrow;
    }
  }
  
  /// Get biometric consent
  static Future<bool?> getBiometricConsent() async {
    try {
      final value = await _storage.read(key: _keyBiometricConsent);
      return value != null ? value.toLowerCase() == 'true' : null;
    } catch (e) {
      debugPrint('Error getting biometric consent: $e');
      return null;
    }
  }
  
  /// Delete biometric consent
  static Future<void> deleteBiometricConsent() async {
    try {
      await _storage.delete(key: _keyBiometricConsent);
    } catch (e) {
      debugPrint('Error deleting biometric consent: $e');
      rethrow;
    }
  }
  
  /// Delete all secure data
  static Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint('Error deleting all secure data: $e');
      rethrow;
    }
  }
}
