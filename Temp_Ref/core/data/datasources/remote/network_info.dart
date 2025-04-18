/// Interface for checking network connectivity
abstract class NetworkInfo {
  /// Returns true if the device is connected to the network
  Future<bool> get isConnected;
  
  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged;
  
  /// Returns a detailed connectivity status
  Future<ConnectivityStatus> get connectivityStatus;
}

/// Enum representing the different connectivity states
enum ConnectivityStatus {
  /// WiFi connection
  wifi,
  
  /// Mobile data connection
  mobile,
  
  /// No connection
  offline
}
