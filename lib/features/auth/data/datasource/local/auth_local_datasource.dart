import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/storage/utils/secure_storage_helper.dart';
import '../../../domain/entities/auth_token.dart';
import '../../models/auth_token_model.dart';

abstract class AuthLocalDataSource {
  /// Get authentication token
  Future<AuthTokenModel?> getToken();
  
  /// Save authentication token
  Future<void> saveToken(AuthTokenModel token);
  
  /// Delete authentication token
  Future<void> deleteToken();
  
  /// Check if token exists
  Future<bool> hasToken();
  
  /// Save biometric consent
  Future<void> saveBiometricConsent(bool consent);
  
  /// Get biometric consent
  Future<bool?> getBiometricConsent();
  
  /// Delete biometric consent
  Future<void> deleteBiometricConsent();
}

/// Implementation of [AuthLocalDataSource] using Hive and secure storage
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _authBoxName = 'auth_box';
  static const String _tokenKey = 'auth_token';
  static const String _biometricConsentKey = 'biometric_consent';
  
  final HiveInterface _hive;
  
  AuthLocalDataSourceImpl({HiveInterface? hive}) : _hive = hive ?? Hive;
  
  /// Get the auth box
  Future<Box> get _authBox async {
    try {
      if (_hive.isBoxOpen(_authBoxName)) {
        return _hive.box(_authBoxName);
      }
      return await _hive.openBox(_authBoxName);
    } catch (e) {
      debugPrint('Error opening auth box: $e');
      throw CacheException('Failed to open auth box');
    }
  }
  
  @override
  Future<AuthTokenModel?> getToken() async {
    try {
      // Try to get token from secure storage first
      final secureToken = await SecureStorageHelper.getAuthToken();
      if (secureToken != null) {
        return AuthTokenModel(accessToken: secureToken);
      }
      
      // Fall back to Hive if not found in secure storage
      final box = await _authBox;
      final tokenJson = box.get(_tokenKey);
      
      if (tokenJson == null) {
        return null;
      }
      
      final tokenMap = json.decode(tokenJson) as Map<String, dynamic>;
      return AuthTokenModel.fromJson(tokenMap);
    } catch (e) {
      debugPrint('Error getting auth token: $e');
      throw CacheException('Failed to get auth token');
    }
  }
  
  @override
  Future<void> saveToken(AuthTokenModel token) async {
    try {
      // Save access token to secure storage
      await SecureStorageHelper.saveAuthToken(token.accessToken);
      
      // Save refresh token to secure storage if available
      if (token.refreshToken != null) {
        await SecureStorageHelper.saveRefreshToken(token.refreshToken!);
      }
      
      // Save full token to Hive for backup
      final box = await _authBox;
      final tokenJson = json.encode(token.toJson());
      await box.put(_tokenKey, tokenJson);
    } catch (e) {
      debugPrint('Error saving auth token: $e');
      throw CacheException('Failed to save auth token');
    }
  }
  
  @override
  Future<void> deleteToken() async {
    try {
      // Clear from secure storage
      await SecureStorageHelper.deleteAuthToken();
      await SecureStorageHelper.deleteRefreshToken();
      
      // Clear from Hive
      final box = await _authBox;
      await box.delete(_tokenKey);
    } catch (e) {
      debugPrint('Error deleting auth token: $e');
      throw CacheException('Failed to delete auth token');
    }
  }
  
  @override
  Future<bool> hasToken() async {
    try {
      // Check secure storage first
      final secureToken = await SecureStorageHelper.getAuthToken();
      if (secureToken != null) {
        return true;
      }
      
      // Fall back to Hive
      final box = await _authBox;
      return box.containsKey(_tokenKey);
    } catch (e) {
      debugPrint('Error checking if token exists: $e');
      return false;
    }
  }
  
  @override
  Future<void> saveBiometricConsent(bool consent) async {
    try {
      // Save to secure storage
      await SecureStorageHelper.saveBiometricConsent(consent);
      
      // Backup to Hive
      final box = await _authBox;
      await box.put(_biometricConsentKey, consent);
    } catch (e) {
      debugPrint('Error saving biometric consent: $e');
      throw CacheException('Failed to save biometric consent');
    }
  }
  
  @override
  Future<bool?> getBiometricConsent() async {
    try {
      // Try secure storage first
      final secureConsent = await SecureStorageHelper.getBiometricConsent();
      if (secureConsent != null) {
        return secureConsent;
      }
      
      // Fall back to Hive
      final box = await _authBox;
      return box.get(_biometricConsentKey) as bool?;
    } catch (e) {
      debugPrint('Error getting biometric consent: $e');
      return null;
    }
  }
  
  @override
  Future<void> deleteBiometricConsent() async {
    try {
      // Clear from secure storage
      await SecureStorageHelper.deleteBiometricConsent();
      
      // Clear from Hive
      final box = await _authBox;
      await box.delete(_biometricConsentKey);
    } catch (e) {
      debugPrint('Error deleting biometric consent: $e');
      throw CacheException('Failed to delete biometric consent');
    }
  }
}
