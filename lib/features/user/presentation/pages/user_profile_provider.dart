import 'package:fitness_freaks/core/di/providers.dart';
import 'package:fitness_freaks/features/user/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_provider.g.dart';

enum ProfileStatus { loading, loaded, error }

class ProfileState {
  final ProfileStatus status;
  final UserModel? userData;
  final String? errorMessage;

  ProfileState({
    required this.status,
    this.userData,
    this.errorMessage,
  });

  factory ProfileState.initial() {
    return ProfileState(status: ProfileStatus.loading);
  }

  ProfileState copyWith({
    ProfileStatus? status,
    UserModel? userData,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  ProfileState build() {
    _fetchUserProfile();
    return ProfileState.initial();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final dataSource = await ref.read(userRemoteDataSourceProvider.future);
      
      state = ProfileState(status: ProfileStatus.loading);
      
      // Call the API to get user profile
      final userData = await dataSource.getCurrentUser();
      
      state = ProfileState(
        status: ProfileStatus.loaded,
        userData: userData,
      );
      
      print("UserProfile: Fetched profile data: ${userData.name}, ${userData.email}");
    } catch (e) {
      print("UserProfile: Error fetching profile: $e");
      state = ProfileState(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshProfile() async {
    await _fetchUserProfile();
  }
}