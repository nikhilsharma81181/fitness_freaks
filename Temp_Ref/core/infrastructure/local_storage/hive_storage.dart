import '../../data/datasources/local/local_storage.dart' as interfaces;

/// Basic in-memory implementation of the [LocalStorage] interface
/// This is a placeholder until a proper implementation is added
class InMemoryStorage implements interfaces.LocalStorage {
  final Map<String, InMemoryBoxWrapper> _openBoxes = {};
  bool _initialized = false;
  
  @override
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
  }
  
  @override
  Future<interfaces.Box> openBox(String name, {List<int>? encryptionKey}) async {
    if (!_initialized) {
      await init();
    }
    
    if (_openBoxes.containsKey(name)) {
      return _openBoxes[name]!;
    }
    
    final box = InMemoryBoxWrapper(name);
    _openBoxes[name] = box;
    return box;
  }
  
  @override
  Future<bool> boxExists(String name) async {
    if (!_initialized) {
      await init();
    }
    
    return _openBoxes.containsKey(name);
  }
  
  @override
  Future<void> deleteBox(String name) async {
    if (!_initialized) {
      await init();
    }
    
    if (_openBoxes.containsKey(name)) {
      await _openBoxes[name]!.clear();
      _openBoxes.remove(name);
    }
  }
  
  @override
  Future<void> clearAll() async {
    if (!_initialized) {
      await init();
    }
    
    for (final wrapper in _openBoxes.values) {
      await wrapper.clear();
    }
  }
  
  @override
  List<interfaces.Box> get openBoxes => _openBoxes.values.toList();
  
  @override
  void registerAdapter<T>(interfaces.TypeAdapter<T> adapter) {
    // No-op for in-memory implementation
  }
}

/// In-memory implementation of Box
class InMemoryBoxWrapper<T> implements interfaces.Box<T> {
  final String _name;
  final Map<dynamic, T> _data = {};
  
  InMemoryBoxWrapper(this._name);
  
  @override
  String get name => _name;
  
  @override
  int get length => _data.length;
  
  @override
  Iterable get keys => _data.keys;
  
  @override
  Iterable<T> get values => _data.values;
  
  @override
  bool get isEmpty => _data.isEmpty;
  
  @override
  bool get isNotEmpty => _data.isNotEmpty;
  
  @override
  T? get(dynamic key, {T? defaultValue}) {
    return _data[key] ?? defaultValue;
  }
  
  @override
  Future<void> put(dynamic key, T value) async {
    _data[key] = value;
  }
  
  @override
  Future<void> putAll(Map<dynamic, T> entries) async {
    _data.addAll(entries);
  }
  
  @override
  Future<void> delete(dynamic key) async {
    _data.remove(key);
  }
  
  @override
  Future<void> deleteAll(Iterable keys) async {
    for (final key in keys) {
      _data.remove(key);
    }
  }
  
  @override
  Future<void> clear() async {
    _data.clear();
  }
  
  @override
  bool containsKey(dynamic key) {
    return _data.containsKey(key);
  }
}