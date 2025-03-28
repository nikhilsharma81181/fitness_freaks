import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/connection_checker.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/local/auth_local_datasource.dart';
import '../datasource/remote/google_auth_datasource.dart';

class GoogleAuthRepositoryImpl implements GoogleAuthRepository {
  final GoogleAuthDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final ConnectionChecker _connectionChecker;
  
  GoogleAuthRepositoryImpl({
    required GoogleAuthDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required ConnectionChecker connectionChecker,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _connectionChecker = connectionChecker;
  
  @override
  Future<Either<Failure, AuthToken>> signInWithGoogle() async {
    if (!(await _connectionChecker.isConnected())) {
      return const Left(ConnectionFailure());
    }
    
    try {
      final token = await _remoteDataSource.googleSignIn();
      
      // Cache the token
      await _localDataSource.saveToken(token);
      
      return Right(token);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
