import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/storage/models/user_box.dart';
import '../../models/user_model.dart';

abstract class UserLocalDataSource {
  /// Get cached user
  Future<UserModel?> getUser();
  
  /// Cache user
  Future<void> cacheUser(UserModel user);
  
  /// Clear cached user
  Future<void> clearUser();
  
  /// Check if user is cached
  Future<bool> hasUser();
}

/// Implementation of [UserLocalDataSource] using Hive
class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const String _userBoxName = 'user_box';
  static const String _userKey = 'current_user';
  
  final HiveInterface _hive;
  
  UserLocalDataSourceImpl({HiveInterface? hive}) : _hive = hive ?? Hive;
  
  /// Get the user box
  Future<Box> get _userBox async {
    if (_hive.isBoxOpen(_userBoxName)) {
      return _hive.box(_userBoxName);
    }
    return await _hive.openBox(_userBoxName);
  }
  
  @override
  Future<UserModel?> getUser() async {
    try {
      final box = await _userBox;
      final userBox = box.get(_userKey) as UserBox?;
      
      if (userBox == null) {
        return null;
      }
      
      // Convert UserBox to UserEntity, then to UserModel
      final userEntity = userBox.toEntity();
      return UserModel(
        fullName: userEntity.fullName,
        address: userEntity.address,
        country: userEntity.country,
        profilePhoto: userEntity.profilePhoto,
        email: userEntity.email,
        phoneNumber: userEntity.phoneNumber,
        dateOfBirth: userEntity.dateOfBirth,
        gender: userEntity.gender,
        isActive: userEntity.isActive,
      );
    } catch (e) {
      debugPrint('Error getting cached user: $e');
      throw CacheException('Failed to get cached user');
    }
  }
  
  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final box = await _userBox;
      
      // Convert UserModel to UserBox
      final userBox = UserBox.fromEntity(user);
      
      await box.put(_userKey, userBox);
      debugPrint('User cached successfully');
    } catch (e) {
      debugPrint('Error caching user: $e');
      throw CacheException('Failed to cache user');
    }
  }
  
  @override
  Future<void> clearUser() async {
    try {
      final box = await _userBox;
      await box.delete(_userKey);
      debugPrint('Cached user cleared');
    } catch (e) {
      debugPrint('Error clearing cached user: $e');
      throw CacheException('Failed to clear cached user');
    }
  }
  
  @override
  Future<bool> hasUser() async {
    try {
      final box = await _userBox;
      return box.containsKey(_userKey);
    } catch (e) {
      debugPrint('Error checking if user is cached: $e');
      return false;
    }
  }
}
