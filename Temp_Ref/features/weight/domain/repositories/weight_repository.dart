import 'package:fpdart/fpdart.dart';
import 'package:fitness_freaks/core/error/failures.dart';
import 'package:fitness_freaks/features/weight/domain/entities/weight_entry.dart';

/// Interface for weight data repository operations
abstract class WeightRepository {
  /// Get all weight entries for the current user
  Future<Either<Failure, List<WeightEntryEntity>>> getWeightEntries();
  
  /// Upload a weight entry with image
  Future<Either<Failure, WeightEntryEntity>> uploadWeightFromImage(
    String imageBase64
  );
  
  /// Add a new weight entry manually
  Future<Either<Failure, WeightEntryEntity>> addWeightEntry(
    double weight, 
    String date
  );
  
  /// Get cached weight entries
  Future<Either<Failure, List<WeightEntryEntity>>> getCachedWeightEntries();
  
  /// Check if cache is stale (> 1 hour)
  Future<bool> isCacheStale();
}
