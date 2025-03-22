import 'package:fitness_freaks/features/fitness/presentation/views/fitness_tab.dart';
import 'package:fitness_freaks/features/homepage/presentation/views/home_view.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/glass_tab_bar.dart';
import 'package:fitness_freaks/features/user/presentation/pages/profile_page.dart';
import 'package:fitness_freaks/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeView(),
    const FitnessTab(),
    const ChatTab(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Current tab content
          _tabs[_currentIndex],

          // Custom glass tab bar positioned at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlassTabBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.house_fill),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.heart_fill),
                  label: 'Fitness',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.bubble_left_fill),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_fill),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}