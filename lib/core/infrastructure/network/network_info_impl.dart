import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/datasources/remote/network_info.dart';

/// Implementation of NetworkInfo that uses the connectivity_plus package
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  
  NetworkInfoImpl(this._connectivity);
  
  // Helper method to check if there's any connectivity
  bool _hasConnectivity(dynamic result) {
    if (result is Iterable) {
      // For newer versions of connectivity_plus that return a list
      // Use Iterable.any to avoid type casting issues
      return result.any((item) => 
        item == ConnectivityResult.wifi || 
        item == ConnectivityResult.mobile ||
        (item != ConnectivityResult.none && item != null)
      );
    } else {
      // For older versions that return a single value
      return result != ConnectivityResult.none;
    }
  }
  
  // Helper method to determine if we have WiFi specifically
  bool _hasWifi(dynamic result) {
    if (result is Iterable) {
      // For newer versions of connectivity_plus that return a list
      for (final item in result) {
        if (item == ConnectivityResult.wifi) return true;
      }
      return false;
    } else {
      // For older versions that return a single value
      return result == ConnectivityResult.wifi;
    }
  }
  
  // Helper method to determine if we have mobile data specifically
  bool _hasMobile(dynamic result) {
    if (result is Iterable) {
      // For newer versions of connectivity_plus that return a list
      for (final item in result) {
        if (item == ConnectivityResult.mobile) return true;
      }
      return false;
    } else {
      // For older versions that return a single value
      return result == ConnectivityResult.mobile;
    }
  }
  
  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _hasConnectivity(result);
  }
  
  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((event) => _hasConnectivity(event));
  }
  
  @override
  Future<ConnectivityStatus> get connectivityStatus async {
    final result = await _connectivity.checkConnectivity();
    
    if (_hasWifi(result)) {
      return ConnectivityStatus.wifi;
    } else if (_hasMobile(result)) {
      return ConnectivityStatus.mobile;
    } else {
      return ConnectivityStatus.offline;
    }
  }
}