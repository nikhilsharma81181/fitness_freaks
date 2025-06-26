import 'package:flutter/material.dart';
import 'package:fitness_freaks_flutter/features/profile/presentation/widgets/profile_header.dart';
import 'package:fitness_freaks_flutter/features/profile/presentation/widgets/profile_stats_section.dart';
import 'package:fitness_freaks_flutter/features/profile/presentation/widgets/profile_quick_actions.dart';
import 'package:fitness_freaks_flutter/features/profile/presentation/widgets/profile_settings_section.dart';
import 'package:fitness_freaks_flutter/features/profile/presentation/widgets/profile_support_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),

              // Profile Header
              ProfileHeader(
                userName: 'Nikhil Sharma',
                membershipType: 'Premium Member',
                joinDate: 'Joined December 2024',
              ),

              SizedBox(height: 24),

              // Stats Cards
              ProfileStatsSection(),

              SizedBox(height: 24),

              // Quick Actions
              ProfileQuickActions(),

              SizedBox(height: 24),

              // Settings Section
              ProfileSettingsSection(),

              SizedBox(height: 24),

              // Support Section
              ProfileSupportSection(),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
