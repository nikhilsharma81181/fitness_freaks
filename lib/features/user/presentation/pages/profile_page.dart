// File: lib/features/user/presentation/pages/profile_page.dart
import 'package:fitness_freaks/core/constant/colors/pallate.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/background_gradient.dart';
import 'package:fitness_freaks/features/user/presentation/pages/login_page.dart';
import 'package:fitness_freaks/features/user/presentation/pages/user_profile_provider.dart';
import 'package:fitness_freaks/features/user/presentation/providers/user_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userNotifierProvider);
    final isAuthenticated = userState.status == UserStatus.authenticated;

    // Debug prints
    print('ProfilePage build - isAuthenticated: $isAuthenticated');
    print('ProfilePage build - user: ${userState.user?.email}');
    print('ProfilePage build - status: ${userState.status}');

    return Stack(
      children: [
        // Background gradient
        const Positioned.fill(
          child: BackgroundGradient(tabType: TabType.profile),
        ),

        // Content
        SafeArea(
          bottom:
              false, // Important: don't include bottom safe area because of tab bar
          child:
              isAuthenticated
                  ? _buildAuthenticatedContent(context, ref)
                  : _buildUnauthenticatedContent(context),
        ),
      ],
    );
  }

  Widget _buildAuthenticatedContent(BuildContext context, WidgetRef ref) {
    // Watch the profile provider for server data
    final profileState = ref.watch(userProfileNotifierProvider);

    // Calculate bottom padding to account for tab bar
    final bottomPadding = MediaQuery.of(context).padding.bottom + 80;

    // Show loading indicator while fetching profile
    if (profileState.status == ProfileStatus.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CupertinoActivityIndicator(),
            const SizedBox(height: 20),
            Text(
              "Loading profile data...",
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ],
        ),
      );
    }

    // Show error if profile fetch failed
    if (profileState.status == ProfileStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.exclamationmark_circle,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 20),
            const Text(
              "Failed to load profile",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              profileState.errorMessage ?? "Unknown error",
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            RawMaterialButton(
              fillColor: Pallate.accentGreen,
              onPressed: () {
                // Retry profile fetch
                ref.read(userProfileNotifierProvider.notifier).refreshProfile();
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    // Get user data from the profile provider (server data)
    final userData = profileState.userData;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          // Profile header
          Row(
            children: [
              // Profile image - Use profile image URL if available
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Pallate.accentGreen, width: 2),
                  image:
                      userData?.profileImageUrl != null &&
                              userData!.profileImageUrl.isNotEmpty
                          ? DecorationImage(
                            image: NetworkImage(userData.profileImageUrl),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    userData?.profileImageUrl == null ||
                            userData!.profileImageUrl.isEmpty
                        ? const Center(
                          child: Icon(
                            CupertinoIcons.person_fill,
                            size: 40,
                            color: Pallate.accentGreen,
                          ),
                        )
                        : null,
              ),
              const SizedBox(width: 16),
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData?.name.isEmpty == true
                          ? 'User'
                          : userData?.name ?? 'User',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userData?.email ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (userData?.fitnessLevel != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.star_fill,
                            size: 14,
                            color: Pallate.accentGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Level ${userData!.fitnessLevel}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Settings/options
          _buildSettingsItem(
            icon: CupertinoIcons.person,
            title: 'Edit Profile',
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: CupertinoIcons.bell,
            title: 'Notifications',
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: CupertinoIcons.settings,
            title: 'Settings',
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: CupertinoIcons.question_circle,
            title: 'Help & Support',
            onTap: () {},
          ),

          // Use Expanded instead of Spacer to better control layout
          Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: _buildLogoutButton(ref),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      child: RawMaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          print('Logout button pressed');
          try {
            await ref.read(userNotifierProvider.notifier).signOut();
            print('Logout succeeded');
          } catch (e) {
            print('Logout failed: $e');
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnauthenticatedContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.person_fill,
            color: Pallate.profileGradient1,
            size: 64,
          ),
          const SizedBox(height: 24),
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Sign in to access your profile',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Pallate.accentGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: RawMaterialButton(
              fillColor: Pallate.accentGreen,
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Sign In or Create Account'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // Fix for mouse pointer issues
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const Spacer(),
              const Icon(
                CupertinoIcons.chevron_right,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
