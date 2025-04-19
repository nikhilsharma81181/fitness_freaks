import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fitness_freaks_flutter/core/widgets/glass_card.dart';
import 'package:fitness_freaks_flutter/features/auth/domain/entities/user_onboarding_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/widgets/cupertino_style_picker.dart';
import 'package:flutter/cupertino.dart';

/// View for collecting personal information during onboarding
class PersonalInfoView extends StatefulWidget {
  /// The onboarding data to update
  final UserOnboardingData onboardingData;

  /// Callback when data changes
  final VoidCallback onDataChanged;

  const PersonalInfoView({
    Key? key,
    required this.onboardingData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView>
    with SingleTickerProviderStateMixin {
  // Animation controller for appearance animations
  late AnimationController _animationController;

  // Flag to track if animations have started
  bool _appearAnimation = false;

  // Temporary variables for picker selections
  int? _tempAge;
  double? _tempHeight;
  double? _tempWeight;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Start appearance animation after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _appearAnimation = true;
        });
      }
    });
  }

  @override
  void didUpdateWidget(PersonalInfoView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset animations if onboarding data changes
    if (oldWidget.onboardingData != widget.onboardingData) {
      _appearAnimation = false;
      setState(() {});

      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          setState(() {
            _appearAnimation = true;
          });
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
        // Description text
        AnimatedOpacity(
          opacity: _appearAnimation ? 1.0 : 0.2,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _appearAnimation ? Offset.zero : const Offset(0, 0.2),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Please provide your basic information to help us personalize your experience.",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),

        // Age selection
        _buildSectionWithDelay(
          title: "Age",
          delayFactor: 0,
          child: _buildAgeSelector(),
        ),

        const SizedBox(height: 26),

        // Gender selection
        _buildSectionWithDelay(
          title: "Gender",
          delayFactor: 1,
          child: _buildGenderSelector(),
        ),

        const SizedBox(height: 26),

        // Units selection
        _buildSectionWithDelay(
          title: "Units",
          delayFactor: 2,
          child: _buildUnitsSelector(),
        ),

        const SizedBox(height: 26),

        // Height and weight section
        _buildSectionWithDelay(
          title: "",
          delayFactor: 3,
          child: Column(
            children: [
              // Labels for height and weight
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Height",
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Weight",
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Height and weight selectors
              Row(
                children: [
                  Expanded(child: _buildHeightSelector()),
                  const SizedBox(width: 15),
                  Expanded(child: _buildWeightSelector()),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        // BMI display if available
        if (widget.onboardingData.bmi != null)
          _buildSectionWithDelay(
            title: "",
            delayFactor: 4,
            child: _buildBmiDisplay(),
          ),

        // Add bottom padding
        const SizedBox(height: 40),
      ],
    );
  }

  // Build a section with staggered delay animation
  Widget _buildSectionWithDelay({
    required String title,
    required int delayFactor,
    required Widget child,
  }) {
    // Calculate a safe delay factor that won't exceed bounds
    final double safeDelay = (delayFactor * 0.15).clamp(0.0, 0.85);

    return AnimatedOpacity(
      opacity: _appearAnimation ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      // Apply delay based on the position
      onEnd: delayFactor == 0 ? () => _animationController.forward() : null,
      child: AnimatedSlide(
        offset: _appearAnimation ? Offset.zero : const Offset(0, 0.2),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }

  // Age selector button
  Widget _buildAgeSelector() {
    return _buildAnimatedSelector(
      onTap: () => _showAgePicker(),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.calendar,
            color: Colors.white.withOpacity(0.6),
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            widget.onboardingData.age == null
                ? "-"
                : "${widget.onboardingData.age} years",
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Icon(
            CupertinoIcons.chevron_down,
            color: AppColors.vibrantTeal,
            size: 20,
          ),
        ],
      ),
    );
  }

  // Gender selector segment control
  Widget _buildGenderSelector() {
    return Row(
      children: Gender.values.map((gender) {
        final selected = widget.onboardingData.gender == gender;
        final iconInfo = _getGenderIconInfo(gender);

        return Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                widget.onboardingData.gender = gender;
                widget.onDataChanged();
              });
            },
            child: AnimatedScale(
              scale: selected ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected
                        ? Colors.white.withOpacity(0.4)
                        : Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconInfo.$1.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: Icon(
                          _getIconData(iconInfo.$1),
                          color: selected
                              ? iconInfo.$2.withOpacity(0.9)
                              : iconInfo.$2.withOpacity(0.6),
                          size: 16,
                        ),
                      ),
                    Text(
                      _getGenderName(gender),
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: selected
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Units selector segment control
  Widget _buildUnitsSelector() {
    return Row(
      children: MeasurementUnits.values.map((unit) {
        final selected = widget.onboardingData.units == unit;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              if (widget.onboardingData.units != unit) {
                HapticFeedback.lightImpact();
                setState(() {
                  if (unit == MeasurementUnits.metric) {
                    widget.onboardingData.convertToMetric();
                  } else {
                    widget.onboardingData.convertToImperial();
                  }
                  widget.onDataChanged();
                });
              }
            },
            child: AnimatedScale(
              scale: selected ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected
                        ? Colors.white.withOpacity(0.4)
                        : Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    unit == MeasurementUnits.metric ? "Metric" : "Imperial",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: selected
                          ? Colors.white
                          : Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Height selector button
  Widget _buildHeightSelector() {
    final unitLabel =
        widget.onboardingData.units == MeasurementUnits.metric ? "cm" : "in";

    return _buildAnimatedSelector(
      onTap: () => _showHeightPicker(),
      child: Row(
        children: [
          Text(
            widget.onboardingData.height == null
                ? "-"
                : _displayHeight(widget.onboardingData.height),
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Text(
            unitLabel,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            CupertinoIcons.chevron_down,
            color: AppColors.vibrantTeal,
            size: 20,
          ),
        ],
      ),
    );
  }

  // Weight selector button
  Widget _buildWeightSelector() {
    final unitLabel =
        widget.onboardingData.units == MeasurementUnits.metric ? "kg" : "lb";

    return _buildAnimatedSelector(
      onTap: () => _showWeightPicker(),
      child: Row(
        children: [
          Text(
            widget.onboardingData.weight == null
                ? "-"
                : _displayWeight(widget.onboardingData.weight),
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Text(
            unitLabel,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            CupertinoIcons.chevron_down,
            color: AppColors.vibrantTeal,
            size: 20,
          ),
        ],
      ),
    );
  }

  // BMI display widget
  Widget _buildBmiDisplay() {
    final bmi = widget.onboardingData.bmi!;
    final bmiCategory = _getBmiCategory(bmi);
    final bmiColor = _getBmiColor(bmi);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
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
            Row(
              children: [
                Icon(
                  CupertinoIcons.person_solid,
                  color: Colors.white.withOpacity(0.7),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "BMI: ${bmi.toStringAsFixed(1)}",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: bmiColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                bmiCategory,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: bmiColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Display formatted height
  String _displayHeight(double? height) {
    if (height == null) return "-";

    if (widget.onboardingData.units == MeasurementUnits.metric) {
      return height.toStringAsFixed(0);
    } else {
      final feet = height ~/ 12;
      final inches = (height % 12).toInt();
      return "$feet'$inches\"";
    }
  }

  // Display formatted weight
  String _displayWeight(double? weight) {
    if (weight == null) return "-";

    if (widget.onboardingData.units == MeasurementUnits.metric) {
      return weight.toStringAsFixed(1);
    } else {
      return weight.toStringAsFixed(0);
    }
  }

  // Show age picker
  void _showAgePicker() {
    _tempAge = widget.onboardingData.age ?? 25;

    PickerHelper.showAgePicker(
      context: context,
      initialAge: _tempAge ?? 25,
      onAgeChanged: (age) {
        _tempAge = age;
      },
      onDone: () {
        if (_tempAge != null) {
          setState(() {
            widget.onboardingData.age = _tempAge;
            widget.onDataChanged();
          });
        }
      },
    );
  }

  // Show height picker
  void _showHeightPicker() {
    _tempHeight = widget.onboardingData.height ??
        (widget.onboardingData.units == MeasurementUnits.metric ? 170.0 : 67.0);

    PickerHelper.showHeightPicker(
      context: context,
      initialHeight: _tempHeight ??
          (widget.onboardingData.units == MeasurementUnits.metric
              ? 170.0
              : 67.0),
      isMetric: widget.onboardingData.units == MeasurementUnits.metric,
      onHeightChanged: (height) {
        _tempHeight = height;
      },
      onDone: () {
        if (_tempHeight != null) {
          setState(() {
            widget.onboardingData.height = _tempHeight;
            widget.onDataChanged();
          });
        }
      },
    );
  }

  // Show weight picker
  void _showWeightPicker() {
    _tempWeight = widget.onboardingData.weight ??
        (widget.onboardingData.units == MeasurementUnits.metric ? 70.0 : 154.0);

    PickerHelper.showWeightPicker(
      context: context,
      initialWeight: _tempWeight ??
          (widget.onboardingData.units == MeasurementUnits.metric
              ? 70.0
              : 154.0),
      isMetric: widget.onboardingData.units == MeasurementUnits.metric,
      onWeightChanged: (weight) {
        _tempWeight = weight;
      },
      onDone: () {
        if (_tempWeight != null) {
          setState(() {
            widget.onboardingData.weight = _tempWeight;
            widget.onDataChanged();
          });
        }
      },
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

  // Helper method to get gender icon and color
  (String, Color) _getGenderIconInfo(Gender gender) {
    switch (gender) {
      case Gender.male:
        return ("male", const Color(0xFF64B5F6)); // Light blue
      case Gender.female:
        return ("female", const Color(0xFFF48FB1)); // Pink
      case Gender.other:
        return ("", Colors.white); // No icon for other
    }
  }

  // Helper method to map icon name to IconData
  IconData _getIconData(String name) {
    switch (name) {
      case "male":
        return Icons.male;
      case "female":
        return Icons.female;
      default:
        return Icons.person;
    }
  }

  // Get BMI category description
  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi < 25) {
      return "Healthy";
    } else if (bmi < 30) {
      return "Overweight";
    } else {
      return "Obese";
    }
  }

  // Get color for BMI category
  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.yellow.shade400;
    } else if (bmi < 25) {
      return const Color(0xFF33CD5B);
    } else if (bmi < 30) {
      return Colors.orange.shade400;
    } else {
      return Colors.red.shade400;
    }
  }

  // Helper function to create animated selectors with tap feedback
  Widget _buildAnimatedSelector({
    required VoidCallback onTap,
    required Widget child,
  }) {
    final scaleNotifier = ValueNotifier<double>(1.0);

    return ValueListenableBuilder<double>(
      valueListenable: scaleNotifier,
      builder: (context, scale, _) {
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: () {
              // Animate button press
              scaleNotifier.value = 0.97;
              HapticFeedback.selectionClick();

              Future.delayed(const Duration(milliseconds: 100), () {
                scaleNotifier.value = 1.0;
                onTap();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
