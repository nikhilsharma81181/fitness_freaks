import 'package:fitness_freaks/features/user/domain/entities/user.dart';
import 'package:fitness_freaks/features/user/domain/usecases/sign_in_user.dart';
import 'package:fitness_freaks/features/user/domain/usecases/sign_out_user.dart';
import 'package:fitness_freaks/features/user/domain/usecases/sign_up_user.dart';
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
  @override
  UserState build() {
    ref.onDispose(() {});

    Future.microtask(() => _checkCurrentUser());

    return UserState.initial();
  }

  Future<void> _checkCurrentUser() async {
    if (state.status == UserStatus.initial) {
      await getCurrentUser();
    }
  }

  Future<void> getCurrentUser() async {
    state = state.copyWith(status: UserStatus.loading);

    try {
      ref.read(initializeRepositoryProvider);
      final userRepositorySync = ref.read(userRepositorySyncProvider);

      if (userRepositorySync == null) {
        state = state.copyWith(status: UserStatus.unauthenticated);
        return;
      }

      final useCase = ref.read(getCurrentUserUseCaseProvider);
      final result = await useCase.call();

      state = result.fold(
        (failure) => state.copyWith(status: UserStatus.unauthenticated),
        (user) => state.copyWith(status: UserStatus.authenticated, user: user),
      );
    } catch (e) {
      state = state.copyWith(
        status: UserStatus.unauthenticated,
        errorMessage: 'Failed to get current user',
      );
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(status: UserStatus.loading);

    try {
      final params = SignInUserParams(email: email, password: password);
      final result = await ref.read(signInUserUseCaseProvider).call(params);

      state = result.fold(
        (failure) => state.copyWith(
          status: UserStatus.error,
          errorMessage: 'Authentication failed',
        ),
        (user) => state.copyWith(status: UserStatus.authenticated, user: user),
      );
    } catch (e) {
      state = state.copyWith(
        status: UserStatus.error,
        errorMessage: 'Authentication failed: ${e.toString()}',
      );
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    state = state.copyWith(status: UserStatus.loading);

    try {
      final params = SignUpUserParams(
        email: email,
        password: password,
        name: name,
      );
      final result = await ref.read(signUpUserUseCaseProvider).call(params);

      state = result.fold(
        (failure) => state.copyWith(
          status: UserStatus.error,
          errorMessage: 'Registration failed',
        ),
        (user) => state.copyWith(status: UserStatus.authenticated, user: user),
      );
    } catch (e) {
      state = state.copyWith(
        status: UserStatus.error,
        errorMessage: 'Registration failed: ${e.toString()}',
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: UserStatus.loading);

    try {
      final result = await ref.read(signInWithGoogleUseCaseProvider).call();

      state = result.fold(
        (failure) => state.copyWith(
          status: UserStatus.error,
          errorMessage: 'Google sign-in failed',
        ),
        (user) => state.copyWith(status: UserStatus.authenticated, user: user),
      );
    } catch (e) {
      state = state.copyWith(
        status: UserStatus.error,
        errorMessage: 'Google sign-in failed: ${e.toString()}',
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(status: UserStatus.loading);

    try {
      final result = await ref.read(signOutUserUseCaseProvider).call();

      state = result.fold(
        (failure) => state.copyWith(
          status: UserStatus.error,
          errorMessage: 'Sign out failed',
        ),
        (_) => state.copyWith(status: UserStatus.unauthenticated, user: null),
      );
    } catch (e) {
      state = state.copyWith(
        status: UserStatus.error,
        errorMessage: 'Sign out failed: ${e.toString()}',
      );
    }
  }
}
