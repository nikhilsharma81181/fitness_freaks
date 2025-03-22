import 'package:fitness_freaks/core/di/providers.dart';
import 'package:fitness_freaks/features/user/domain/repositories/user_repository.dart';
import 'package:fitness_freaks/features/user/domain/usecases/get_current_user.dart';
import 'package:fitness_freaks/features/user/domain/usecases/sign_out_user.dart';
import 'package:fitness_freaks/features/user/domain/usecases/sign_in_with_google.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'usecase_providers.g.dart';

// Use a StateProvider instead for the sync repository
final userRepositorySyncProvider = StateProvider<UserRepository?>(
  (ref) => null,
);

// Make sure this provider is properly watched and initialized
final initializeRepositoryProvider = Provider<void>((ref) {
  print("Initializing repository provider...");

  // Check if repository is already initialized
  final currentState = ref.read(userRepositorySyncProvider);
  if (currentState != null) {
    print("Repository already initialized");
    return;
  }

  // Initialize repository
  ref
      .watch(userRepositoryProvider.future)
      .then((repository) {
        print("Repository initialized successfully");
        ref.read(userRepositorySyncProvider.notifier).state = repository;
      })
      .catchError((e) {
        print("Error initializing repository: $e");
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
