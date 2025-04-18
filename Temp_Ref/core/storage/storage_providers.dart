import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'hive_storage_service.dart';
import 'storage_service.dart';

/// Provider for the storage service
final storageServiceProvider = Provider<StorageService>((ref) {
  return HiveStorageService();
});
