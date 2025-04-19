import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fitness_freaks_flutter/features/auth/domain/entities/user_onboarding_data.dart';
import 'package:google_fonts/google_fonts.dart';

/// View for selecting workout preferences during onboarding
class WorkoutPreferencesView extends StatefulWidget {
  /// The onboarding data to update
  final UserOnboardingData onboardingData;

  /// Callback when data changes
  final VoidCallback onDataChanged;

  const WorkoutPreferencesView({
    Key? key,
    required this.onboardingData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<WorkoutPreferencesView> createState() => _WorkoutPreferencesViewState();
}

class _WorkoutPreferencesViewState extends State<WorkoutPreferencesView>
    with SingleTickerProviderStateMixin {
  // Animation state
  bool _appearAnimation = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Day names for the week
  final List<String> _weekdayNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

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
  void didUpdateWidget(WorkoutPreferencesView oldWidget) {
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
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Let's customize your workout plan based on your preferences.",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),

        // Main preference selectors - using bottom sheets for selection
        AnimatedOpacity(
          opacity: _appearAnimation ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _appearAnimation ? Offset.zero : const Offset(0, 0.2),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            child: Column(
              children: [
                // Frequency selector
                _buildPreferenceSelector(
                  icon: CupertinoIcons.calendar,
                  title: "Workout frequency",
                  value: _getWorkoutFrequencyText(
                      widget.onboardingData.workoutFrequency),
                  onTap: _showFrequencyPicker,
                ),

                const SizedBox(height: 12),

                // Location selector
                _buildPreferenceSelector(
                  icon: CupertinoIcons.location,
                  title: "Workout location",
                  value: _getWorkoutLocationText(
                      widget.onboardingData.workoutLocation),
                  onTap: _showLocationPicker,
                ),

                const SizedBox(height: 12),

                // Duration selector
                _buildPreferenceSelector(
                  icon: CupertinoIcons.time,
                  title: "Workout duration",
                  value: _getWorkoutDurationText(
                      widget.onboardingData.workoutDuration),
                  onTap: _showDurationPicker,
                ),

                const SizedBox(height: 12),

                // Equipment selector
                _buildPreferenceSelector(
                  icon: Icons.fitness_center,
                  title: "Equipment access",
                  value: _getEquipmentAvailabilityText(
                      widget.onboardingData.equipmentAvailability),
                  onTap: _showEquipmentPicker,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Preferred workout days section - always visible
        AnimatedOpacity(
          opacity: _appearAnimation ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _appearAnimation ? Offset.zero : const Offset(0, 0.2),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Preferred workout days",
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                _buildPreferredDaysSelector(),
              ],
            ),
          ),
        ),

        // Workout summary
        const SizedBox(height: 24),

        if (_appearAnimation)
          AnimatedOpacity(
            opacity: _appearAnimation ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            child: AnimatedSlide(
              offset: _appearAnimation ? Offset.zero : const Offset(0, 0.2),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              child: _buildWorkoutSummary(),
            ),
          ),
      ],
    );
  }

  // Build a preference selector card
  Widget _buildPreferenceSelector({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.vibrantTeal.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.vibrantTeal,
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
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.vibrantTeal,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // Show workout frequency picker
  void _showFrequencyPicker() {
    _showOptionPicker<WorkoutFrequency>(
      title: "Workout Frequency",
      options: WorkoutFrequency.values,
      selectedOption: widget.onboardingData.workoutFrequency,
      getOptionTitle: _getWorkoutFrequencyText,
      getOptionDescription: _getWorkoutFrequencyDescription,
      onSelect: (frequency) {
        setState(() {
          widget.onboardingData.workoutFrequency = frequency;
          widget.onDataChanged();
        });
      },
    );
  }

  // Show workout location picker
  void _showLocationPicker() {
    _showOptionPicker<WorkoutLocation>(
      title: "Workout Location",
      options: WorkoutLocation.values,
      selectedOption: widget.onboardingData.workoutLocation,
      getOptionTitle: _getWorkoutLocationText,
      getOptionDescription: _getWorkoutLocationDescription,
      onSelect: (location) {
        setState(() {
          widget.onboardingData.workoutLocation = location;
          widget.onDataChanged();
        });
      },
    );
  }

  // Show workout duration picker
  void _showDurationPicker() {
    _showOptionPicker<WorkoutDuration>(
      title: "Workout Duration",
      options: WorkoutDuration.values,
      selectedOption: widget.onboardingData.workoutDuration,
      getOptionTitle: _getWorkoutDurationText,
      getOptionDescription: _getWorkoutDurationDescription,
      onSelect: (duration) {
        setState(() {
          widget.onboardingData.workoutDuration = duration;
          widget.onDataChanged();
        });
      },
    );
  }

  // Show equipment availability picker
  void _showEquipmentPicker() {
    _showOptionPicker<EquipmentAvailability>(
      title: "Equipment Access",
      options: EquipmentAvailability.values,
      selectedOption: widget.onboardingData.equipmentAvailability,
      getOptionTitle: _getEquipmentAvailabilityText,
      getOptionDescription: _getEquipmentAvailabilityDescription,
      onSelect: (equipment) {
        setState(() {
          widget.onboardingData.equipmentAvailability = equipment;
          widget.onDataChanged();
        });
      },
    );
  }

  // Generic method to show option picker in bottom sheet
  void _showOptionPicker<T>({
    required String title,
    required List<T> options,
    required T selectedOption,
    required String Function(T) getOptionTitle,
    required String Function(T) getOptionDescription,
    required void Function(T) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              // Options list
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options.map((option) {
                      final isSelected = option == selectedOption;

                      return InkWell(
                        onTap: () {
                          onSelect(option);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getOptionTitle(option),
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      getOptionDescription(option),
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  margin: const EdgeInsets.only(left: 12),
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: AppColors.vibrantTeal,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Build workout summary card
  Widget _buildWorkoutSummary() {
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
              Row(
                children: [
                  Icon(
                    Icons.fitness_center,
                    color: AppColors.vibrantTeal,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Your Workout Plan",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _getWorkoutSummary(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Generate workout summary text
  String _getWorkoutSummary() {
    final frequency =
        _getWorkoutFrequencyText(widget.onboardingData.workoutFrequency);
    final location =
        _getWorkoutLocationText(widget.onboardingData.workoutLocation)
            .toLowerCase();
    final duration =
        _getWorkoutDurationText(widget.onboardingData.workoutDuration)
            .toLowerCase();

    // Format day names
    List<String> dayNames = [];
    for (int dayIndex in widget.onboardingData.preferredWorkoutDays) {
      dayNames.add(_weekdayNames[dayIndex]);
    }

    String days = dayNames.join(", ");

    return "You prefer to work out $frequency $location for $duration on $days.";
  }

  // Preferred workout days selector
  Widget _buildPreferredDaysSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 12,
        children: List.generate(7, (index) {
          final isSelected =
              widget.onboardingData.preferredWorkoutDays.contains(index);
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                if (isSelected) {
                  // Only allow deselection if we have at least one day selected
                  if (widget.onboardingData.preferredWorkoutDays.length > 1) {
                    widget.onboardingData.preferredWorkoutDays.remove(index);
                  }
                } else {
                  widget.onboardingData.preferredWorkoutDays.add(index);
                }
                widget.onDataChanged();
              });
            },
            child: AnimatedScale(
              scale: isSelected ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.vibrantTeal.withOpacity(0.3)
                      : Colors.white.withOpacity(0.08),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.vibrantTeal
                        : Colors.white.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    _weekdayNames[index],
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Helper methods for text display
  String _getWorkoutFrequencyText(WorkoutFrequency frequency) {
    switch (frequency) {
      case WorkoutFrequency.oneToTwo:
        return "1-2 times per week";
      case WorkoutFrequency.threeToFour:
        return "3-4 times per week";
      case WorkoutFrequency.fiveToSix:
        return "5-6 times per week";
      case WorkoutFrequency.daily:
        return "Daily";
    }
  }

  String _getWorkoutFrequencyDescription(WorkoutFrequency frequency) {
    switch (frequency) {
      case WorkoutFrequency.oneToTwo:
        return "Best for beginners or those with limited time";
      case WorkoutFrequency.threeToFour:
        return "Balanced approach for most fitness goals";
      case WorkoutFrequency.fiveToSix:
        return "Ideal for rapid progress and dedicated training";
      case WorkoutFrequency.daily:
        return "For advanced users with specific goals";
    }
  }

  String _getWorkoutLocationText(WorkoutLocation location) {
    switch (location) {
      case WorkoutLocation.home:
        return "At home";
      case WorkoutLocation.gym:
        return "At a gym";
      case WorkoutLocation.outdoors:
        return "Outdoors";
      case WorkoutLocation.mixed:
        return "Mixed/Varies";
    }
  }

  String _getWorkoutLocationDescription(WorkoutLocation location) {
    switch (location) {
      case WorkoutLocation.home:
        return "Workouts that require minimal equipment";
      case WorkoutLocation.gym:
        return "Access to a full range of equipment";
      case WorkoutLocation.outdoors:
        return "Exercises using body weight and natural environments";
      case WorkoutLocation.mixed:
        return "Adaptive workouts for various settings";
    }
  }

  String _getWorkoutDurationText(WorkoutDuration duration) {
    switch (duration) {
      case WorkoutDuration.lessThan30Min:
        return "Less than 30 minutes";
      case WorkoutDuration.thirtyToSixtyMin:
        return "30-60 minutes";
      case WorkoutDuration.sixtyToNinetyMin:
        return "60-90 minutes";
      case WorkoutDuration.moreThan90Min:
        return "More than 90 minutes";
    }
  }

  String _getWorkoutDurationDescription(WorkoutDuration duration) {
    switch (duration) {
      case WorkoutDuration.lessThan30Min:
        return "Quick, high-intensity sessions";
      case WorkoutDuration.thirtyToSixtyMin:
        return "Balanced workouts for most goals";
      case WorkoutDuration.sixtyToNinetyMin:
        return "Comprehensive sessions with warm-up and cool-down";
      case WorkoutDuration.moreThan90Min:
        return "Extended workouts for specific training goals";
    }
  }

  String _getEquipmentAvailabilityText(EquipmentAvailability equipment) {
    switch (equipment) {
      case EquipmentAvailability.none:
        return "No equipment (bodyweight only)";
      case EquipmentAvailability.minimal:
        return "Minimal equipment";
      case EquipmentAvailability.moderate:
        return "Moderate equipment";
      case EquipmentAvailability.full:
        return "Full gym access";
    }
  }

  String _getEquipmentAvailabilityDescription(EquipmentAvailability equipment) {
    switch (equipment) {
      case EquipmentAvailability.none:
        return "Exercises using only your body weight";
      case EquipmentAvailability.minimal:
        return "Basic items like resistance bands, a few dumbbells";
      case EquipmentAvailability.moderate:
        return "Dumbbells, kettlebells, pullup bar, bench";
      case EquipmentAvailability.full:
        return "Complete range of weights and machines";
    }
  }
}
