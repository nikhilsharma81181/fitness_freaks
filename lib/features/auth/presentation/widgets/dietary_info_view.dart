import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fitness_freaks_flutter/features/auth/domain/entities/user_onboarding_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/widgets/cupertino_style_picker.dart';

/// View for selecting dietary preferences during onboarding
class DietaryInfoView extends StatefulWidget {
  /// The onboarding data to update
  final UserOnboardingData onboardingData;

  /// Callback when data changes
  final VoidCallback onDataChanged;

  const DietaryInfoView({
    Key? key,
    required this.onboardingData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<DietaryInfoView> createState() => _DietaryInfoViewState();
}

class _DietaryInfoViewState extends State<DietaryInfoView>
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
  void didUpdateWidget(DietaryInfoView oldWidget) {
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
                "Tell us about your diet to help tailor your fitness journey.",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),

        // Main preference selectors
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
                // Diet type selector
                _buildPreferenceSelector(
                  icon: Icons.restaurant_menu,
                  title: "Diet type",
                  value: _getDietTypeText(widget.onboardingData.dietType),
                  onTap: _showDietTypePicker,
                ),

                const SizedBox(height: 12),

                // Meal preference selector
                _buildPreferenceSelector(
                  icon: Icons.schedule,
                  title: "Meals per day",
                  value: _getMealPreferenceText(
                      widget.onboardingData.mealPreference),
                  onTap: _showMealPreferencePicker,
                ),

                const SizedBox(height: 12),

                // Dietary restrictions selector
                _buildPreferenceSelector(
                  icon: Icons.no_meals,
                  title: "Dietary restrictions",
                  value: _getRestrictionsText(),
                  onTap: _showDietaryRestrictionsPicker,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Nutrition targets section (optional)
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
                  child: Row(
                    children: [
                      Text(
                        "Nutrition targets",
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "(Optional)",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildNutritionalTargetsCard(),
              ],
            ),
          ),
        ),

        // Diet summary
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
              child: _buildDietSummary(),
            ),
          ),

        // Add padding at bottom
        const SizedBox(height: 20),
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

  // Build nutritional targets card
  Widget _buildNutritionalTargetsCard() {
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
                    Icons.lunch_dining,
                    color: AppColors.vibrantTeal,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Nutritional Targets",
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
                "Set your daily calorie and protein targets to help us provide better meal recommendations.",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Calorie target
                    Expanded(
                      child: GestureDetector(
                        onTap: _showCalorieTargetPicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                widget.onboardingData.dailyCalorieTarget
                                        ?.toString() ??
                                    "-",
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Calories/day",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Protein target
                    Expanded(
                      child: GestureDetector(
                        onTap: _showProteinTargetPicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                widget.onboardingData.dailyProteinTarget
                                        ?.toInt()
                                        .toString() ??
                                    "-",
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Protein (g/day)",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show calorie target picker
  void _showCalorieTargetPicker() {
    int tempCalories = widget.onboardingData.dailyCalorieTarget ?? 2000;

    PickerHelper.showCalorieTargetPicker(
      context: context,
      initialCalories: tempCalories,
      onCaloriesChanged: (calories) {
        tempCalories = calories;
      },
      onDone: () {
        setState(() {
          widget.onboardingData.dailyCalorieTarget = tempCalories;
          widget.onDataChanged();
        });
      },
    );
  }

  // Show protein target picker
  void _showProteinTargetPicker() {
    double tempProtein = widget.onboardingData.dailyProteinTarget ?? 150.0;

    PickerHelper.showProteinTargetPicker(
      context: context,
      initialProtein: tempProtein,
      onProteinChanged: (protein) {
        tempProtein = protein;
      },
      onDone: () {
        setState(() {
          widget.onboardingData.dailyProteinTarget = tempProtein;
          widget.onDataChanged();
        });
      },
    );
  }

  // Show diet type picker
  void _showDietTypePicker() {
    _showOptionPicker<DietType>(
      title: "Diet Type",
      options: DietType.values,
      selectedOption: widget.onboardingData.dietType,
      getOptionTitle: _getDietTypeText,
      getOptionDescription: _getDietTypeDescription,
      onSelect: (dietType) {
        setState(() {
          widget.onboardingData.dietType = dietType;
          widget.onDataChanged();
        });
      },
    );
  }

  // Show meal preference picker
  void _showMealPreferencePicker() {
    _showOptionPicker<MealPreference>(
      title: "Meals Per Day",
      options: MealPreference.values,
      selectedOption: widget.onboardingData.mealPreference,
      getOptionTitle: _getMealPreferenceText,
      getOptionDescription: _getMealPreferenceDescription,
      onSelect: (mealPreference) {
        setState(() {
          widget.onboardingData.mealPreference = mealPreference;
          widget.onDataChanged();
        });
      },
    );
  }

  // Show dietary restrictions picker
  void _showDietaryRestrictionsPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
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
                      "Dietary Restrictions",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Restrictions list
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: DietaryRestriction.allRestrictions
                            .map((restriction) {
                          final isSelected = widget
                              .onboardingData.dietaryRestrictions
                              .any((r) => r.id == restriction.id);

                          return InkWell(
                            onTap: () {
                              HapticFeedback.selectionClick();

                              // Toggle selection
                              if (isSelected) {
                                widget.onboardingData.dietaryRestrictions
                                    .removeWhere((r) => r.id == restriction.id);
                              } else {
                                widget.onboardingData.dietaryRestrictions
                                    .add(restriction);
                              }

                              // Update both modal state and parent state
                              setModalState(() {});
                              widget.onDataChanged();
                              setState(() {});
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
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.vibrantTeal
                                              .withOpacity(0.2)
                                          : Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      _getIconData(restriction.iconName),
                                      color: isSelected
                                          ? AppColors.vibrantTeal
                                          : Colors.white.withOpacity(0.7),
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          restriction.name,
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          restriction.description,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color:
                                                Colors.white.withOpacity(0.6),
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

                  // Done button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.vibrantTeal,
                              AppColors.vibrantTeal.withOpacity(0.8),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            "Done",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
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

  // Build diet summary card
  Widget _buildDietSummary() {
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
                    Icons.restaurant,
                    color: AppColors.vibrantTeal,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Your Diet Plan",
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
                _getDietSummary(),
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

  // Generate diet summary text
  String _getDietSummary() {
    final dietType = _getDietTypeText(widget.onboardingData.dietType);
    final mealPreference =
        _getMealPreferenceText(widget.onboardingData.mealPreference)
            .toLowerCase();

    String summary = "You follow a $dietType diet with $mealPreference.";

    if (widget.onboardingData.dietaryRestrictions.isNotEmpty) {
      String restrictionsText = widget.onboardingData.dietaryRestrictions
          .map((r) => r.name.toLowerCase())
          .join(', ');

      summary += " You avoid: $restrictionsText.";
    }

    if (widget.onboardingData.dailyCalorieTarget != null) {
      summary +=
          " Your target is ${widget.onboardingData.dailyCalorieTarget} calories";

      if (widget.onboardingData.dailyProteinTarget != null) {
        summary +=
            " with ${widget.onboardingData.dailyProteinTarget}g of protein per day.";
      } else {
        summary += " per day.";
      }
    } else if (widget.onboardingData.dailyProteinTarget != null) {
      summary +=
          " Your protein target is ${widget.onboardingData.dailyProteinTarget}g per day.";
    }

    return summary;
  }

  // Get formatted restrictions text
  String _getRestrictionsText() {
    if (widget.onboardingData.dietaryRestrictions.isEmpty) {
      return "None selected";
    }

    if (widget.onboardingData.dietaryRestrictions.length == 1) {
      return widget.onboardingData.dietaryRestrictions.first.name;
    }

    return "${widget.onboardingData.dietaryRestrictions.length} selected";
  }

  // Helper methods for text display
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

  String _getDietTypeDescription(DietType dietType) {
    switch (dietType) {
      case DietType.standard:
        return "Balanced diet including all food groups";
      case DietType.vegetarian:
        return "Plant-based diet excluding meat and fish";
      case DietType.vegan:
        return "Excludes all animal products including dairy and eggs";
      case DietType.pescatarian:
        return "Plant-based diet that includes fish but no other meats";
      case DietType.ketogenic:
        return "High-fat, low-carb diet to induce ketosis";
      case DietType.paleo:
        return "Based on foods available to our Paleolithic ancestors";
    }
  }

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

  String _getMealPreferenceDescription(MealPreference mealPreference) {
    switch (mealPreference) {
      case MealPreference.twoToThree:
        return "Fewer, larger meals throughout the day";
      case MealPreference.threeToFive:
        return "Moderate-sized meals evenly spaced out";
      case MealPreference.fivePlus:
        return "Frequent small meals and snacks for steady energy";
    }
  }

  // Helper method to map icon name to IconData
  IconData _getIconData(String name) {
    switch (name) {
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
        return Icons.not_interested;
    }
  }
}
