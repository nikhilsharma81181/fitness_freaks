import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/widgets/custom_glass_button.dart';

class ProfileSupportSection extends StatelessWidget {
  const ProfileSupportSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                  _buildSupportItem(
                    icon: CupertinoIcons.question_circle_fill,
                    title: 'Help & Support',
                    subtitle: 'Get help and contact support',
                    color: const Color(0xFF05E5B3),
                    onTap: () {
                      // TODO: Navigate to help & support
                    },
                  ),
                  _buildDivider(),
                  _buildSupportItem(
                    icon: CupertinoIcons.info_circle_fill,
                    title: 'About',
                    subtitle: 'App version and information',
                    color: const Color(0xFF00B3BF),
                    onTap: () {
                      // TODO: Navigate to about page
                    },
                  ),
                  _buildDivider(),
                  _buildSupportItem(
                    icon: CupertinoIcons.square_arrow_right_fill,
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    color: const Color(0xFFFF6B6B),
                    onTap: () {
                      // TODO: Implement logout functionality
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
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
            Icon(
              CupertinoIcons.chevron_right,
              color: Colors.white.withOpacity(0.5),
              size: 16,
            ),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              backgroundColor: Colors.black.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.0,
                ),
              ),
              title: Text(
                'Logout',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'Are you sure you want to logout?',
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: GlassButtonVariants.ghost(
                        text: 'Cancel',
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        accentColor: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassButtonVariants.danger(
                        text: 'Logout',
                        onTap: () {
                          Navigator.of(context).pop();
                          // TODO: Implement actual logout logic
                        },
                        icon: CupertinoIcons.square_arrow_right_fill,
                        accentColor: const Color(0xFFFF6B6B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
