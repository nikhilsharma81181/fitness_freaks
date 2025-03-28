import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/connection_checker.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/local/auth_local_datasource.dart';
import '../datasource/remote/auth_remote_datasource.dart';
import '../models/auth_token_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final ConnectionChecker _connectionChecker;
  final ApiClient _apiClient;
  
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required ConnectionChecker connectionChecker,
    required ApiClient apiClient,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _connectionChecker = connectionChecker,
        _apiClient = apiClient;
  
  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      // If we have internet, try to sign out from the server
      if (await _connectionChecker.isConnected()) {
        try {
          await _remoteDataSource.signOut();
        } catch (e) {
          // Ignore server errors during sign out
        }
      }
      
      // Always clear local tokens
      await _localDataSource.deleteToken();
      
      // Clear authorization header
      _apiClient.updateToken(null);
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final hasToken = await _localDataSource.hasToken();
      
      if (!hasToken) {
        return const Right(false);
      }
      
      // Get the token to check if it's expired
      final token = await _localDataSource.getToken();
      
      if (token == null) {
        return const Right(false);
      }
      
      // If token is expired and we're online, try to refresh it
      if (token.isExpired && await _connectionChecker.isConnected()) {
        if (token.refreshToken == null) {
          // No refresh token, so we're not authenticated
          await _localDataSource.deleteToken();
          return const Right(false);
        }
        
        try {
          // Try to refresh the token
          final refreshResult = await refreshToken();
          return refreshResult.fold(
            (_) => const Right(false), // Refresh failed
            (_) => const Right(true),  // Refresh succeeded
          );
        } catch (e) {
          // Refresh failed, delete the token
          await _localDataSource.deleteToken();
          return const Right(false);
        }
      }
      
      // Token exists and is not expired (or was refreshed)
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AuthToken>> refreshToken() async {
    if (!(await _connectionChecker.isConnected())) {
      return const Left(ConnectionFailure());
    }
    
    try {
      // Get current token
      final currentToken = await _localDataSource.getToken();
      
      if (currentToken == null || currentToken.refreshToken == null) {
        return const Left(AuthFailure(
          message: 'No refresh token available',
          type: AuthFailureType.unauthorized,
        ));
      }
      
      // Refresh the token
      final token = await _remoteDataSource.refreshToken(
        currentToken.refreshToken!,
      );
      
      // Cache the new token
      await _localDataSource.saveToken(token);
      
      // Update the API client
      _apiClient.updateToken(token.accessToken);
      
      return Right(token);
    } on ServerException catch (e) {
      // If refresh fails, clear the token
      await _localDataSource.deleteToken();
      
      // Remove the authorization header
      _apiClient.updateToken(null);
      
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AuthToken?>> getToken() async {
    try {
      final token = await _localDataSource.getToken();
      return Right(token);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> saveToken(AuthToken token) async {
    try {
      await _localDataSource.saveToken(
        token is AuthTokenModel
            ? token
            : AuthTokenModel(
                accessToken: token.accessToken,
                refreshToken: token.refreshToken,
                expiryTime: token.expiryTime,
                createdAt: token.createdAt,
              ),
      );
      
      // Update the API client
      _apiClient.updateToken(token.accessToken);
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteToken() async {
    try {
      await _localDataSource.deleteToken();
      
      // Remove the authorization header
      _apiClient.updateToken(null);
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
