import 'package:fitness_freaks/features/user/presentation/providers/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:isolate';

import '../../../../core/constants/colors.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../home/presentation/widgets/background_gradient.dart';
import '../../../user/presentation/providers/user_providers.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_stats_card.dart';

/// Profile page displaying user information and settings - Converted to StatefulWidget
class ProfilePage extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() =>
      _ProfilePageState(); // Create state
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with WidgetsBindingObserver {
  // State class with WidgetsBindingObserver

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Register observer
    // _fetchUserData(); // REMOVED: Fetch initial user data
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Unregister observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Fetch data again when app resumes
    // REMOVED for now - can be re-added if background refresh is desired
    // if (state == AppLifecycleState.resumed) {
    //   _fetchUserData();
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Watch user state
    final userState = ref.watch(userNotifierProvider);
    final user = userState.user;
    final isLoading = userState.status == UserStatus.loading;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          const BackgroundGradient(forTab: TabType.profile),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page header
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'My Profile',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Profile header with avatar
                    ProfileHeader(
                      user: user,
                      isLoading: isLoading,
                      onProfilePicTap: () =>
                          _showImagePickerOptions(context, ref),
                    ),

                    const SizedBox(height: 24),

                    // Stats card
                    const ProfileStatsCard(),

                    const SizedBox(height: 24),

                    // Settings section
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Menu items
                    Column(
                      children: [
                        ProfileMenuItem(
                          icon: Icons.person,
                          iconColor: AppColors.accent1,
                          title: 'Personal Information',
                          subtitle: 'Edit your personal details',
                          onTap: () {
                            // Navigate to personal info page
                          },
                        ),

                        const SizedBox(height: 12),

                        ProfileMenuItem(
                          icon: Icons.notifications,
                          iconColor: AppColors.accent2,
                          title: 'Notifications',
                          subtitle: 'Manage your app notifications',
                          trailing: Switch(
                            value: true,
                            onChanged: (_) {},
                            activeColor: AppColors.accent2,
                          ),
                          onTap: () {
                            // Toggle notifications
                          },
                        ),

                        const SizedBox(height: 12),

                        ProfileMenuItem(
                          icon: Icons.lock,
                          iconColor: AppColors.accent3,
                          title: 'Privacy & Security',
                          subtitle: 'Manage your data and security settings',
                          onTap: () {
                            // Navigate to privacy settings
                          },
                        ),

                        const SizedBox(height: 12),

                        ProfileMenuItem(
                          icon: Icons.help,
                          iconColor: Colors.blue,
                          title: 'Help & Support',
                          subtitle: 'Get assistance and FAQs',
                          onTap: () {
                            // Navigate to help page
                          },
                        ),

                        const SizedBox(height: 24),

                        // Logout button
                        ProfileMenuItem(
                          icon: Icons.logout,
                          iconColor: Colors.red,
                          title: 'Logout',
                          subtitle: 'Sign out from your account',
                          onTap: () {
                            _showLogoutConfirmation(context, ref);
                          },
                        ),
                      ],
                    ),

                    // Bottom space for tab bar
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Change Profile Photo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Camera option
                  _buildImagePickerOption(
                    context: context,
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    color: AppColors.accent1,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera, ref);
                    },
                  ),

                  // Gallery option
                  _buildImagePickerOption(
                    context: context,
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    color: AppColors.accent2,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery, ref);
                    },
                  ),

                  // Remove option
                  _buildImagePickerOption(
                    context: context,
                    icon: Icons.delete,
                    label: 'Remove',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      // Remove profile picture
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePickerOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color
                  .withOpacity(0.1), // Using withOpacity instead of withValues
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 90,
    );

    if (pickedFile != null) {
      // Show processing indicator
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Processing image...')));

      // Use compute to process image in a separate isolate
      try {
        final file = File(pickedFile.path);

        // Process image in background using compute
        await compute<File, File>(_processImageFile, file)
            .then((processedFile) {
          // Upload profile picture with processed file
          ref
              .read(userNotifierProvider.notifier)
              .uploadProfilePicture(processedFile);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error processing image: $e')));
      }
    }
  }

  // Static method to run in isolate
  static File _processImageFile(File input) {
    // This method runs in a separate isolate
    // Add image optimization logic here if needed
    // (e.g., further compression, resizing, etc.)
    return input;
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Logout
                ref.read(authNotifierProvider.notifier).signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
