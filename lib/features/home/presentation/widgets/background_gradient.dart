import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

// Tab types matching iOS implementation
enum TabType {
  home,
  fitness,
  chat,
  diet,
  profile,
  personalInfo,
  fitnessGoals,
  experienceLevel,
  workoutPreferences,
  dietaryInfo,
  summary,
  workoutCreation,
  discoverWorkouts,
  aiWorkoutGeneration,
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
        // Subtle warm gradient - professional and clean
        // Muted orange-red for energy without being overwhelming
        primaryColor = const Color(0xFF2D1B69); // Deep purple-blue
        secondaryColor = const Color(0xFF8B5A3C); // Warm brown
        opacity = 0.4;
        blurRadius = 50;
        break;
      case TabType.chat:
        // Soft purple to warm pink
        primaryColor = AppColors.chatGradient1;
        secondaryColor = AppColors.chatGradient2;
        break;
      case TabType.diet:
        // Earth tones: green to warm yellow - symbolizes natural foods, health and wellbeing
        // Green psychologically represents health while yellow represents optimism
        // Perfect for dietary information
        primaryColor = const Color(0xFF4A6C2F);
        secondaryColor = const Color(0xFFB49A67);
        opacity = 0.6;
        blurRadius = 30;
        break;
      case TabType.profile:
        // Teal to blue-green
        primaryColor = AppColors.profileGradient1;
        secondaryColor = AppColors.profileGradient2;
        break;
      case TabType.personalInfo:
        // Calming blue to deep azure - symbolizes trust, reliability, and security
        // Blue is psychologically associated with stability and trustworthiness
        // Appropriate when asking for personal information
        primaryColor = const Color(0xFF0A2463);
        secondaryColor = const Color(0xFF1E5F9B);
        opacity = 0.6;
        blurRadius = 35;
        break;
      case TabType.fitnessGoals:
        // Energizing orange to purple - symbolizes motivation, ambition and vision
        // Orange psychologically represents enthusiasm and determination
        // Purple represents aspiration and achievement
        primaryColor = const Color(0xFF8C1BAB);
        secondaryColor = const Color(0xFFFF6B35);
        opacity = 0.65;
        blurRadius = 30;
        break;
      case TabType.experienceLevel:
        // Green to teal - symbolizes growth, progress and development
        // Green psychologically represents growth and learning
        // Perfect for assessing current experience levels
        primaryColor = const Color(0xFF2F6241);
        secondaryColor = const Color(0xFF00A878);
        opacity = 0.65;
        blurRadius = 40;
        break;
      case TabType.workoutPreferences:
        // Dynamic red to vibrant orange - symbolizes energy, activity and enthusiasm
        // Red psychologically represents energy and passion
        // Appropriate for workout related decisions
        primaryColor = const Color(0xFF9E1946);
        secondaryColor = const Color(0xFFFA7921);
        opacity = 0.55;
        blurRadius = 35;
        break;
      case TabType.dietaryInfo:
        // Earth tones: green to warm yellow - symbolizes natural foods, health and wellbeing
        // Green psychologically represents health while yellow represents optimism
        // Perfect for dietary information
        primaryColor = const Color(0xFF4A6C2F);
        secondaryColor = const Color(0xFFB49A67);
        opacity = 0.6;
        blurRadius = 30;
        break;
      case TabType.summary:
        // Professional blue to purple gradient - symbolizes completion, achievement and harmony
        // Blue-purple psychologically represents wisdom and accomplishment
        // Appropriate for final review of complete profile
        primaryColor = const Color(0xFF3A506B);
        secondaryColor = const Color(0xFF7161EF);
        opacity = 0.6;
        blurRadius = 35;
        break;
      case TabType.workoutCreation:
        // Energetic purple to teal gradient - symbolizes creativity and focus
        // Purple represents innovation while teal represents balance and focus
        // Perfect for creating new workouts
        primaryColor = const Color(0xFF6B46C1);
        secondaryColor = const Color(0xFF059669);
        opacity = 0.5;
        blurRadius = 40;
        break;
      case TabType.discoverWorkouts:
        // Vibrant blue to electric purple gradient - symbolizes discovery and exploration
        // Blue represents trust and reliability while purple represents innovation
        // Perfect for discovering new workouts from the community
        primaryColor = const Color(0xFF1E40AF);
        secondaryColor = const Color(0xFF7C3AED);
        opacity = 0.6;
        blurRadius = 45;
        break;
      case TabType.aiWorkoutGeneration:
        // AI-inspired gradient - deep purple to electric blue - symbolizes artificial intelligence and innovation
        // Deep purple represents intelligence and sophistication while electric blue represents technology and innovation
        // Perfect for AI-powered workout generation
        primaryColor = const Color(0xFF4C1D95);
        secondaryColor = const Color(0xFF1E40AF);
        opacity = 0.5;
        blurRadius = 45;
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
              _buildFitnessAccent(size, const Color(0xFFF39C12)),
            if (forTab == TabType.chat)
              _buildChatAccent(size, AppColors.chatGradient2),
            if (forTab == TabType.personalInfo) _buildPersonalInfoAccent(size),
            if (forTab == TabType.fitnessGoals) _buildFitnessGoalsAccent(size),
            if (forTab == TabType.experienceLevel)
              _buildExperienceLevelAccent(size),
            if (forTab == TabType.workoutPreferences)
              _buildWorkoutPreferencesAccent(size),
            if (forTab == TabType.dietaryInfo) _buildDietaryInfoAccent(size),
            if (forTab == TabType.summary) _buildSummaryAccent(size),
            if (forTab == TabType.workoutCreation)
              _buildWorkoutCreationAccent(size),
            if (forTab == TabType.discoverWorkouts)
              _buildDiscoverWorkoutsAccent(size),
            if (forTab == TabType.aiWorkoutGeneration)
              _buildAiWorkoutGenerationAccent(size),
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
    return Stack(
      children: [
        // Subtle bottom accent
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: size.width,
            height: size.height * 0.3,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF4A5568).withOpacity(0.12), // Subtle gray-blue
                  Colors.transparent,
                ],
                center: Alignment.bottomLeft,
                radius: 1.2,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),

        // Minimal top accent for subtle contrast
        Positioned(
          top: size.height * 0.15,
          right: size.width * 0.2,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.transparent,
                ],
                center: Alignment.center,
                radius: 0.8,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
      ],
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
                  const Color(0xFF274C77).withOpacity(0.25),
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
                  const Color(0xFFCE3B8C).withOpacity(0.3),
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

  // New accent for experience level
  Widget _buildExperienceLevelAccent(Size size) {
    return Stack(
      children: [
        Positioned(
          bottom: size.height * 0.3,
          left: size.width * 0.2,
          child: Container(
            width: size.width * 0.8,
            height: size.height * 0.4,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF2A9D8F).withOpacity(0.3),
                  Colors.transparent,
                ],
                center: Alignment.center,
                radius: 1.0,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        // Stepped levels visual element
        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.1,
          child: Container(
            width: 160,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }

  // New accent for workout preferences
  Widget _buildWorkoutPreferencesAccent(Size size) {
    return Stack(
      children: [
        Positioned(
          top: size.height * 0.1,
          right: 0,
          child: Container(
            width: size.width * 0.7,
            height: size.height * 0.3,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFE76F51).withOpacity(0.3),
                  Colors.transparent,
                ],
                center: Alignment.topRight,
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
          bottom: size.height * 0.15,
          left: size.width * 0.1,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFE9C46A).withOpacity(0.25),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }

  // New accent for dietary info
  Widget _buildDietaryInfoAccent(Size size) {
    return Stack(
      children: [
        Positioned(
          top: size.height * 0.2,
          left: size.width * 0.1,
          child: Container(
            width: size.width,
            height: size.height * 0.4,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF606C38).withOpacity(0.25),
                  Colors.transparent,
                ],
                center: Alignment.centerLeft,
                radius: 1.0,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        Positioned(
          bottom: size.height * 0.1,
          right: size.width * 0.2,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFDDA15E).withOpacity(0.2),
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

  // New accent for summary
  Widget _buildSummaryAccent(Size size) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: size.width,
            height: size.height * 0.6,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF4F5D75).withOpacity(0.3),
                  Colors.transparent,
                ],
                center: Alignment.topLeft,
                radius: this.forTab == TabType.summary ? 1.5 : 1.0,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        Positioned(
          bottom: size.height * 0.05,
          right: size.width * 0.05,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF847AF9).withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }

  // New accent for workout creation
  Widget _buildWorkoutCreationAccent(Size size) {
    return Stack(
      children: [
        Positioned(
          top: size.height * 0.1,
          left: size.width * 0.1,
          child: Container(
            width: size.width * 0.8,
            height: size.height * 0.4,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF10B981).withOpacity(0.3),
                  Colors.transparent,
                ],
                center: Alignment.centerLeft,
                radius: 1.2,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        Positioned(
          bottom: size.height * 0.2,
          right: size.width * 0.2,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8B5CF6).withOpacity(0.25),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }

  // New accent for discover workouts
  Widget _buildDiscoverWorkoutsAccent(Size size) {
    return Stack(
      children: [
        Positioned(
          top: size.height * 0.05,
          right: size.width * 0.05,
          child: Container(
            width: size.width * 0.9,
            height: size.height * 0.5,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.35),
                  Colors.transparent,
                ],
                center: Alignment.topRight,
                radius: 1.3,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        Positioned(
          bottom: size.height * 0.15,
          left: size.width * 0.15,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8B5CF6).withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        // Additional discovery-themed accent
        Positioned(
          top: size.height * 0.3,
          left: size.width * 0.05,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
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

  // New accent for AI workout generation
  Widget _buildAiWorkoutGenerationAccent(Size size) {
    return Stack(
      children: [
        // Main AI-themed gradient
        Positioned(
          top: size.height * 0.1,
          left: size.width * 0.1,
          child: Container(
            width: size.width * 0.8,
            height: size.height * 0.6,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF10B981).withOpacity(0.4),
                  Colors.transparent,
                ],
                center: Alignment.centerLeft,
                radius: 1.4,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        // Tech-inspired accent
        Positioned(
          top: size.height * 0.05,
          right: size.width * 0.1,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF0EA5E9).withOpacity(0.35),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        // Neural network-inspired geometric accent
        Positioned(
          bottom: size.height * 0.2,
          right: size.width * 0.05,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.12),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        // Additional AI sparkle effect
        Positioned(
          bottom: size.height * 0.1,
          left: size.width * 0.2,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF34D399).withOpacity(0.2),
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
}
