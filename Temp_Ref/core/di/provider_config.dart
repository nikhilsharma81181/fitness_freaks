import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers.dart';

/// Initializes all providers that need to be setup before the app starts
///
/// Returns a configured ProviderContainer
Future<ProviderContainer> initializeProviders() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Create a ProviderContainer with overrides for async dependencies
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    observers: kDebugMode ? [_ProviderLogger()] : [],
  );
  
  // Initialize LocalStorage
  await container.read(localStorageProvider).init();
  
  return container;
}

/// A provider observer that logs provider changes in debug mode
class _ProviderLogger extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      print('Provider added: ${provider.name ?? provider.runtimeType}');
    }
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      print('Provider updated: ${provider.name ?? provider.runtimeType}');
    }
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      print('Provider disposed: ${provider.name ?? provider.runtimeType}');
    }
  }
}
