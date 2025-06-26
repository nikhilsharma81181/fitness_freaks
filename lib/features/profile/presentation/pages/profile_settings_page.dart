import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fitness_freaks_flutter/core/widgets/custom_glass_button.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/widgets/background_gradient.dart';
import 'package:fitness_freaks_flutter/features/profile/presentation/widgets/profile_form_field.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _nameController = TextEditingController(text: 'Nikhil Sharma');
  final _emailController =
      TextEditingController(text: 'nikhil@fitnessfreaks.com');
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  final _bioController = TextEditingController(
      text:
          'Fitness enthusiast and wellness coach helping others achieve their health goals.');

  // Settings states
  bool _notificationsEnabled = true;
  bool _publicProfile = false;
  bool _activityTracking = true;
  bool _dataSharing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background gradient
          const BackgroundGradient(forTab: TabType.profile),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Header
                      _buildHeader(),

                      const SizedBox(height: 24),

                      // Personal Information Section
                      _buildPersonalInfoSection(),

                      const SizedBox(height: 24),

                      // Account Preferences Section
                      _buildAccountPreferencesSection(),

                      const SizedBox(height: 24),

                      // Privacy Settings Section
                      _buildPrivacySettingsSection(),

                      const SizedBox(height: 32),

                      // Save Button
                      _buildSaveButton(),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  CupertinoIcons.chevron_left,
                  color: Colors.white.withOpacity(0.9),
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            'Profile Settings',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ProfileFormField(
                label: 'Full Name',
                controller: _nameController,
                icon: CupertinoIcons.person_fill,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ProfileFormField(
                label: 'Email Address',
                controller: _emailController,
                icon: CupertinoIcons.envelope_fill,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ProfileFormField(
                label: 'Phone Number',
                controller: _phoneController,
                icon: CupertinoIcons.phone_fill,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ProfileFormField(
                label: 'Bio',
                controller: _bioController,
                icon: CupertinoIcons.doc_text_fill,
                maxLines: 3,
                isOptional: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountPreferencesSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account Preferences',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildPreferenceToggle(
                icon: CupertinoIcons.bell_fill,
                title: 'Push Notifications',
                subtitle: 'Receive workout reminders and updates',
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                color: const Color(0xFFFF9500),
              ),
              const SizedBox(height: 16),
              _buildPreferenceToggle(
                icon: CupertinoIcons.chart_bar_fill,
                title: 'Activity Tracking',
                subtitle: 'Allow automatic workout and health tracking',
                value: _activityTracking,
                onChanged: (value) {
                  setState(() {
                    _activityTracking = value;
                  });
                },
                color: const Color(0xFF05E5B3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacySettingsSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Settings',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildPreferenceToggle(
                icon: CupertinoIcons.eye_fill,
                title: 'Public Profile',
                subtitle: 'Allow others to discover your profile',
                value: _publicProfile,
                onChanged: (value) {
                  setState(() {
                    _publicProfile = value;
                  });
                },
                color: const Color(0xFF8059E6),
              ),
              const SizedBox(height: 16),
              _buildPreferenceToggle(
                icon: CupertinoIcons.square_arrow_up_fill,
                title: 'Data Sharing',
                subtitle: 'Share anonymized data for app improvement',
                value: _dataSharing,
                onChanged: (value) {
                  setState(() {
                    _dataSharing = value;
                  });
                },
                color: const Color(0xFF00B3BF),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferenceToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
  }) {
    return Row(
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
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryColor,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return CustomGlassButton(
      text: 'Save Changes',
      onTap: _saveSettings,
      icon: CupertinoIcons.checkmark_circle_fill,
      accentColor: AppColors.primaryColor.withOpacity(1.0),
    );
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement actual save functionality
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Settings saved successfully!',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: AppColors.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
