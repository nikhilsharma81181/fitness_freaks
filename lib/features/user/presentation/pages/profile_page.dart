import 'package:fitness_freaks/core/constant/colors/pallate.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/background_gradient.dart';
import 'package:fitness_freaks/features/user/domain/entities/user.dart';
import 'package:fitness_freaks/features/user/presentation/pages/login_page.dart';
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
    double width = MediaQuery.of(context).size.width;

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
          child:
              isAuthenticated
                  ? _buildAuthenticatedContent(context, ref, userState.user!)
                  : _buildUnauthenticatedContent(context),
        ),
      ],
    );
  }

  Widget _buildAuthenticatedContent(
    BuildContext context,
    WidgetRef ref,
    User user,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile header
          Row(
            children: [
              // Profile image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Pallate.accentGreen, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    CupertinoIcons.person_fill,
                    size: 40,
                    color: Pallate.accentGreen,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name.isEmpty ? 'User' : user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
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

          const Spacer(),

          // IMPORTANT: Logout button
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              print('Logout button pressed');
              await ref.read(userNotifierProvider.notifier).signOut();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.destructiveRed),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: CupertinoColors.destructiveRed,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Add bottom padding
        ],
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
          CupertinoButton(
            color: Pallate.accentGreen,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('Sign In or Create Account'),
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
    return GestureDetector(
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
    );
  }
}
