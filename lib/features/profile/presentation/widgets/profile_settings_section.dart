import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/features/profile/presentation/pages/profile_settings_page.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const ProfileSettingsPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: animation.drive(
                                Tween(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero)
                                    .chain(CurveTween(curve: Curves.easeInOut)),
                              ),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: CupertinoIcons.bell_fill,
                    title: 'Notifications',
                    subtitle: 'Manage your notifications',
                    color: const Color(0xFFFF9500),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // TODO: Implement notification toggle
                      },
                      activeColor: const Color(0xFFFF9500),
                    ),
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: CupertinoIcons.lock_fill,
                    title: 'Privacy & Security',
                    subtitle: 'Manage your privacy settings',
                    color: const Color(0xFF8059E6),
                    onTap: () {
                      // TODO: Navigate to privacy settings
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: CupertinoIcons.heart_fill,
                    title: 'Health Permissions',
                    subtitle: 'Manage health data access',
                    color: const Color(0xFFE65999),
                    onTap: () {
                      // TODO: Navigate to health permissions
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: CupertinoIcons.moon_stars_fill,
                    title: 'Dark Mode',
                    subtitle: 'App appearance settings',
                    color: const Color(0xFF00B3BF),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // TODO: Implement dark mode toggle
                      },
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
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
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
      ),
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
