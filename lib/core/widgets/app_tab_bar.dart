// File: lib/widgets/app_tab_bar.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom tab bar with SwiftUI style frosted glass effect
class AppTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const AppTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Single color for all tabs
    const Color activeColor = Color(0xFF4CD080);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
        child: Container(
          padding: const EdgeInsets.only(bottom: 27),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.15),
            border: const Border(
              top: BorderSide(
                color: Colors.white12,
                width: 0.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: activeColor.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: -5,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabItem(
                  index: 0,
                  icon: CupertinoIcons.house_fill,
                  label: 'Home',
                ),
                _buildTabItem(
                  index: 1,
                  icon: FontAwesomeIcons.dumbbell,
                  label: 'Fitness',
                ),
                _buildTabItem(
                  index: 2,
                  icon: CupertinoIcons.bubble_left_fill,
                  label: 'Chat',
                ),
                _buildTabItem(
                  index: 3,
                  icon: CupertinoIcons.leaf_arrow_circlepath,
                  label: 'Diet',
                ),
                _buildTabItem(
                  index: 4,
                  icon: CupertinoIcons.person_fill,
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = selectedIndex == index;
    const Color iconColor = Color(0xFF4CD080);

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? iconColor : Colors.white.withOpacity(0.5),
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? iconColor : Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
