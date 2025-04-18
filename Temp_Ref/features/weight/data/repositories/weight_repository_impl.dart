import 'package:fpdart/fpdart.dart';
import 'package:fitness_freaks/core/error/exceptions.dart';
import 'package:fitness_freaks/core/error/failures.dart';
import 'package:fitness_freaks/core/network/connection_checker.dart';
import 'package:fitness_freaks/features/weight/data/datasources/weight_local_data_source.dart';
import 'package:fitness_freaks/features/weight/data/datasources/weight_remote_data_source.dart';
import 'package:fitness_freaks/features/weight/domain/entities/weight_entry.dart';
import 'package:fitness_freaks/features/weight/domain/repositories/weight_repository.dart';

/// Implementation of the Weight Repository
class WeightRepositoryImpl implements WeightRepository {
  final WeightRemoteDataSource remoteDataSource;
  final WeightLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  WeightRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, WeightEntryEntity>> addWeightEntry(
      double weight, String date) async {
    if (!await connectionChecker.isConnected()) {
      return Left(ConnectionFailure(message: 'No internet connection'));
    }

    try {
      final weightEntry = await remoteDataSource.addWeightEntry(weight, date);

      // Update cache with new entry
      final cachedEntries = await localDataSource.getCachedWeightEntries();
      cachedEntries.add(weightEntry);
      await localDataSource.cacheWeightEntries(cachedEntries);

      return Right(weightEntry);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WeightEntryEntity>>>
      getCachedWeightEntries() async {
    try {
      final cachedEntries = await localDataSource.getCachedWeightEntries();
      return Right(cachedEntries);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WeightEntryEntity>>> getWeightEntries() async {
    if (!await connectionChecker.isConnected()) {
      // Return cached data if available
      return getCachedWeightEntries();
    }

    try {
      final remoteEntries = await remoteDataSource.getWeightEntries();

      // Cache the fetched entries
      await localDataSource.cacheWeightEntries(remoteEntries);

      return Right(remoteEntries);
    } on ServerException catch (e) {
      // Try to get cached data if server request fails
      final cachedResult = await getCachedWeightEntries();
      return cachedResult.fold(
        (failure) => Left(ServerFailure(message: e.message)),
        (cachedEntries) => Right(cachedEntries),
      );
    } catch (e) {
      // Try to get cached data if any other error occurs
      final cachedResult = await getCachedWeightEntries();
      return cachedResult.fold(
        (failure) => Left(ServerFailure(message: e.toString())),
        (cachedEntries) => Right(cachedEntries),
      );
    }
  }

  @override
  Future<bool> isCacheStale() async {
    return await localDataSource.isCacheStale();
  }

  @override
  Future<Either<Failure, WeightEntryEntity>> uploadWeightFromImage(
      String imageBase64) async {
    if (!await connectionChecker.isConnected()) {
      return Left(ConnectionFailure(message: 'No internet connection'));
    }

    try {
      final weightEntry =
          await remoteDataSource.uploadWeightFromImage(imageBase64);

      // Update cache with new entry
      final cachedEntries = await localDataSource.getCachedWeightEntries();
      cachedEntries.add(weightEntry);
      await localDataSource.cacheWeightEntries(cachedEntries);

      return Right(weightEntry);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
