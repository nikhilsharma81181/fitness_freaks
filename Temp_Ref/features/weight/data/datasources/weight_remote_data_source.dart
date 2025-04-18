import 'package:fitness_freaks/features/weight/data/models/weight_entry_model.dart';

/// Interface for remote data source operations
abstract class WeightRemoteDataSource {
  /// Get all weight entries from the remote API
  Future<List<WeightEntryModel>> getWeightEntries();
  
  /// Upload a weight entry with image to the remote API
  Future<WeightEntryModel> uploadWeightFromImage(String imageBase64);
  
  /// Add a new weight entry manually to the remote API
  Future<WeightEntryModel> addWeightEntry(double weight, String date);
}
