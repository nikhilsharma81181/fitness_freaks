import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/either.dart';
import '../../domain/failures/failure.dart';
import '../../infrastructure/services/logger_service.dart';

/// Base state notifier that handles loading and error states
///
/// This provides a consistent way to handle loading and error states
/// across different notifiers in the app.
class BaseStateNotifier<T> extends StateNotifier<AsyncValue<T>> {
  final LoggerService? _logger;

  BaseStateNotifier({
    required T initialData,
    LoggerService? logger,
  })  : _logger = logger,
        super(AsyncData(initialData));

  /// Helper method to handle loading state
  void handleLoading() {
    state = const AsyncLoading();
  }
  
  /// Helper method to handle success state
  void handleSuccess(T data) {
    state = AsyncData(data);
  }
  
  /// Helper method to handle error state
  void handleError(Object error, [StackTrace? stackTrace]) {
    _logger?.e('Error in ${runtimeType.toString()}', error: error, stackTrace: stackTrace);
    state = AsyncError(error, stackTrace ?? StackTrace.current);
  }
  
  /// Helper method to run an async operation and handle its states
  Future<void> run(Future<T> Function() operation) async {
    try {
      handleLoading();
      final result = await operation();
      handleSuccess(result);
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
    }
  }
  
  /// Helper method to run an async operation that returns an Either and handle its states
  Future<void> runEither(Future<Either<Failure, T>> Function() operation) async {
    try {
      handleLoading();
      final result = await operation();
      result.fold(
        (failure) => handleError(failure),
        (data) => handleSuccess(data),
      );
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
    }
  }
}

/// Base notifier for managing list state with pagination
///
/// This provides a consistent way to handle paginated lists across the app
class PaginatedStateNotifier<T> extends StateNotifier<AsyncValue<List<T>>> {
  final LoggerService? _logger;
  
  int _page = 1;
  final int _pageSize = 20; // Now marked as final
  bool _hasMoreData = true;
  bool _isLoading = false;
  
  PaginatedStateNotifier({
    List<T> initialData = const [],
    LoggerService? logger,
  })  : _logger = logger,
        super(AsyncData(initialData));
  
  /// Current page
  int get page => _page;
  
  /// Page size
  int get pageSize => _pageSize;
  
  /// Whether more data is available
  bool get hasMoreData => _hasMoreData;
  
  /// Whether data is being loaded
  bool get isLoading => _isLoading;
  
  /// Current items
  List<T> get items => state.value ?? [];

  /// Reset pagination and reload data
  Future<void> refresh(Future<List<T>> Function(int page, int pageSize) fetcher) async {
    try {
      _page = 1;
      _hasMoreData = true;
      _isLoading = true;
      state = const AsyncLoading();
      
      final items = await fetcher(_page, _pageSize);
      _hasMoreData = items.length >= _pageSize;
      
      state = AsyncData(items);
    } catch (e, stackTrace) {
      _logger?.e('Error refreshing data', error: e, stackTrace: stackTrace);
      state = AsyncError(e, stackTrace);
    } finally {
      _isLoading = false;
    }
  }

  /// Load the next page of data
  Future<void> loadMore(Future<List<T>> Function(int page, int pageSize) fetcher) async {
    if (_isLoading || !_hasMoreData) return;
    
    try {
      _isLoading = true;
      _page++;
      
      final newItems = await fetcher(_page, _pageSize);
      final allItems = [...items, ...newItems];
      
      _hasMoreData = newItems.length >= _pageSize;
      state = AsyncData(allItems);
    } catch (e, stackTrace) {
      _logger?.e('Error loading more data', error: e, stackTrace: stackTrace);
      // Revert page increment on error
      _page--;
      // We don't update state to error here to keep existing items
    } finally {
      _isLoading = false;
    }
  }
  
  /// Add an item to the beginning of the list
  void addItem(T item) {
    final currentItems = items;
    state = AsyncData([item, ...currentItems]);
  }
  
  /// Update an item in the list
  void updateItem(bool Function(T item) finder, T updatedItem) {
    final currentItems = items;
    final updatedItems = currentItems.map((item) {
      if (finder(item)) {
        return updatedItem;
      }
      return item;
    }).toList();
    
    state = AsyncData(updatedItems);
  }
  
  /// Remove an item from the list
  void removeItem(bool Function(T item) finder) {
    final currentItems = items;
    final updatedItems = currentItems.where((item) => !finder(item)).toList();
    
    state = AsyncData(updatedItems);
  }
}

/// Base notifier for managing an offline-first feature with sync capabilities
///
/// This is useful for features that need to work offline and sync when online
class SyncableStateNotifier<T> extends StateNotifier<AsyncValue<List<T>>> {
  final LoggerService? _logger;
  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  
  SyncableStateNotifier({
    List<T> initialData = const [],
    LoggerService? logger,
  })  : _logger = logger,
        super(AsyncData(initialData));
  
  /// Whether data is being synchronized
  bool get isSyncing => _isSyncing;
  
  /// Last time data was synchronized
  DateTime? get lastSyncTime => _lastSyncTime;
  
  /// Current items
  List<T> get items => state.value ?? [];
  
  /// Load local data
  Future<void> loadLocalData(Future<List<T>> Function() localFetcher) async {
    try {
      state = const AsyncLoading();
      final localData = await localFetcher();
      state = AsyncData(localData);
    } catch (e, stackTrace) {
      _logger?.e('Error loading local data', error: e, stackTrace: stackTrace);
      state = AsyncError(e, stackTrace);
    }
  }
  
  /// Sync data with the server
  Future<void> syncWithServer({
    required Future<List<T>> Function() remoteFetcher,
    required Future<void> Function(List<T> data) localSaver,
    required Future<void> Function(List<T> localData) uploadPendingChanges,
  }) async {
    if (_isSyncing) return;
    
    try {
      _isSyncing = true;
      
      // First, upload any pending local changes
      final currentData = items;
      await uploadPendingChanges(currentData);
      
      // Then fetch latest data from server
      final remoteData = await remoteFetcher();
      
      // Save remote data locally
      await localSaver(remoteData);
      
      // Update state with latest data
      state = AsyncData(remoteData);
      
      // Update last sync time
      _lastSyncTime = DateTime.now();
    } catch (e, stackTrace) {
      _logger?.e('Error syncing data', error: e, stackTrace: stackTrace);
      // Don't update state to error to keep existing data
    } finally {
      _isSyncing = false;
    }
  }
  
  /// Add an item locally and mark for sync
  Future<void> addItem(
    T item, {
    required Future<void> Function(T item) localSaver,
    Future<void> Function(T item)? remoteUploader,
  }) async {
    try {
      final currentItems = items;
      final updatedItems = [item, ...currentItems];
      
      // Save locally
      await localSaver(item);
      
      // Upload to server if available and connected
      if (remoteUploader != null) {
        try {
          await remoteUploader(item);
        } catch (e) {
          // Handle offline case - item will be uploaded during next sync
          _logger?.w('Failed to upload item, will sync later', error: e);
        }
      }
      
      state = AsyncData(updatedItems);
    } catch (e, stackTrace) {
      _logger?.e('Error adding item', error: e, stackTrace: stackTrace);
      // Don't update state to error
    }
  }
  
  /// Update an item locally and mark for sync
  Future<void> updateItem(
    bool Function(T item) finder,
    T updatedItem, {
    required Future<void> Function(T item) localSaver,
    Future<void> Function(T item)? remoteUploader,
  }) async {
    try {
      final currentItems = items;
      final updatedItems = currentItems.map((item) {
        if (finder(item)) {
          return updatedItem;
        }
        return item;
      }).toList();
      
      // Save locally
      await localSaver(updatedItem);
      
      // Upload to server if available and connected
      if (remoteUploader != null) {
        try {
          await remoteUploader(updatedItem);
        } catch (e) {
          // Handle offline case - item will be updated during next sync
          _logger?.w('Failed to update item remotely, will sync later', error: e);
        }
      }
      
      state = AsyncData(updatedItems);
    } catch (e, stackTrace) {
      _logger?.e('Error updating item', error: e, stackTrace: stackTrace);
      // Don't update state to error
    }
  }
  
  /// Remove an item locally and mark for deletion on server
  Future<void> removeItem(
    bool Function(T item) finder, {
    required Future<void> Function(T item) localDeleter,
    Future<void> Function(T item)? remoteDeleter,
  }) async {
    try {
      final currentItems = items;
      final itemToDelete = currentItems.firstWhere(finder);
      final updatedItems = currentItems.where((item) => !finder(item)).toList();
      
      // Delete locally
      await localDeleter(itemToDelete);
      
      // Delete from server if available and connected
      if (remoteDeleter != null) {
        try {
          await remoteDeleter(itemToDelete);
        } catch (e) {
          // Handle offline case - item will be deleted during next sync
          _logger?.w('Failed to delete item remotely, will sync later', error: e);
        }
      }
      
      state = AsyncData(updatedItems);
    } catch (e, stackTrace) {
      _logger?.e('Error removing item', error: e, stackTrace: stackTrace);
      // Don't update state to error
    }
  }
}