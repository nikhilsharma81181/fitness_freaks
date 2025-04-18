import 'package:fitness_freaks/features/weight/data/models/weight_entry_model.dart';

/// Interface for local data source operations
abstract class WeightLocalDataSource {
  /// Get all weight entries from local cache
  Future<List<WeightEntryModel>> getCachedWeightEntries();
  
  /// Save weight entries to local cache
  Future<void> cacheWeightEntries(List<WeightEntryModel> entries);
  
  /// Check if cache is stale (older than 1 hour)
  Future<bool> isCacheStale();
  
  /// Clear the weight entries cache
  Future<void> clearCache();
}
