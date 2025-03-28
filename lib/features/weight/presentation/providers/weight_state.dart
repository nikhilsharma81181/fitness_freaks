import 'package:equatable/equatable.dart';
import 'package:fitness_freaks/features/weight/domain/entities/weight_entry.dart';

/// Status of a weight-related operation
enum WeightStatus {
  /// Initial state, no operation has been performed yet
  initial,
  
  /// Loading state, an operation is in progress
  loading,
  
  /// Success state, operation completed successfully
  success,
  
  /// Error state, operation failed
  error,
  
  /// Processing state, specific for image upload operations
  processing,
}

/// State for weight-related operations
class WeightState extends Equatable {
  final List<WeightEntryEntity> entries;
  final WeightStatus status;
  final String? errorMessage;
  final bool isOffline;
  final double? uploadProgress;
  final bool isSyncing;
  
  const WeightState({
    this.entries = const [],
    this.status = WeightStatus.initial,
    this.errorMessage,
    this.isOffline = false,
    this.uploadProgress,
    this.isSyncing = false,
  });
  
  /// Initial state
  factory WeightState.initial() => const WeightState(
    status: WeightStatus.initial,
  );
  
  /// Loading state
  factory WeightState.loading() => const WeightState(
    status: WeightStatus.loading,
  );
  
  /// Success state
  factory WeightState.success(List<WeightEntryEntity> entries) => WeightState(
    entries: entries,
    status: WeightStatus.success,
  );
  
  /// Error state
  factory WeightState.error(String message) => WeightState(
    status: WeightStatus.error,
    errorMessage: message,
  );
  
  /// Offline state with cached data
  factory WeightState.offline(List<WeightEntryEntity> entries) => WeightState(
    entries: entries,
    status: WeightStatus.success,
    isOffline: true,
  );
  
  /// Processing state for image upload
  factory WeightState.processing(
    List<WeightEntryEntity> entries,
    double progress
  ) => WeightState(
    entries: entries,
    status: WeightStatus.processing,
    uploadProgress: progress,
  );
  
  /// Sync in progress state
  factory WeightState.syncing(List<WeightEntryEntity> entries) => WeightState(
    entries: entries,
    status: WeightStatus.loading,
    isSyncing: true,
  );
  
  /// Copy with new values
  WeightState copyWith({
    List<WeightEntryEntity>? entries,
    WeightStatus? status,
    String? errorMessage,
    bool? isOffline,
    double? uploadProgress,
    bool? isSyncing,
  }) {
    return WeightState(
      entries: entries ?? this.entries,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isOffline: isOffline ?? this.isOffline,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
  
  @override
  List<Object?> get props => [
    entries,
    status,
    errorMessage,
    isOffline,
    uploadProgress,
    isSyncing,
  ];
}
