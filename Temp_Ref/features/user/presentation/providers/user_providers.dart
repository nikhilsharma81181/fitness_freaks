import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/network/api_providers.dart';
import '../../../../core/network/connection_checker.dart';
import '../../data/datasource/local/user_local_datasource.dart';
import '../../data/datasource/remote/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/create_user.dart';
import '../../domain/usecases/delete_user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/update_user.dart';
import '../../domain/usecases/upload_profile_picture.dart';
import 'user_notifier.dart';
import 'user_state.dart';

/// Provider for UserLocalDataSource
final userLocalDataSourceProvider = Provider<UserLocalDataSource>((ref) {
  return UserLocalDataSourceImpl();
});

/// Provider for UserRemoteDataSource
final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRemoteDataSourceImpl(apiClient);
});

/// Provider for UserRepository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    remoteDataSource: ref.watch(userRemoteDataSourceProvider),
    localDataSource: ref.watch(userLocalDataSourceProvider),
    connectionChecker: ref.watch(connectionCheckerProvider),
  );
});

/// Provider for CreateUser use case
final createUserProvider = Provider<CreateUser>((ref) {
  return CreateUser(ref.watch(userRepositoryProvider));
});

/// Provider for GetUser use case
final getUserProvider = Provider<GetUser>((ref) {
  return GetUser(ref.watch(userRepositoryProvider));
});

/// Provider for UpdateUser use case
final updateUserProvider = Provider<UpdateUser>((ref) {
  return UpdateUser(ref.watch(userRepositoryProvider));
});

/// Provider for UploadProfilePicture use case
final uploadProfilePictureProvider = Provider<UploadProfilePicture>((ref) {
  return UploadProfilePicture(ref.watch(userRepositoryProvider));
});

/// Provider for DeleteUser use case
final deleteUserProvider = Provider<DeleteUser>((ref) {
  return DeleteUser(ref.watch(userRepositoryProvider));
});

/// Provider for UserNotifier
final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(
    createUser: ref.watch(createUserProvider),
    getUser: ref.watch(getUserProvider),
    updateUser: ref.watch(updateUserProvider),
    uploadProfilePicture: ref.watch(uploadProfilePictureProvider),
    deleteUser: ref.watch(deleteUserProvider),
  );
});
