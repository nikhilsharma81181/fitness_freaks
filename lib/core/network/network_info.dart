/// Interface for checking network connectivity
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of NetworkInfo that always returns true
/// In a real app, you would use a package like connectivity_plus to check network status
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
} 