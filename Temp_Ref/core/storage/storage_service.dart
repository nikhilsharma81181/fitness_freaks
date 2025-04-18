/// Abstract interface for storage operations
/// This allows swapping implementations (Hive, SharedPreferences, etc.) without changing client code
abstract class StorageService {
  /// Initialize the storage service
  Future<void> init();
  
  /// Check if the storage contains a value for the given key
  Future<bool> hasKey(String key);
  
  /// Read a value from storage
  Future<T?> read<T>(String key);
  
  /// Write a value to storage
  Future<void> write<T>(String key, T value);
  
  /// Remove a value from storage
  Future<void> delete(String key);
  
  /// Clear all values from storage
  Future<void> clearAll();
}
