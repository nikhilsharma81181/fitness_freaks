/// Interface for local storage operations
abstract class LocalStorage {
  /// Initialize the storage (should be called before any other method)
  Future<void> init();

  /// Open a storage box with the given name
  ///
  /// [name] is the name of the box to open
  /// [encryptionKey] is an optional encryption key for sensitive data
  Future<Box> openBox(String name, {List<int>? encryptionKey});

  /// Check if a box with the given name exists
  ///
  /// [name] is the name of the box to check
  Future<bool> boxExists(String name);

  /// Delete a box with the given name
  ///
  /// [name] is the name of the box to delete
  Future<void> deleteBox(String name);

  /// Clear all data from all boxes
  Future<void> clearAll();
  
  /// Get the list of all open boxes
  List<Box> get openBoxes;
  
  /// Register an adapter for a custom type
  void registerAdapter<T>(TypeAdapter<T> adapter);
}

/// Interface representing a storage box (collection of key-value pairs)
abstract class Box<T> {
  /// The name of the box
  String get name;
  
  /// The number of entries in the box
  int get length;
  
  /// All keys in the box
  Iterable<dynamic> get keys;
  
  /// All values in the box
  Iterable<T> get values;
  
  /// Check if the box is empty
  bool get isEmpty;
  
  /// Check if the box is not empty
  bool get isNotEmpty;
  
  /// Get a value by its key
  T? get(dynamic key, {T? defaultValue});
  
  /// Put a value at the given key
  Future<void> put(dynamic key, T value);
  
  /// Put multiple key-value pairs at once
  Future<void> putAll(Map<dynamic, T> entries);
  
  /// Delete a value by its key
  Future<void> delete(dynamic key);
  
  /// Delete multiple values by their keys
  Future<void> deleteAll(Iterable<dynamic> keys);
  
  /// Clear all values from the box
  Future<void> clear();
  
  /// Check if the box contains a key
  bool containsKey(dynamic key);
}

/// Interface for a type adapter used for serialization/deserialization
abstract class TypeAdapter<T> {
  /// Unique identifier for this adapter type
  int get typeId;
  
  /// Convert an object to a storable format
  dynamic toStorage(T value);
  
  /// Create an object from stored data
  T fromStorage(dynamic data);
}
