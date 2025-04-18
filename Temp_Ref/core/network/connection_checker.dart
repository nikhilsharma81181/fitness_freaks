import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Enum representing network connection states
enum ConnectionStatus {
  /// Connected to the internet
  connected,

  /// Not connected to the internet
  disconnected,
}

/// Service for checking and monitoring network connectivity
class ConnectionChecker {
  /// Stream controller for network status changes
  final _connectionStatusController =
      StreamController<ConnectionStatus>.broadcast();

  /// The current connectivity instance
  final Connectivity _connectivity = Connectivity();

  /// Subscription to connectivity changes
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// The current connection status
  ConnectionStatus _currentStatus = ConnectionStatus.disconnected;

  /// Singleton instance
  static final ConnectionChecker _instance = ConnectionChecker._internal();

  /// Factory constructor
  factory ConnectionChecker() => _instance;

  /// Private constructor
  ConnectionChecker._internal();

  /// Initialize the connection checker
  void initialize() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    // Check the initial connection status
    _checkInitialConnection();
  }

  /// Check the initial connection status
  Future<void> _checkInitialConnection() async {
    final connectivityResults = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResults);
  }

  /// Update the connection status based on connectivity result
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      _currentStatus = ConnectionStatus.disconnected;
    } else {
      _currentStatus = ConnectionStatus.connected;
    }

    // Notify listeners
    _connectionStatusController.add(_currentStatus);
  }

  /// Check if the device is currently connected
  Future<bool> isConnected() async {
    final connectivityResults = await _connectivity.checkConnectivity();
    return connectivityResults.isNotEmpty &&
        !connectivityResults.contains(ConnectivityResult.none);
  }

  /// Get the current connection status
  ConnectionStatus get currentStatus => _currentStatus;

  /// Stream of connection status changes
  Stream<ConnectionStatus> get onStatusChange =>
      _connectionStatusController.stream;

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionStatusController.close();
  }
}

/// Provider for the connection checker
final connectionCheckerProvider = Provider<ConnectionChecker>((ref) {
  final checker = ConnectionChecker();
  checker.initialize();

  // Dispose the checker when the provider is disposed
  ref.onDispose(() {
    checker.dispose();
  });

  return checker;
});

/// Provider for the current connection status
final connectionStatusProvider = StreamProvider<ConnectionStatus>((ref) {
  final checker = ref.watch(connectionCheckerProvider);
  return checker.onStatusChange;
});
