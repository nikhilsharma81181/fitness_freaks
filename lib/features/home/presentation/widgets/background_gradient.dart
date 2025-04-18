import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

// Tab types matching iOS implementation
enum TabType {
  home,
  fitness,
  chat,
  profile,
  personalInfo,
  fitnessGoals,
}

class BackgroundGradient extends StatelessWidget {
  final TabType forTab;

  const BackgroundGradient({
    super.key,
    this.forTab = TabType.home,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;

    // Configure colors based on tab type
    Color primaryColor;
    Color secondaryColor;
    double opacity = 0.5;
    double blurRadius = 40;

    switch (forTab) {
      case TabType.home:
        // Deep blue to blue-purple
        primaryColor = AppColors.homepageGradient1;
        secondaryColor = AppColors.homepageGradient2;
        break;
      case TabType.fitness:
        // Energetic green to teal
        primaryColor = AppColors.fitnessGradient1;
        secondaryColor = AppColors.fitnessGradient2;
        break;
      case TabType.chat:
        // Soft purple to warm pink
        primaryColor = AppColors.chatGradient1;
        secondaryColor = AppColors.chatGradient2;
        break;
      case TabType.profile:
        // Teal to blue-green
        primaryColor = AppColors.profileGradient1;
        secondaryColor = AppColors.profileGradient2;
        break;
      case TabType.personalInfo:
        // Calming blue to soft purple
        primaryColor = const Color(0xFF598CD9);
        secondaryColor = const Color(0xFF9966CC);
        opacity = 0.6;
        blurRadius = 35;
        break;
      case TabType.fitnessGoals:
        // Deep blue to vibrant teal
        primaryColor = const Color(0xFF1A66CC);
        secondaryColor = const Color(0xFF00B399);
        opacity = 0.65;
        blurRadius = 30;
        break;
    }

    return Stack(
      children: [
        // Pure black background
        Container(
          color: Colors.black,
          width: size.width,
          height: size.height,
        ),

        // Main gradient components
        Stack(
          children: [
            // Main radial gradient
            Positioned(
              // top: 0,
              // right: 0,
              top: 0,
              right: 50,
              child: Container(
                width: size.width,
                height: size.height * 0.5,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      primaryColor,
                      secondaryColor.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    center: Alignment.topRight,
                    radius: 1.2,
                  ),
                ),
                child: BackdropFilter(
                  filter:
                      ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

            // Secondary smaller highlight for "light source" effect
            Positioned(
              // top: 20,
              // right: 20,
              top: 20,
              right: 60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.4),
                      Colors.transparent,
                    ],
                    center: Alignment.center,
                    radius: 0.5,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

            // Additional tab-specific accents
            if (forTab == TabType.home)
              _buildHomeAccent(size, AppColors.homepageGradient2),
            if (forTab == TabType.fitness)
              _buildFitnessAccent(size, AppColors.fitnessGradient1),
            if (forTab == TabType.chat)
              _buildChatAccent(size, AppColors.chatGradient2),
            if (forTab == TabType.personalInfo) _buildPersonalInfoAccent(size),
            if (forTab == TabType.fitnessGoals) _buildFitnessGoalsAccent(size),
          ],
        ),

        // Subtle glass-like overlay
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.white.withOpacity(0.01),
            ),
          ),
        ),
      ],
    );
  }

  // Tab-specific accent gradients
  Widget _buildHomeAccent(Size size, Color accentColor) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        width: size.width,
        height: size.height * 0.3,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              accentColor.withOpacity(0.2),
              Colors.transparent,
            ],
            center: Alignment.bottomLeft,
            radius: 1.0,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildFitnessAccent(Size size, Color accentColor) {
    return Positioned(
      top: size.height * 0.3,
      left: size.width * 0.1,
      child: Container(
        width: size.width * 0.8,
        height: size.height * 0.3,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              accentColor.withOpacity(0.3),
              Colors.transparent,
            ],
            center: Alignment.center,
            radius: 1.0,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildChatAccent(Size size, Color accentColor) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: size.width,
        height: size.height * 0.4,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              accentColor.withOpacity(0.2),
              Colors.transparent,
            ],
            center: Alignment.bottomCenter,
            radius: 1.0,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoAccent(Size size) {
    return Stack(
      children: [
        Positioned(
          bottom: size.height * 0.1,
          left: 0,
          child: Container(
            width: size.width,
            height: size.height * 0.5,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8C73D9).withOpacity(0.25),
                  Colors.transparent,
                ],
                center: Alignment.bottomLeft,
                radius: 1.2,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.2,
          left: size.width * 0.1,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFitnessGoalsAccent(Size size) {
    return Stack(
      children: [
        Positioned(
          bottom: size.height * 0.1,
          right: 0,
          child: Container(
            width: size.width,
            height: size.height * 0.6,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF00B380).withOpacity(0.3),
                  Colors.transparent,
                ],
                center: Alignment.bottomRight,
                radius: 1.3,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.05,
          right: size.width * 0.2,
          child: Transform.rotate(
            angle: -0.26, // -15 degrees
            child: Container(
              width: 250,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
