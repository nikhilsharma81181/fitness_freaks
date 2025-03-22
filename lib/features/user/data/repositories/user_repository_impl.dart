import 'package:fitness_freaks/core/error/exceptions.dart';
import 'package:fitness_freaks/core/error/failures.dart';
import 'package:fitness_freaks/core/network/network_info.dart';
import 'package:fitness_freaks/features/user/data/datasources/user_remote_data_source.dart';
import 'package:fitness_freaks/features/user/data/models/user_model.dart';
import 'package:fitness_freaks/features/user/domain/entities/user.dart';
import 'package:fitness_freaks/features/user/domain/repositories/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    return await _performUserAction(() => remoteDataSource.getCurrentUser());
  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    final userModel = user as UserModel;
    return await _performUserAction(
      () => remoteDataSource.updateUser(userModel),
    );
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _performUserAction(
      () => remoteDataSource.signInWithEmailAndPassword(email, password),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    return await _performUserAction(
      () => remoteDataSource.signUpWithEmailAndPassword(email, password, name),
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(NetworkFailure());
      }

      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    return await _performUserAction(() => remoteDataSource.signInWithGoogle());
  }

  Future<Either<Failure, T>> _performUserAction<T>(
    Future<T> Function() action,
  ) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(NetworkFailure());
      }

      final result = await action();
      return Right(result);
    } on NetworkException {
      return Left(NetworkFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
