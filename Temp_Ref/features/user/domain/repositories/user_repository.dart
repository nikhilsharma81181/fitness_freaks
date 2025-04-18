import 'dart:io';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Repository interface for user operations
abstract class UserRepository {
  /// Create a new user
  Future<Either<Failure, UserEntity>> createUser(UserEntity user);
  
  /// Get current user
  Future<Either<Failure, UserEntity>> getUser();
  
  /// Update user
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user);
  
  /// Upload profile picture
  Future<Either<Failure, UserEntity>> uploadProfilePicture(File imageFile);
  
  /// Delete user
  Future<Either<Failure, void>> deleteUser();
}
