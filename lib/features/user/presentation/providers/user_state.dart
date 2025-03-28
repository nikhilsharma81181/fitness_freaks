import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

/// Status of a user-related operation
enum UserStatus {
  /// Initial state, no operation has been performed yet
  initial,
  
  /// Loading state, an operation is in progress
  loading,
  
  /// Success state, operation completed successfully
  success,
  
  /// Error state, operation failed
  error,
}

/// State for user-related operations
class UserState extends Equatable {
  final UserEntity? user;
  final UserStatus status;
  final String? errorMessage;
  final bool isOffline;
  
  const UserState({
    this.user,
    this.status = UserStatus.initial,
    this.errorMessage,
    this.isOffline = false,
  });
  
  /// Initial state
  factory UserState.initial() => const UserState(
    status: UserStatus.initial,
  );
  
  /// Loading state
  factory UserState.loading() => const UserState(
    status: UserStatus.loading,
  );
  
  /// Success state
  factory UserState.success(UserEntity user) => UserState(
    user: user,
    status: UserStatus.success,
  );
  
  /// Error state
  factory UserState.error(String message) => UserState(
    status: UserStatus.error,
    errorMessage: message,
  );
  
  /// Offline state with cached data
  factory UserState.offline(UserEntity user) => UserState(
    user: user,
    status: UserStatus.success,
    isOffline: true,
  );
  
  /// Copy with new values
  UserState copyWith({
    UserEntity? user,
    UserStatus? status,
    String? errorMessage,
    bool? isOffline,
  }) {
    return UserState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isOffline: isOffline ?? this.isOffline,
    );
  }
  
  @override
  List<Object?> get props => [user, status, errorMessage, isOffline];
}
