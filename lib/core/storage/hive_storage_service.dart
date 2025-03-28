import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_service.dart';

/// Implementation of [StorageService] using Hive
class HiveStorageService implements StorageService {
  static const _secureStorageKey = 'hive_encryption_key';
  static const _mainBoxName = 'app_storage';

  final Box _box = Hive.box(_mainBoxName);
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Singleton instance
  static final HiveStorageService _instance = HiveStorageService._internal();

  /// Factory constructor
  factory HiveStorageService() => _instance;

  /// Private constructor
  HiveStorageService._internal();

  @override
  Future<void> init() async {
    // No longer needed here as AppInitializer handles Hive setup
    // Ensure the box is open (although AppInitializer should have done this)
    if (!_box.isOpen) {
      // This case should ideally not happen if AppInitializer runs first
      debugPrint('Warning: $_mainBoxName was not open. Attempting to open.');
      try {
        // Attempt to open without re-initializing Hive itself
        await Hive.openBox(_mainBoxName);
      } catch (e) {
        debugPrint(
            'Error opening $_mainBoxName in HiveStorageService init: $e');
        // Rethrow or handle as appropriate for your app's error strategy
        rethrow;
      }
    }
    debugPrint('HiveStorageService initialized (box should already be open)');
  }

  /// Get or generate an encryption key for secure storage (Encryption logic removed for simplicity, assuming not used or handled elsewhere)
  Future<List<int>?> _getEncryptionKey() async {
    // Assuming encryption is not used or handled differently now
    // If encryption is needed, this logic would need careful review
    // in the context of centralized initialization.
    return null;
  }

  @override
  Future<bool> hasKey(String key) async {
    return _box.containsKey(key);
  }

  @override
  Future<T?> read<T>(String key) async {
    return _box.get(key) as T?;
  }

  @override
  Future<void> write<T>(String key, T value) async {
    await _box.put(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
  }
}
