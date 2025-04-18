import 'dart:convert';
import 'package:fitness_freaks/core/error/exceptions.dart';
import 'package:fitness_freaks/core/storage/storage_service.dart';
import 'package:fitness_freaks/features/weight/data/datasources/weight_local_data_source.dart';
import 'package:fitness_freaks/features/weight/data/models/weight_entry_model.dart';

/// Implementation of the local data source for weight entries
class WeightLocalDataSourceImpl implements WeightLocalDataSource {
  final StorageService storageService;

  static const String WEIGHT_ENTRIES_KEY = 'weight_entries';
  static const String WEIGHT_CACHE_TIMESTAMP_KEY = 'weight_cache_timestamp';
  static const Duration CACHE_DURATION = Duration(hours: 1);

  WeightLocalDataSourceImpl({required this.storageService});

  @override
  Future<void> cacheWeightEntries(List<WeightEntryModel> entries) async {
    try {
      // Convert entries to JSON
      final entriesJson = entries.map((entry) => entry.toJson()).toList();

      // Save entries
      await storageService.write(
        WEIGHT_ENTRIES_KEY,
        json.encode(entriesJson),
      );

      // Update timestamp
      await storageService.write(
        WEIGHT_CACHE_TIMESTAMP_KEY,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw CacheException('Failed to cache weight entries: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await storageService.delete(WEIGHT_ENTRIES_KEY);
      await storageService.delete(WEIGHT_CACHE_TIMESTAMP_KEY);
    } catch (e) {
      throw CacheException('Failed to clear weight cache: ${e.toString()}');
    }
  }

  @override
  Future<List<WeightEntryModel>> getCachedWeightEntries() async {
    try {
      final jsonString = await storageService.read(WEIGHT_ENTRIES_KEY);

      if (jsonString == null) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);

      return jsonList.map((json) => WeightEntryModel.fromJson(json)).toList();
    } catch (e) {
      throw CacheException(
          'Failed to get cached weight entries: ${e.toString()}');
    }
  }

  @override
  Future<bool> isCacheStale() async {
    try {
      final timestampString =
          await storageService.read(WEIGHT_CACHE_TIMESTAMP_KEY);

      if (timestampString == null) {
        return true;
      }

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();

      return now.difference(timestamp) > CACHE_DURATION;
    } catch (e) {
      return true;
    }
  }
}
