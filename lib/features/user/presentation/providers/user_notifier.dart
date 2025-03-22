import 'dart:async';

import 'package:fitness_freaks/core/di/providers.dart';
import 'package:fitness_freaks/features/user/data/models/user_model.dart';
import 'package:fitness_freaks/features/user/domain/entities/user.dart';
import 'package:fitness_freaks/features/user/domain/usecases/usecase_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_notifier.g.dart';

enum UserStatus { initial, loading, authenticated, unauthenticated, error }

@immutable
class UserState {
  final UserStatus status;
  final User? user;
  final String? errorMessage;

  const UserState({required this.status, this.user, this.errorMessage});

  factory UserState.initial() {
    return const UserState(status: UserStatus.initial);
  }

  UserState copyWith({UserStatus? status, User? user, String? errorMessage}) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class UserNotifier extends _$UserNotifier {
  StreamSubscription<UserModel?>? _authStateSubscription;

  @override
  UserState build() {
    print("UserNotifier: build method called");
    ref.onDispose(() {
      print("UserNotifier: disposing auth state subscription");
      _authStateSubscription?.cancel();
    });

    _setupAuthStateListener();

    return UserState.initial();
  }

  void _setupAuthStateListener() async {
    try {
      print("UserNotifier: Setting up auth state listener");
      // Make sure repository is initialized
      ref.read(initializeRepositoryProvider);

      // Get auth service
      final authService = await ref.read(authServiceProvider.future);
      print("UserNotifier: Got auth service");

      // Listen to auth state changes
      _authStateSubscription = authService.onAuthStateChanged.listen(
        (user) {
          if (user != null) {
            print(
              "UserNotifier: Auth state changed - user authenticated: ${user.email}",
            );
            state = state.copyWith(
              status: UserStatus.authenticated,
              user: user,
            );
          } else {
            print("UserNotifier: Auth state changed - user unauthenticated");
            state = state.copyWith(
              status: UserStatus.unauthenticated,
              user: null,
            );
          }
        },
        onError: (error) {
          print('UserNotifier: Auth state listener error: $error');
          state = state.copyWith(
            status: UserStatus.error,
            errorMessage: 'Authentication error: $error',
          );
        },
      );

      // Check current user immediately
      print("UserNotifier: Checking current user");
      getCurrentUser();
    } catch (e) {
      print('UserNotifier: Error setting up auth state listener: $e');
      state = state.copyWith(
        status: UserStatus.error,
        errorMessage: 'Setup error: $e',
      );
    }
  }

  Future<void> getCurrentUser() async {
    if (state.status == UserStatus.authenticated) {
      print(
        "UserNotifier: User already authenticated, skipping getCurrentUser",
      );
      return;
    }

    print("UserNotifier: Getting current user");
    state = state.copyWith(status: UserStatus.loading);

    try {
      ref.read(initializeRepositoryProvider);
      final userRepositorySync = ref.read(userRepositorySyncProvider);

      if (userRepositorySync == null) {
        print(
          "UserNotifier: Repository not initialized, setting unauthenticated",
        );
        state = state.copyWith(status: UserStatus.unauthenticated);
        return;
      }

      final useCase = ref.read(getCurrentUserUseCaseProvider);
      final result = await useCase.call();

      state = result.fold(
        (failure) {
          print("UserNotifier: Failed to get current user: $failure");
          return state.copyWith(status: UserStatus.unauthenticated);
        },
        (user) {
          print("UserNotifier: Got current user: ${user.email}");
          return state.copyWith(status: UserStatus.authenticated, user: user);
        },
      );
    } catch (e) {
      print('UserNotifier: Error getting current user: $e');
      state = state.copyWith(
        status: UserStatus.unauthenticated,
        errorMessage: 'Failed to get current user: $e',
      );
    }
  }

  Future<void> signInWithGoogle() async {
    print('UserNotifier: Starting Google Sign-In');
    state = state.copyWith(status: UserStatus.loading);

    try {
      final result = await ref.read(signInWithGoogleUseCaseProvider).call();

      state = result.fold(
        (failure) {
          print(
            'UserNotifier: Google Sign-In failed with failure: ${failure.runtimeType}',
          );
          return state.copyWith(
            status: UserStatus.error,
            errorMessage: 'Google sign-in failed. Please try again.',
          );
        },
        (user) {
          print(
            'UserNotifier: Google Sign-In succeeded for user: ${user.email}',
          );
          return state.copyWith(status: UserStatus.authenticated, user: user);
        },
      );
    } catch (e) {
      print('UserNotifier: Google Sign-In threw an exception: ${e.toString()}');
      state = state.copyWith(
        status: UserStatus.error,
        errorMessage: 'Google sign-in failed: ${e.toString()}',
      );
    }
  }

  Future<void> signOut() async {
    print("UserNotifier: Signing out");
    state = state.copyWith(status: UserStatus.loading);

    try {
      final useCase = ref.read(signOutUserUseCaseProvider);
      if (useCase == null) {
        print("UserNotifier: SignOutUserUseCase is null");
        state = state.copyWith(
          status: UserStatus.error,
          errorMessage: 'Sign out failed: UseCase is null',
        );
        return;
      }

      final result = await useCase.call();

      state = result.fold(
        (failure) {
          print("UserNotifier: Sign out failed: $failure");
          return state.copyWith(
            status: UserStatus.error,
            errorMessage: 'Sign out failed',
          );
        },
        (_) {
          print("UserNotifier: Sign out succeeded");
          return state.copyWith(status: UserStatus.unauthenticated, user: null);
        },
      );
    } catch (e) {
      print("UserNotifier: Sign out threw exception: $e");
      state = state.copyWith(
        status: UserStatus.error,
        errorMessage: 'Sign out failed: ${e.toString()}',
      );
    }
  }
}
