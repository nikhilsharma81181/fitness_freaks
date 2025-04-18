import '../../domain/entities/either.dart';
import '../../domain/failures/failure.dart';

/// Base interface for all repositories
///
/// [T] is the entity type this repository deals with
abstract class Repository<T> {
  /// Get all entities of type T
  ///
  /// Returns Either a Failure or a List of entities
  Future<Either<Failure, List<T>>> getAll();
}

/// Repository interface with CRUD operations
///
/// [T] is the entity type this repository deals with
/// [ID] is the type of the entity's identifier
abstract class CrudRepository<T, ID> extends Repository<T> {
  /// Get an entity by its ID
  ///
  /// [id] is the entity's identifier
  /// Returns Either a Failure or the entity
  Future<Either<Failure, T>> getById(ID id);
  
  /// Save an entity
  ///
  /// [entity] is the entity to save
  /// Returns Either a Failure or the saved entity
  Future<Either<Failure, T>> save(T entity);
  
  /// Update an entity
  ///
  /// [entity] is the entity to update
  /// Returns Either a Failure or the updated entity
  Future<Either<Failure, T>> update(T entity);
  
  /// Delete an entity by its ID
  ///
  /// [id] is the entity's identifier
  /// Returns Either a Failure or a boolean indicating success
  Future<Either<Failure, bool>> delete(ID id);
}

/// Repository interface for entities that need synchronization
///
/// [T] is the entity type this repository deals with
abstract class SyncRepository<T> extends Repository<T> {
  /// Synchronize local data with remote server
  ///
  /// Returns Either a Failure or a SyncResult
  Future<Either<Failure, SyncResult>> sync();
  
  /// Get the last synchronization timestamp
  Future<DateTime?> getLastSyncTime();
  
  /// Check if there are any pending changes that need to be synced
  Future<bool> hasPendingChanges();
}

/// Repository interface for entities with paging support
///
/// [T] is the entity type this repository deals with
abstract class PagedRepository<T> extends Repository<T> {
  /// Get a page of entities
  ///
  /// [page] is the page number (1-based)
  /// [pageSize] is the number of items per page
  /// Returns Either a Failure or a PagedResult of entities
  Future<Either<Failure, PagedResult<T>>> getPage(int page, int pageSize);
}

/// Result of a synchronization operation
class SyncResult {
  final int added;
  final int updated;
  final int deleted;
  final int conflictsResolved;
  final List<SyncError> errors;
  
  SyncResult({
    this.added = 0,
    this.updated = 0,
    this.deleted = 0,
    this.conflictsResolved = 0,
    this.errors = const [],
  });
  
  bool get hasErrors => errors.isNotEmpty;
  
  int get totalChanges => added + updated + deleted;
  
  @override
  String toString() {
    return 'SyncResult(added: $added, updated: $updated, deleted: $deleted, '
        'conflictsResolved: $conflictsResolved, errors: ${errors.length})';
  }
}

/// Error that occurred during synchronization
class SyncError {
  final String entityId;
  final String message;
  final Object? error;
  
  SyncError({
    required this.entityId,
    required this.message,
    this.error,
  });
  
  @override
  String toString() => 'SyncError(entityId: $entityId, message: $message)';
}

/// Result of a paged query
class PagedResult<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  
  PagedResult({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalItems,
  }) : totalPages = (totalItems / pageSize).ceil();
  
  bool get hasNextPage => page < totalPages;
  
  bool get hasPreviousPage => page > 1;
  
  @override
  String toString() {
    return 'PagedResult(items: ${items.length}, page: $page, '
        'pageSize: $pageSize, totalItems: $totalItems, totalPages: $totalPages)';
  }
}
