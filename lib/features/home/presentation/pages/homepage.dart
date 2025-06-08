import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/widgets/background_gradient.dart';
import 'package:fitness_freaks_flutter/core/widgets/app_tab_bar.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/pages/home_view.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/pages/chat_view.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/pages/fitness_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      extendBody: true,
      body: Stack(
        children: [
          // Background gradient
          BackgroundGradient(
            forTab: _getTabTypeFromIndex(_selectedIndex),
          ),

          // Display different content based on the selected tab
          _buildPageContent(),
        ],
      ),
      bottomNavigationBar: AppTabBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return const HomeView();
      case 1:
        return const FitnessView();
      case 2:
        return const ChatView();
      case 3:
        return const ProfilePage();
      default:
        return const HomeView();
    }
  }

  // Helper method to convert tab index to TabType
  TabType _getTabTypeFromIndex(int index) {
    switch (index) {
      case 0:
        return TabType.home;
      case 1:
        return TabType.fitness;
      case 2:
        return TabType.chat;
      case 3:
        return TabType.profile;
      default:
        return TabType.home;
    }
  }
}

// Placeholder profile page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Profile Header
              _buildProfileHeader(),

              const SizedBox(height: 24),

              // Stats Cards
              _buildStatsSection(),

              const SizedBox(height: 24),

              // Quick Actions
              _buildQuickActions(),

              const SizedBox(height: 24),

              // Settings Section
              _buildSettingsSection(),

              const SizedBox(height: 24),

              // App Info Section
              _buildAppInfoSection(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.0,
            ),
          ),
          child: Column(
            children: [
              // Profile Picture
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.profileGradient1.withOpacity(0.8),
                          AppColors.profileGradient2.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Center(
                          child: Icon(
                            CupertinoIcons.person_fill,
                            color: Colors.white.withOpacity(0.9),
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        CupertinoIcons.camera_fill,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // User Name
              Text(
                'Nikhil Sharma',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 4),

              // User Details
              Text(
                'Premium Member',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Joined December 2024',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: CupertinoIcons.flame_fill,
                value: '847',
                label: 'Total Workouts',
                color: const Color(0xFFFF9500),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: CupertinoIcons.clock_fill,
                value: '1.2k',
                label: 'Hours Trained',
                color: const Color(0xFF05E5B3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: CupertinoIcons.bolt_fill,
                value: '15',
                label: 'Current Streak',
                color: const Color(0xFF00B3BF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: CupertinoIcons.star_fill,
                value: '24',
                label: 'Achievements',
                color: const Color(0xFF8059E6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: CupertinoIcons.person_2_fill,
                label: 'Share Profile',
                color: const Color(0xFF05E5B3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: CupertinoIcons.doc_text_fill,
                label: 'View Reports',
                color: const Color(0xFF00B3BF),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  _buildSettingsItem(
                    icon: CupertinoIcons.person_fill,
                    title: 'Personal Information',
                    subtitle: 'Edit your profile details',
                    color: const Color(0xFF05E5B3),
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: CupertinoIcons.bell_fill,
                    title: 'Notifications',
                    subtitle: 'Manage your notifications',
                    color: const Color(0xFFFF9500),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: const Color(0xFFFF9500),
                    ),
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: CupertinoIcons.lock_fill,
                    title: 'Privacy & Security',
                    subtitle: 'Manage your privacy settings',
                    color: const Color(0xFF8059E6),
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: CupertinoIcons.heart_fill,
                    title: 'Health Permissions',
                    subtitle: 'Manage health data access',
                    color: const Color(0xFFE65999),
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: CupertinoIcons.moon_stars_fill,
                    title: 'Dark Mode',
                    subtitle: 'App appearance settings',
                    color: const Color(0xFF00B3BF),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: const Color(0xFF00B3BF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            trailing,
          ] else ...[
            Icon(
              CupertinoIcons.chevron_right,
              color: Colors.white.withOpacity(0.5),
              size: 16,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Support',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  _buildSettingsItem(
                    icon: CupertinoIcons.question_circle_fill,
                    title: 'Help & Support',
                    subtitle: 'Get help and contact support',
                    color: const Color(0xFF05E5B3),
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: CupertinoIcons.info_circle_fill,
                    title: 'About',
                    subtitle: 'App version and information',
                    color: const Color(0xFF00B3BF),
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: CupertinoIcons.square_arrow_right_fill,
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    color: const Color(0xFFFF6B6B),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 0.5,
      color: Colors.white.withOpacity(0.1),
    );
  }
}
