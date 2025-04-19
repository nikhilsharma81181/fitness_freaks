import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fitness_freaks_flutter/features/auth/domain/entities/user_onboarding_data.dart';
import 'package:google_fonts/google_fonts.dart';

/// View for showing and confirming profile summary at the end of onboarding
class ProfileSummaryView extends StatefulWidget {
  /// The onboarding data to display
  final UserOnboardingData onboardingData;

  /// Callback when data changes
  final VoidCallback onDataChanged;

  /// Callback when the user wants to go back to a specific step
  final Function(OnboardingStep) onEditStep;

  const ProfileSummaryView({
    Key? key,
    required this.onboardingData,
    required this.onDataChanged,
    required this.onEditStep,
  }) : super(key: key);

  @override
  State<ProfileSummaryView> createState() => _ProfileSummaryViewState();
}

class _ProfileSummaryViewState extends State<ProfileSummaryView>
    with SingleTickerProviderStateMixin {
  // Animation state
  bool _appearAnimation = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    // Start appearance animation after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _appearAnimation = true;
        });
        _animationController.forward();
      }
    });
  }

  @override
  void didUpdateWidget(ProfileSummaryView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset animations if onboarding data changes
    if (oldWidget.onboardingData != widget.onboardingData) {
      _appearAnimation = false;
      _animationController.reset();

      setState(() {});

      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          setState(() {
            _appearAnimation = true;
          });
          _animationController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Introduction text
        AnimatedOpacity(
          opacity: _appearAnimation ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _appearAnimation ? Offset.zero : const Offset(0, 0.2),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                "Almost there! Review your profile information before completing setup.",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),

        // Profile summary sections with staggered animations
        ..._buildAnimatedSections(),

        // Bottom padding
        const SizedBox(height: 40),
      ],
    );
  }

  List<Widget> _buildAnimatedSections() {
    final List<Widget> sections = [];

    // List of sections with their corresponding information and edit step
    final sectionData = [
      {
        'title': 'Personal Information',
        'step': OnboardingStep.personalInfo,
        'icon': Icons.person,
        'widget': _buildPersonalInfoSection(),
      },
      {
        'title': 'Fitness Goals',
        'step': OnboardingStep.fitnessGoals,
        'icon': Icons.fitness_center,
        'widget': _buildFitnessGoalsSection(),
      },
      {
        'title': 'Experience Level',
        'step': OnboardingStep.experienceLevel,
        'icon': Icons.trending_up,
        'widget': _buildExperienceLevelSection(),
      },
      {
        'title': 'Workout Preferences',
        'step': OnboardingStep.workoutPreferences,
        'icon': Icons.schedule,
        'widget': _buildWorkoutPreferencesSection(),
      },
      {
        'title': 'Dietary Information',
        'step': OnboardingStep.dietaryInfo,
        'icon': Icons.restaurant_menu,
        'widget': _buildDietaryInfoSection(),
      },
    ];

    // Generate animated sections
    for (int i = 0; i < sectionData.length; i++) {
      final section = sectionData[i];
      final delay = 550 + (i * 100);

      sections.add(
        AnimatedOpacity(
          opacity: _appearAnimation ? 1.0 : 0.0,
          duration: Duration(milliseconds: delay),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _appearAnimation ? Offset.zero : const Offset(0, 0.2),
            duration: Duration(milliseconds: delay),
            curve: Curves.easeOut,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildSummaryCard(
                title: section['title'] as String,
                icon: section['icon'] as IconData,
                child: section['widget'] as Widget,
                onEdit: () {
                  HapticFeedback.mediumImpact();
                  widget.onEditStep(section['step'] as OnboardingStep);
                },
              ),
            ),
          ),
        ),
      );
    }

    return sections;
  }

  // Build a summary card with title, content, and edit button
  Widget _buildSummaryCard({
    required String title,
    required IconData icon,
    required Widget child,
    required VoidCallback onEdit,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and edit button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Icon and title
                  Row(
                    children: [
                      Icon(
                        icon,
                        color: AppColors.vibrantTeal,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Right: Edit button
                  GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.vibrantTeal.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: AppColors.vibrantTeal,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Edit",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.vibrantTeal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Content
              child,
            ],
          ),
        ),
      ),
    );
  }

  // Build personal info section
  Widget _buildPersonalInfoSection() {
    final isMetric = widget.onboardingData.units == MeasurementUnits.metric;
    final height = widget.onboardingData.height;
    final weight = widget.onboardingData.weight;

    String heightText = "Not specified";
    if (height != null) {
      if (isMetric) {
        heightText = "$height cm";
      } else {
        final feet = height ~/ 12;
        final inches = height % 12;
        heightText = "$feet'$inches\"";
      }
    }

    String weightText = "Not specified";
    if (weight != null) {
      if (isMetric) {
        weightText = "${weight.toStringAsFixed(1)} kg";
      } else {
        weightText = "${weight.toStringAsFixed(1)} lb";
      }
    }

    String bmiText = widget.onboardingData.bmi != null
        ? widget.onboardingData.bmi!.toStringAsFixed(1)
        : "N/A";

    // Build info rows
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
            "Age", "${widget.onboardingData.age ?? 'Not specified'} years"),
        _buildInfoRow("Gender", _getGenderName(widget.onboardingData.gender)),
        _buildInfoRow("Height", heightText),
        _buildInfoRow("Weight", weightText),
        _buildInfoRow("BMI", bmiText),
        _buildInfoRow("Units", isMetric ? "Metric" : "Imperial"),
      ],
    );
  }

  // Build fitness goals section
  Widget _buildFitnessGoalsSection() {
    if (widget.onboardingData.fitnessGoals.isEmpty) {
      return _buildInfoText("No fitness goals selected");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.onboardingData.fitnessGoals.map((goal) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 3, right: 8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.vibrantTeal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(goal.iconName),
                  color: AppColors.vibrantTeal,
                  size: 14,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      goal.description,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Build experience level section
  Widget _buildExperienceLevelSection() {
    final experience = widget.onboardingData.experienceLevel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              experience.name,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.vibrantTeal.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Level ${experience.level}",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.vibrantTeal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          experience.description,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  // Build workout preferences section
  Widget _buildWorkoutPreferencesSection() {
    // Frequency
    String frequencyText;
    switch (widget.onboardingData.workoutFrequency) {
      case WorkoutFrequency.oneToTwo:
        frequencyText = "1-2 times per week";
        break;
      case WorkoutFrequency.threeToFour:
        frequencyText = "3-4 times per week";
        break;
      case WorkoutFrequency.fiveToSix:
        frequencyText = "5-6 times per week";
        break;
      case WorkoutFrequency.daily:
        frequencyText = "Daily";
        break;
    }

    // Duration
    String durationText;
    switch (widget.onboardingData.workoutDuration) {
      case WorkoutDuration.lessThan30Min:
        durationText = "Less than 30 minutes";
        break;
      case WorkoutDuration.thirtyToSixtyMin:
        durationText = "30-60 minutes";
        break;
      case WorkoutDuration.sixtyToNinetyMin:
        durationText = "60-90 minutes";
        break;
      case WorkoutDuration.moreThan90Min:
        durationText = "More than 90 minutes";
        break;
    }

    // Location
    String locationText;
    switch (widget.onboardingData.workoutLocation) {
      case WorkoutLocation.home:
        locationText = "Home";
        break;
      case WorkoutLocation.gym:
        locationText = "Gym";
        break;
      case WorkoutLocation.outdoors:
        locationText = "Outdoors";
        break;
      case WorkoutLocation.mixed:
        locationText = "Mixed environments";
        break;
    }

    // Equipment
    String equipmentText;
    switch (widget.onboardingData.equipmentAvailability) {
      case EquipmentAvailability.none:
        equipmentText = "No equipment";
        break;
      case EquipmentAvailability.minimal:
        equipmentText = "Minimal equipment";
        break;
      case EquipmentAvailability.moderate:
        equipmentText = "Moderate equipment";
        break;
      case EquipmentAvailability.full:
        equipmentText = "Full gym equipment";
        break;
    }

    // Preferred days
    final List<String> daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    String preferredDays = widget.onboardingData.preferredWorkoutDays.isEmpty
        ? "No preferred days set"
        : widget.onboardingData.preferredWorkoutDays
            .map((day) => daysOfWeek[day])
            .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow("Frequency", frequencyText),
        _buildInfoRow("Duration", durationText),
        _buildInfoRow("Location", locationText),
        _buildInfoRow("Equipment", equipmentText),
        _buildInfoRow("Preferred Days", preferredDays),
      ],
    );
  }

  // Build dietary info section
  Widget _buildDietaryInfoSection() {
    // Diet type
    String dietTypeText = _getDietTypeText(widget.onboardingData.dietType);

    // Meal preference
    String mealPreferenceText =
        _getMealPreferenceText(widget.onboardingData.mealPreference);

    // Dietary restrictions
    String restrictionsText = widget.onboardingData.dietaryRestrictions.isEmpty
        ? "None"
        : widget.onboardingData.dietaryRestrictions
            .map((r) => r.name)
            .join(', ');

    // Nutrition targets
    String caloriesText = widget.onboardingData.dailyCalorieTarget != null
        ? "${widget.onboardingData.dailyCalorieTarget} calories/day"
        : "Not specified";

    String proteinText = widget.onboardingData.dailyProteinTarget != null
        ? "${widget.onboardingData.dailyProteinTarget}g protein/day"
        : "Not specified";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow("Diet Type", dietTypeText),
        _buildInfoRow("Meal Frequency", mealPreferenceText),
        _buildInfoRow("Restrictions", restrictionsText),
        _buildInfoRow("Calorie Target", caloriesText),
        _buildInfoRow("Protein Target", proteinText),
      ],
    );
  }

  // Helper method to build an information row with label and value
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to display placeholder text
  Widget _buildInfoText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        color: Colors.white.withOpacity(0.6),
        fontStyle: FontStyle.italic,
      ),
    );
  }

  // Helper method to get gender name
  String _getGenderName(Gender gender) {
    switch (gender) {
      case Gender.male:
        return "Male";
      case Gender.female:
        return "Female";
      case Gender.other:
        return "Other";
    }
  }

  // Helper method to get diet type text
  String _getDietTypeText(DietType dietType) {
    switch (dietType) {
      case DietType.standard:
        return "Standard";
      case DietType.vegetarian:
        return "Vegetarian";
      case DietType.vegan:
        return "Vegan";
      case DietType.pescatarian:
        return "Pescatarian";
      case DietType.ketogenic:
        return "Ketogenic";
      case DietType.paleo:
        return "Paleo";
    }
  }

  // Helper method to get meal preference text
  String _getMealPreferenceText(MealPreference mealPreference) {
    switch (mealPreference) {
      case MealPreference.twoToThree:
        return "2-3 meals per day";
      case MealPreference.threeToFive:
        return "3-5 meals per day";
      case MealPreference.fivePlus:
        return "5+ meals with snacks";
    }
  }

  // Helper method to map icon name to IconData
  IconData _getIconData(String name) {
    switch (name) {
      case 'scale':
        return Icons.monitor_weight;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'directions_run':
        return Icons.directions_run;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'spa':
        return Icons.spa;
      case 'favorite':
        return Icons.favorite;
      case 'no_meals':
        return Icons.no_meals;
      case 'no_drinks':
        return Icons.no_drinks;
      case 'dangerous':
        return Icons.dangerous;
      case 'restaurant':
        return Icons.restaurant;
      case 'cookie':
        return Icons.cookie;
      default:
        return Icons.circle;
    }
  }
}
