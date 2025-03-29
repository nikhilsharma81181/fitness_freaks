import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/image_compressor.dart';
import '../../domain/entities/weight_entry.dart';
import '../../domain/usecases/add_weight_entry.dart';
import '../../domain/usecases/get_cached_weight_entries.dart';
import '../../domain/usecases/get_weight_entries.dart';
import '../../domain/usecases/upload_weight_from_image.dart';
import 'weight_state.dart';

/// Notifier for weight-related operations
class WeightNotifier extends StateNotifier<WeightState> {
  final GetWeightEntries _getWeightEntries;
  final GetCachedWeightEntries _getCachedWeightEntries;
  final AddWeightEntry _addWeightEntry;
  final UploadWeightFromImage _uploadWeightFromImage;

  WeightNotifier({
    required GetWeightEntries getWeightEntries,
    required GetCachedWeightEntries getCachedWeightEntries,
    required AddWeightEntry addWeightEntry,
    required UploadWeightFromImage uploadWeightFromImage,
  })  : _getWeightEntries = getWeightEntries,
        _getCachedWeightEntries = getCachedWeightEntries,
        _addWeightEntry = addWeightEntry,
        _uploadWeightFromImage = uploadWeightFromImage,
        super(WeightState.initial());

  // Track if a request is already in progress to prevent duplicate calls
  bool _isRequestInProgress = false;

  /// Get weight entries from server
  ///
  /// If [forceRefresh] is true, it will ignore any in-progress request and fetch new data
  Future<void> getWeightEntries({bool forceRefresh = false}) async {
    // Prevent multiple simultaneous calls unless force refresh is requested
    if (_isRequestInProgress && !forceRefresh) {
      return;
    }

    _isRequestInProgress = true;

    try {
      // Don't set loading state if we're just syncing and already have data
      if (state.entries.isEmpty) {
        state = WeightState.loading();
      } else {
        state = state.copyWith(isSyncing: true);
      }

      // First try to get cached data for immediate display (skip if force refreshing)
      if (!forceRefresh) {
        final cachedResult = await _getCachedWeightEntries(NoParams());
        cachedResult.fold(
          (failure) {
            // If cache fails, continue with server request
            debugPrint('Cache retrieval failed: ${failure.message}');
          },
          (cachedEntries) {
            if (cachedEntries.isNotEmpty && state.entries.isEmpty) {
              // Only update with cached data if we don't already have data
              state = state.copyWith(
                entries: cachedEntries,
                status: WeightStatus.success,
              );
            }
          },
        );
      }

      // Then get fresh data from server
      final result = await _getWeightEntries(NoParams());

      state = result.fold(
        (failure) {
          if (failure is ConnectionFailure && state.entries.isNotEmpty) {
            return WeightState.offline(state.entries);
          }
          return WeightState.error(_mapFailureToMessage(failure));
        },
        (entries) => WeightState.success(entries),
      );
    } catch (e) {
      debugPrint('Error in getWeightEntries: $e');

      // Don't update state to error if we already have entries
      if (state.entries.isEmpty) {
        state = WeightState.error('Failed to load weight entries: $e');
      } else {
        state = state.copyWith(isSyncing: false);
      }
    } finally {
      _isRequestInProgress = false;
    }
  }

  /// Add a weight entry manually
  Future<void> addWeightEntry(double weight, String date) async {
    state = state.copyWith(status: WeightStatus.loading);

    final params = AddWeightEntryParams(
      weight: weight,
      date: date,
    );

    final result = await _addWeightEntry(params);

    state = result.fold(
      (failure) => WeightState.error(_mapFailureToMessage(failure)),
      (entry) {
        final updatedEntries = [...state.entries, entry];
        // Sort entries by date (newest first)
        updatedEntries.sort((a, b) => b.dateObject.compareTo(a.dateObject));
        return WeightState.success(updatedEntries);
      },
    );
  }

  /// Upload a weight entry with image
  Future<void> uploadWeightImage(File imageFile) async {
    // Set initial processing state
    state = WeightState.processing(state.entries, 0.1);

    try {
      // Compress the image
      final compressedImage = await ImageCompressor.compressFile(
        file: imageFile,
        quality: 85,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      // Update progress
      state = WeightState.processing(state.entries, 0.4);

      // Convert to base64
      final bytes = await compressedImage.readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      // Update progress
      state = WeightState.processing(state.entries, 0.6);

      // Upload the image
      final params = UploadWeightFromImageParams(
        imageBase64: base64Image,
      );

      final result = await _uploadWeightFromImage(params);

      // Update progress
      state = WeightState.processing(state.entries, 0.9);

      // Process result
      state = result.fold(
        (failure) => WeightState.error(_mapFailureToMessage(failure)),
        (entry) {
          final updatedEntries = [...state.entries];

          // Check if entry with same ID already exists
          final existingIndex =
              updatedEntries.indexWhere((e) => e.id == entry.id);

          if (existingIndex >= 0) {
            // Update existing entry
            updatedEntries[existingIndex] = entry;
          } else {
            // Add new entry
            updatedEntries.add(entry);
          }

          // Sort entries by date (newest first)
          updatedEntries.sort((a, b) => b.dateObject.compareTo(a.dateObject));

          return WeightState.success(updatedEntries);
        },
      );

      // Get fresh data from server to ensure we have the latest
      await getWeightEntries();
    } catch (e) {
      state = WeightState.error('Failed to process image: ${e.toString()}');
    }
  }

  /// Filter entries by date range
  List<WeightEntryEntity> filterEntriesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return state.entries.where((entry) {
      final date = entry.dateObject;
      return date.isAfter(startDate) &&
          date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  /// Reset state to initial
  void reset() {
    state = WeightState.initial();
  }

  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    debugPrint('Failure: ${failure.runtimeType} - ${failure.message}');

    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case ConnectionFailure:
        return 'No internet connection. Please check your connection.';
      case CacheFailure:
        return 'Cache error. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
