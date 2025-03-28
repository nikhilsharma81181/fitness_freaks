import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/create_user.dart';
import '../../domain/usecases/delete_user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/update_user.dart';
import '../../domain/usecases/upload_profile_picture.dart';
import 'user_state.dart';

/// Notifier for user-related operations
class UserNotifier extends StateNotifier<UserState> {
  final CreateUser _createUser;
  final GetUser _getUser;
  final UpdateUser _updateUser;
  final UploadProfilePicture _uploadProfilePicture;
  final DeleteUser _deleteUser;
  
  UserNotifier({
    required CreateUser createUser,
    required GetUser getUser,
    required UpdateUser updateUser,
    required UploadProfilePicture uploadProfilePicture,
    required DeleteUser deleteUser,
  })  : _createUser = createUser,
        _getUser = getUser,
        _updateUser = updateUser,
        _uploadProfilePicture = uploadProfilePicture,
        _deleteUser = deleteUser,
        super(UserState.initial());
  
  /// Create a new user
  Future<void> createUser(UserEntity user) async {
    state = UserState.loading();
    
    final result = await _createUser(user);
    
    state = result.fold(
      (failure) => UserState.error(_mapFailureToMessage(failure)),
      (user) => UserState.success(user),
    );
  }
  
  // Track if a request is already in progress to prevent duplicate calls
  bool _isRequestInProgress = false;
  
  /// Get current user
  Future<void> getUser() async {
    // Prevent multiple simultaneous calls
    if (_isRequestInProgress) {
      return;
    }
    
    _isRequestInProgress = true;
    
    try {
      state = state.copyWith(status: UserStatus.loading);
      
      final result = await _getUser(NoParams());
      
      state = result.fold(
        (failure) {
          if (failure is ConnectionFailure && state.user != null) {
            return UserState.offline(state.user!);
          }
          return UserState.error(_mapFailureToMessage(failure));
        },
        (user) => UserState.success(user),
      );
    } catch (e) {
      debugPrint('Error in getUser: $e');
      
      // Don't update state to error if we already have user data
      if (state.user == null) {
        state = UserState.error('Failed to load user: $e');
      } else {
        state = state.copyWith(status: UserStatus.success);
      }
    } finally {
      _isRequestInProgress = false;
    }
  }
  
  /// Update user
  Future<void> updateUser(UserEntity user) async {
    state = state.copyWith(status: UserStatus.loading);
    
    final result = await _updateUser(user);
    
    state = result.fold(
      (failure) {
        if (failure is ConnectionFailure && state.user != null) {
          return UserState.offline(state.user!);
        }
        return UserState.error(_mapFailureToMessage(failure));
      },
      (user) => UserState.success(user),
    );
  }
  
  /// Upload profile picture
  Future<void> uploadProfilePicture(File file) async {
    state = state.copyWith(status: UserStatus.loading);
    
    final result = await _uploadProfilePicture(file);
    
    state = result.fold(
      (failure) => UserState.error(_mapFailureToMessage(failure)),
      (user) => UserState.success(user),
    );
  }
  
  /// Delete user
  Future<void> deleteUser() async {
    state = state.copyWith(status: UserStatus.loading);
    
    final result = await _deleteUser(NoParams());
    
    state = result.fold(
      (failure) => UserState.error(_mapFailureToMessage(failure)),
      (_) => UserState.initial(),
    );
  }
  
  /// Reset state to initial
  void reset() {
    state = UserState.initial();
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
      case AuthFailure:
        final authFailure = failure as AuthFailure;
        switch (authFailure.type) {
          case AuthFailureType.unauthorized:
            return 'You are not authorized to perform this action.';
          case AuthFailureType.userNotFound:
            return 'User not found.';
          default:
            return authFailure.message;
        }
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
