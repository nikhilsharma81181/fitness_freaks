import 'dart:developer';
import 'dart:io';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/connection_checker.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasource/local/user_local_datasource.dart';
import '../datasource/remote/user_remote_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;
  
  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });
  
  @override
  Future<Either<Failure, UserEntity>> createUser(UserEntity user) async {
    if (!(await connectionChecker.isConnected())) {
      return const Left(ConnectionFailure());
    }
    
    try {
      log("Creating user in repository");
      
      final userModel = UserModel(
        fullName: user.fullName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        profilePhoto: user.profilePhoto,
      );
      
      final remoteUser = await remoteDataSource.createUser(userModel);
      
      // Cache the user
      await localDataSource.cacheUser(remoteUser);
      
      return Right(remoteUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, UserEntity>> getUser() async {
    try {
      // Check for internet connection
      if (await connectionChecker.isConnected()) {
        try {
          // Try to get user from remote
          final remoteUser = await remoteDataSource.getUser();
          
          // Cache the user
          await localDataSource.cacheUser(remoteUser);
          
          return Right(remoteUser);
        } on ServerException catch (e) {
          // If remote fails, try to get from cache
          if (e.statusCode == 404 || e.statusCode == 401) {
            final hasUser = await localDataSource.hasUser();
            if (hasUser) {
              final cachedUser = await localDataSource.getUser();
              if (cachedUser != null) {
                return Right(cachedUser);
              }
            }
          }
          
          return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
        }
      } else {
        // No internet, try to get from cache
        final hasUser = await localDataSource.hasUser();
        if (hasUser) {
          final cachedUser = await localDataSource.getUser();
          if (cachedUser != null) {
            return Right(cachedUser);
          }
        }
        
        return const Left(ConnectionFailure());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user) async {
    if (!(await connectionChecker.isConnected())) {
      return const Left(ConnectionFailure());
    }
    
    try {
      log("Updating user in repository. User date of birth: ${user.dateOfBirth}");
      
      final userModel = UserModel(
        fullName: user.fullName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        profilePhoto: user.profilePhoto,
        address: user.address,
        country: user.country,
        dateOfBirth: user.dateOfBirth,
        isActive: user.isActive,
        gender: user.gender,
      );
      
      log("Created UserModel in repository. Model date of birth: ${userModel.dateOfBirth}");
      
      final remoteUser = await remoteDataSource.updateUser(userModel);
      
      log("Received updated user from remote. Remote user date of birth: ${remoteUser.dateOfBirth}");
      
      // Update the cache
      await localDataSource.cacheUser(remoteUser);
      
      return Right(remoteUser);
    } on ServerException catch (e) {
      log("Server exception in updateUser: ${e.message}");
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, UserEntity>> uploadProfilePicture(File file) async {
    if (!(await connectionChecker.isConnected())) {
      return const Left(ConnectionFailure());
    }
    
    try {
      final remoteUser = await remoteDataSource.uploadProfilePicture(file);
      
      // Update the cache
      await localDataSource.cacheUser(remoteUser);
      
      return Right(remoteUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteUser() async {
    if (!(await connectionChecker.isConnected())) {
      return const Left(ConnectionFailure());
    }
    
    try {
      await remoteDataSource.deleteUser();
      
      // Clear the cache
      await localDataSource.clearUser();
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
