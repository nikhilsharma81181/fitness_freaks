import 'package:flutter/material.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';

/// Types of tabs/screens for gradient selection
enum TabType {
  home,
  sleep,
  activity,
  profile,
  login,
  // Added onboarding specific tabs
  personalInfo,
  fitnessGoals,
  experienceLevel,
  workoutPreferences,
  dietaryInfo,
  summary,
}

/// Background gradient widget that adapts based on tab/screen type
class BackgroundGradientView extends StatelessWidget {
  final TabType forTab;

  const BackgroundGradientView({
    Key? key,
    required this.forTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: _getGradientBegin(),
          end: _getGradientEnd(),
          colors: _getGradientColors(),
          stops: _getGradientStops(),
        ),
      ),
    );
  }

  /// Get the gradient begin alignment based on tab type
  Alignment _getGradientBegin() {
    switch (forTab) {
      case TabType.login:
        return Alignment.topLeft;
      case TabType.personalInfo:
      case TabType.fitnessGoals:
      case TabType.experienceLevel:
      case TabType.workoutPreferences:
      case TabType.dietaryInfo:
      case TabType.summary:
        return Alignment.topLeft;
      default:
        return Alignment.topCenter;
    }
  }

  /// Get the gradient end alignment based on tab type
  Alignment _getGradientEnd() {
    switch (forTab) {
      case TabType.login:
        return Alignment.bottomRight;
      case TabType.personalInfo:
      case TabType.fitnessGoals:
      case TabType.experienceLevel:
      case TabType.workoutPreferences:
      case TabType.dietaryInfo:
      case TabType.summary:
        return Alignment.bottomRight;
      default:
        return Alignment.bottomCenter;
    }
  }

  /// Get gradient colors based on tab type
  List<Color> _getGradientColors() {
    switch (forTab) {
      case TabType.home:
        return [
          AppColors.homepageGradient1,
          AppColors.homepageGradient2,
          AppColors.darkBackground,
        ];
      case TabType.sleep:
        return AppColors.sleepGradient + [AppColors.darkBackground];
      case TabType.activity:
        return AppColors.movementGradient + [AppColors.darkBackground];
      case TabType.profile:
        return [
          AppColors.profileGradient1,
          AppColors.profileGradient2,
          AppColors.darkBackground,
        ];
      case TabType.login:
        return [
          AppColors.darkBackground,
          AppColors.sleepGradient[0].withOpacity(0.85),
          AppColors.sleepGradient[1].withOpacity(0.7),
        ];
      case TabType.personalInfo:
        return [
          Color(0xFF002538), // Deep teal base
          Color(0xFF003B54), // Mid teal
          AppColors.darkBackground,
        ];
      case TabType.fitnessGoals:
        return [
          Color(0xFF004844), // Forest green base
          Color(0xFF006650), // Bright forest
          AppColors.darkBackground,
        ];
      case TabType.experienceLevel:
        return [
          Color(0xFF200030), // Deep purple
          Color(0xFF3A0050), // Brighter purple
          AppColors.darkBackground,
        ];
      case TabType.workoutPreferences:
        return [
          Color(0xFF002E4B), // Navy blue
          Color(0xFF004370), // Brighter navy
          AppColors.darkBackground,
        ];
      case TabType.dietaryInfo:
        return [
          Color(0xFF2D1900), // Warm amber
          Color(0xFF462C00), // Brighter amber
          AppColors.darkBackground,
        ];
      case TabType.summary:
        return [
          AppColors.profileGradient1,
          AppColors.profileGradient2,
          AppColors.darkBackground,
        ];
      default:
        return [
          AppColors.darkBackground,
          AppColors.darkBackground.withOpacity(0.8),
        ];
    }
  }

  /// Get gradient stops based on tab type
  List<double> _getGradientStops() {
    switch (forTab) {
      case TabType.login:
        return [0.0, 0.5, 1.0];
      case TabType.personalInfo:
      case TabType.fitnessGoals:
      case TabType.experienceLevel:
      case TabType.workoutPreferences:
      case TabType.dietaryInfo:
      case TabType.summary:
        return [0.0, 0.4, 1.0];
      default:
        return [0.0, 0.3, 1.0];
    }
  }
}
