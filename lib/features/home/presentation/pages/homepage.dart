import 'package:flutter/material.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/widgets/background_gradient.dart';
import 'package:fitness_freaks_flutter/core/widgets/app_tab_bar.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/pages/home_view.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/pages/chat_view.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/pages/fitness_view.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/pages/diet_view.dart';
import 'package:fitness_freaks_flutter/features/profile/presentation/pages/profile_page.dart';

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
        return const DietView();
      case 4:
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
        return TabType.diet;
      case 4:
        return TabType.profile;
      default:
        return TabType.home;
    }
  }
}
