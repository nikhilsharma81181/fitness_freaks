import 'package:fitness_freaks/core/di/providers.dart';
import 'package:fitness_freaks/features/user/domain/repositories/user_repository.dart';
import 'package:fitness_freaks/features/user/domain/usecases/get_current_user.dart';
import 'package:fitness_freaks/features/user/domain/usecases/sign_in_user.dart';
import 'package:fitness_freaks/features/user/domain/usecases/sign_out_user.dart';
import 'package:fitness_freaks/features/user/domain/usecases/sign_up_user.dart';
import 'package:fitness_freaks/features/user/domain/usecases/sign_in_with_google.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'usecase_providers.g.dart';

// Use a StateProvider instead for the sync repository
final userRepositorySyncProvider = StateProvider<UserRepository?>(
  (ref) => null,
);

// Use a simple provider for initialization
final initializeRepositoryProvider = Provider<void>((ref) {
  ref.watch(userRepositoryProvider.future).then((repository) {
    ref.read(userRepositorySyncProvider.notifier).state = repository;
  });
});

@riverpod
GetCurrentUser getCurrentUserUseCase(GetCurrentUserUseCaseRef ref) {
  // Access the synchronized repository
  ref.watch(initializeRepositoryProvider);
  final repository = ref.watch(userRepositorySyncProvider);
  if (repository == null) {
    throw UnimplementedError('Repository not initialized');
  }
  return GetCurrentUser(repository);
}

@riverpod
SignInUser signInUserUseCase(SignInUserUseCaseRef ref) {
  ref.watch(initializeRepositoryProvider);
  final repository = ref.watch(userRepositorySyncProvider);
  if (repository == null) {
    throw UnimplementedError('Repository not initialized');
  }
  return SignInUser(repository);
}

@riverpod
SignUpUser signUpUserUseCase(SignUpUserUseCaseRef ref) {
  ref.watch(initializeRepositoryProvider);
  final repository = ref.watch(userRepositorySyncProvider);
  if (repository == null) {
    throw UnimplementedError('Repository not initialized');
  }
  return SignUpUser(repository);
}

@riverpod
SignOutUser signOutUserUseCase(SignOutUserUseCaseRef ref) {
  ref.watch(initializeRepositoryProvider);
  final repository = ref.watch(userRepositorySyncProvider);
  if (repository == null) {
    throw UnimplementedError('Repository not initialized');
  }
  return SignOutUser(repository);
}

@riverpod
SignInWithGoogle signInWithGoogleUseCase(SignInWithGoogleUseCaseRef ref) {
  ref.watch(initializeRepositoryProvider);
  final repository = ref.watch(userRepositorySyncProvider);
  if (repository == null) {
    throw UnimplementedError('Repository not initialized');
  }
  return SignInWithGoogle(repository);
}
