import 'package:fitness_freaks/core/network/connection_checker.dart';
import 'package:fitness_freaks/core/storage/storage_providers.dart';
import 'package:fitness_freaks/features/weight/domain/entities/weight_entry.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitness_freaks/core/di/providers.dart';
import 'package:fitness_freaks/features/weight/data/datasources/weight_local_data_source.dart';
import 'package:fitness_freaks/features/weight/data/datasources/weight_local_data_source_impl.dart';
import 'package:fitness_freaks/features/weight/data/datasources/weight_remote_data_source.dart';
import 'package:fitness_freaks/features/weight/data/datasources/weight_remote_data_source_impl.dart';
import 'package:fitness_freaks/features/weight/data/repositories/weight_repository_impl.dart';
import 'package:fitness_freaks/features/weight/domain/repositories/weight_repository.dart';
import 'package:fitness_freaks/features/weight/domain/usecases/add_weight_entry.dart';
import 'package:fitness_freaks/features/weight/domain/usecases/get_cached_weight_entries.dart';
import 'package:fitness_freaks/features/weight/domain/usecases/get_weight_entries.dart';
import 'package:fitness_freaks/features/weight/domain/usecases/upload_weight_from_image.dart';
import 'weight_notifier.dart';
import 'weight_state.dart';

// Repository providers
final weightRemoteDataSourceProvider = Provider<WeightRemoteDataSource>((ref) {
  return WeightRemoteDataSourceImpl(
    dio: ref.watch(dioProvider),
  );
});

final weightLocalDataSourceProvider = Provider<WeightLocalDataSource>((ref) {
  return WeightLocalDataSourceImpl(
    storageService: ref.watch(storageServiceProvider),
  );
});

final weightRepositoryProvider = Provider<WeightRepository>((ref) {
  return WeightRepositoryImpl(
    remoteDataSource: ref.watch(weightRemoteDataSourceProvider),
    localDataSource: ref.watch(weightLocalDataSourceProvider),
    connectionChecker: ref.watch(connectionCheckerProvider),
  );
});

// Use case providers
final getWeightEntriesProvider = Provider<GetWeightEntries>((ref) {
  return GetWeightEntries(ref.watch(weightRepositoryProvider));
});

final getCachedWeightEntriesProvider = Provider<GetCachedWeightEntries>((ref) {
  return GetCachedWeightEntries(ref.watch(weightRepositoryProvider));
});

final addWeightEntryProvider = Provider<AddWeightEntry>((ref) {
  return AddWeightEntry(ref.watch(weightRepositoryProvider));
});

final uploadWeightFromImageProvider = Provider<UploadWeightFromImage>((ref) {
  return UploadWeightFromImage(ref.watch(weightRepositoryProvider));
});

// State providers
final weightNotifierProvider =
    StateNotifierProvider<WeightNotifier, WeightState>((ref) {
  return WeightNotifier(
    getWeightEntries: ref.watch(getWeightEntriesProvider),
    getCachedWeightEntries: ref.watch(getCachedWeightEntriesProvider),
    addWeightEntry: ref.watch(addWeightEntryProvider),
    uploadWeightFromImage: ref.watch(uploadWeightFromImageProvider),
  );
});

// Additional providers for filtered data
final filteredWeightEntriesProvider =
    Provider.family<List<WeightEntryEntity>, DateRange>((ref, range) {
  final allEntries = ref.watch(weightNotifierProvider).entries;

  return allEntries.where((entry) {
    final date = entry.dateObject;
    return date.isAfter(range.startDate) &&
        date.isBefore(range.endDate.add(const Duration(days: 1)));
  }).toList();
});

// Provider for statistics
final weightStatisticsProvider = Provider<WeightStatistics>((ref) {
  final entries = ref.watch(weightNotifierProvider).entries;

  if (entries.isEmpty) {
    return WeightStatistics.empty();
  }

  // Sort entries by date (newest first)
  final sortedEntries = List<WeightEntryEntity>.from(entries)
    ..sort((a, b) => b.dateObject.compareTo(a.dateObject));

  final currentWeight = sortedEntries.first.weight;

  // Calculate average weight
  final totalWeight =
      entries.fold<double>(0, (sum, entry) => sum + entry.weight);
  final averageWeight = totalWeight / entries.length;

  // Find highest and lowest weights
  double highestWeight = entries.first.weight;
  double lowestWeight = entries.first.weight;

  for (final entry in entries) {
    if (entry.weight > highestWeight) {
      highestWeight = entry.weight;
    }
    if (entry.weight < lowestWeight) {
      lowestWeight = entry.weight;
    }
  }

  // Calculate weight change
  WeightChange? weightChange;
  if (entries.length > 1) {
    final oldestWeight = sortedEntries.last.weight;
    final change = currentWeight - oldestWeight;
    final percentChange = (change / oldestWeight) * 100;
    weightChange = WeightChange(
      amount: change,
      percentage: percentChange,
    );
  }

  return WeightStatistics(
    currentWeight: currentWeight,
    averageWeight: averageWeight,
    highestWeight: highestWeight,
    lowestWeight: lowestWeight,
    weightChange: weightChange,
  );
});

// Helper classes
class DateRange {
  final DateTime startDate;
  final DateTime endDate;

  DateRange({
    required this.startDate,
    required this.endDate,
  });

  factory DateRange.week() {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: 7));
    return DateRange(startDate: startDate, endDate: now);
  }

  factory DateRange.month() {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: 30));
    return DateRange(startDate: startDate, endDate: now);
  }

  factory DateRange.threeMonths() {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: 90));
    return DateRange(startDate: startDate, endDate: now);
  }

  factory DateRange.sixMonths() {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: 180));
    return DateRange(startDate: startDate, endDate: now);
  }

  factory DateRange.year() {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: 365));
    return DateRange(startDate: startDate, endDate: now);
  }

  factory DateRange.all() {
    final now = DateTime.now();
    final startDate = DateTime(2000);
    return DateRange(startDate: startDate, endDate: now);
  }
}

class WeightChange {
  final double amount;
  final double percentage;

  WeightChange({
    required this.amount,
    required this.percentage,
  });

  bool get isGain => amount >= 0;
}

class WeightStatistics {
  final double currentWeight;
  final double averageWeight;
  final double highestWeight;
  final double lowestWeight;
  final WeightChange? weightChange;

  WeightStatistics({
    required this.currentWeight,
    required this.averageWeight,
    required this.highestWeight,
    required this.lowestWeight,
    this.weightChange,
  });

  factory WeightStatistics.empty() {
    return WeightStatistics(
      currentWeight: 0,
      averageWeight: 0,
      highestWeight: 0,
      lowestWeight: 0,
    );
  }
}
