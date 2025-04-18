import 'package:flutter/material.dart';
import 'package:fitness_freaks/core/constants/colors.dart';
import 'package:fitness_freaks/features/user/domain/entities/user.dart';

/// Header widget for the profile page displaying user information and avatar
class ProfileHeader extends StatelessWidget {
  final UserEntity? user;
  final bool isLoading;
  final VoidCallback onProfilePicTap;
  
  const ProfileHeader({
    Key? key,
    required this.user,
    this.isLoading = false,
    required this.onProfilePicTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // Profile picture with edit button
          _buildProfilePicture(),
          
          const SizedBox(height: 16),
          
          // User name
          if (isLoading)
            _buildLoadingIndicator(width: 150, height: 24)
          else
            Text(
              user?.fullName ?? 'Add Your Name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          
          const SizedBox(height: 8),
          
          // Email
          if (isLoading)
            _buildLoadingIndicator(width: 180, height: 16)
          else
            Text(
              user?.email ?? 'example@email.com',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          
          const SizedBox(height: 20),
          
          // Membership info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accent1.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accent1.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.stars,
                  color: AppColors.accent1,
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Premium Member',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: onProfilePicTap,
      child: Stack(
        children: [
          // Avatar container
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[800],
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(55),
              child: isLoading
                  ? _buildLoadingIndicator(width: 110, height: 110)
                  : (user?.profilePhoto != null)
                      ? Image.network(
                          user!.profilePhoto!,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(),
                        )
                      : _buildAvatarPlaceholder(),
            ),
          ),
          
          // Edit button
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent1,
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAvatarPlaceholder() {
    return Center(
      child: Icon(
        Icons.person,
        size: 50,
        color: Colors.white.withOpacity(0.6),
      ),
    );
  }
  
  Widget _buildLoadingIndicator({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}
