import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fitness_freaks_flutter/features/auth/domain/entities/user_onboarding_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

/// View for selecting fitness goals during onboarding
class FitnessGoalsView extends StatefulWidget {
  /// The onboarding data to update
  final UserOnboardingData onboardingData;

  /// Callback when data changes
  final VoidCallback onDataChanged;

  const FitnessGoalsView({
    Key? key,
    required this.onboardingData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<FitnessGoalsView> createState() => _FitnessGoalsViewState();
}

class _FitnessGoalsViewState extends State<FitnessGoalsView>
    with SingleTickerProviderStateMixin {
  // Animation state
  bool _appearAnimation = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Keep track of the primary goal
  FitnessGoal? _primaryGoal;

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

    // Set primary goal if we already have goals selected
    if (widget.onboardingData.fitnessGoals.isNotEmpty) {
      _primaryGoal = widget.onboardingData.fitnessGoals.first;
    }

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
  void didUpdateWidget(FitnessGoalsView oldWidget) {
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
        // Gentle intro text
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
                "What brings you here? Select a primary goal and add others that interest you.",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),

        // Primary goal selector
        AnimatedOpacity(
          opacity: _appearAnimation ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _appearAnimation ? Offset.zero : const Offset(0, 0.2),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Main Goal",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                _buildPrimaryGoalSelector(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Secondary goals title
        AnimatedOpacity(
          opacity: _appearAnimation ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _appearAnimation ? Offset.zero : const Offset(0, 0.2),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
            child: Row(
              children: [
                Text(
                  "Additional Goals",
                  style: GoogleFonts.inter(
                    fontSize: 18,
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
                const Spacer(),
                Text(
                  "Select up to 3",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.vibrantTeal,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Secondary goals list
        SizedBox(
          height: 120,
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: FitnessGoal.allGoals.length,
                itemBuilder: (context, index) {
                  final goal = FitnessGoal.allGoals[index];

                  // Skip goal if it's the primary goal
                  if (goal == _primaryGoal) {
                    return const SizedBox.shrink();
                  }

                  // Calculate if this goal is selected as secondary
                  final isSelected =
                      widget.onboardingData.fitnessGoals.contains(goal) &&
                          goal != _primaryGoal;

                  // Calculate staggered animation delay - ensure values stay within [0,1]
                  final safeStartInterval =
                      (0.1 + (index * 0.1)).clamp(0.0, 0.9);
                  final safeEndInterval =
                      (safeStartInterval + 0.2).clamp(0.0, 1.0);

                  final delayedAnimation = Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: _fadeAnimation,
                      curve: Interval(
                        safeStartInterval,
                        safeEndInterval,
                        curve: Curves.easeOut,
                      ),
                    ),
                  );

                  return Opacity(
                    opacity: delayedAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - delayedAnimation.value)),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : 12,
                          right:
                              index == FitnessGoal.allGoals.length - 1 ? 0 : 0,
                        ),
                        child: SecondaryGoalCard(
                          goal: goal,
                          isSelected: isSelected,
                          onTap: () => _toggleSecondaryGoal(goal),
                          disabled:
                              !isSelected && _getSecondaryGoalsCount() >= 3,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Selected goals summary
        if (_appearAnimation && widget.onboardingData.fitnessGoals.isNotEmpty)
          AnimatedOpacity(
            opacity: _appearAnimation ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: ClipRRect(
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
                              "Your Fitness Journey",
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
                          _getGoalsSummary(),
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
              ),
            ),
          ),

        // Add bottom padding
        const SizedBox(height: 40),
      ],
    );
  }

  // Primary goal selector dropdown
  Widget _buildPrimaryGoalSelector() {
    return GestureDetector(
      onTap: () => _showPrimaryGoalPicker(),
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
            if (_primaryGoal != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.vibrantTeal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconData(_primaryGoal!.iconName),
                  color: AppColors.vibrantTeal,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
            ] else
              Icon(
                Icons.fitness_center,
                color: Colors.white.withOpacity(0.6),
                size: 20,
              ),
            SizedBox(width: 10),
            Text(
              _primaryGoal?.name ?? "Select primary goal",
              style: GoogleFonts.inter(
                fontSize: 16,
                color: _primaryGoal != null
                    ? Colors.white
                    : Colors.white.withOpacity(0.6),
              ),
            ),
            const Spacer(),
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

  // Show primary goal picker
  void _showPrimaryGoalPicker() {
    HapticFeedback.mediumImpact();

    // Show bottom sheet with goal options
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
                  "Select Primary Goal",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              // Goals list
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: FitnessGoal.allGoals.map((goal) {
                      final isSelected = goal == _primaryGoal;

                      return InkWell(
                        onTap: () {
                          _setPrimaryGoal(goal);
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
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.vibrantTeal.withOpacity(0.2)
                                      : Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _getIconData(goal.iconName),
                                  color: isSelected
                                      ? AppColors.vibrantTeal
                                      : Colors.white.withOpacity(0.7),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      goal.name,
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      goal.description,
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

  // Set primary goal
  void _setPrimaryGoal(FitnessGoal goal) {
    HapticFeedback.mediumImpact();

    setState(() {
      // Remove this goal if it was already in secondary goals
      widget.onboardingData.fitnessGoals.removeWhere((g) => g.id == goal.id);

      // If we had a previous primary goal, add it to secondary goals
      if (_primaryGoal != null &&
          !widget.onboardingData.fitnessGoals.contains(_primaryGoal) &&
          _getSecondaryGoalsCount() < 3) {
        widget.onboardingData.fitnessGoals.add(_primaryGoal!);
      }

      // Set new primary goal
      _primaryGoal = goal;

      // Add to beginning of list
      widget.onboardingData.fitnessGoals.insert(0, goal);

      widget.onDataChanged();
    });
  }

  // Toggle secondary goal selection
  void _toggleSecondaryGoal(FitnessGoal goal) {
    HapticFeedback.selectionClick();

    setState(() {
      if (widget.onboardingData.fitnessGoals.contains(goal)) {
        // Remove goal
        widget.onboardingData.fitnessGoals.removeWhere((g) => g.id == goal.id);
      } else {
        // Only add if we have less than 3 secondary goals
        if (_getSecondaryGoalsCount() < 3) {
          // Add goal
          widget.onboardingData.fitnessGoals.add(goal);
        }
      }

      widget.onDataChanged();
    });
  }

  // Get number of secondary goals
  int _getSecondaryGoalsCount() {
    return widget.onboardingData.fitnessGoals
        .where((g) => g != _primaryGoal)
        .length;
  }

  // Get goals summary text
  String _getGoalsSummary() {
    if (widget.onboardingData.fitnessGoals.isEmpty) {
      return "No goals selected yet.";
    }

    if (_primaryGoal == null) {
      return "Please select a primary goal.";
    }

    final secondaryGoals = widget.onboardingData.fitnessGoals
        .where((goal) => goal != _primaryGoal)
        .toList();

    if (secondaryGoals.isEmpty) {
      return "Focus on ${_primaryGoal!.name.toLowerCase()}.";
    }

    final secondaryGoalsText = secondaryGoals
        .map((goal) => goal.name.toLowerCase())
        .join(secondaryGoals.length > 1 ? ", " : " and ");

    return "Focus on ${_primaryGoal!.name.toLowerCase()} while also working on $secondaryGoalsText.";
  }

  // Helper method to map icon name to IconData
  IconData _getIconData(String name) {
    switch (name) {
      case 'scale':
        return Icons.monitor_weight_outlined;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'directions_run':
        return Icons.directions_run;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'spa':
        return Icons.spa;
      case 'favorite':
        return Icons.favorite_border;
      default:
        return Icons.category;
    }
  }
}

/// Card widget for a secondary fitness goal
class SecondaryGoalCard extends StatefulWidget {
  /// The fitness goal to display
  final FitnessGoal goal;

  /// Whether this goal is selected
  final bool isSelected;

  /// Whether selection is disabled
  final bool disabled;

  /// Callback when the card is tapped
  final VoidCallback onTap;

  const SecondaryGoalCard({
    Key? key,
    required this.goal,
    required this.isSelected,
    required this.onTap,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<SecondaryGoalCard> createState() => _SecondaryGoalCardState();
}

class _SecondaryGoalCardState extends State<SecondaryGoalCard>
    with SingleTickerProviderStateMixin {
  // Visual effects state
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.disabled
          ? null
          : () {
              _animationController.forward().then((_) {
                _animationController.reverse();
              });
              widget.onTap();
            },
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: widget.disabled && !widget.isSelected ? 0.5 : 1.0,
              child: Container(
                width: 120,
                height: 115,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? AppColors.vibrantTeal.withOpacity(0.15)
                      : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.isSelected
                        ? AppColors.vibrantTeal.withOpacity(0.5)
                        : Colors.white.withOpacity(0.15),
                    width: widget.isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isSelected
                            ? AppColors.vibrantTeal.withOpacity(0.2)
                            : Colors.white.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Icon(
                          _getIconData(widget.goal.iconName),
                          color: widget.isSelected
                              ? AppColors.vibrantTeal
                              : Colors.white.withOpacity(0.7),
                          size: 22,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Title
                    Flexible(
                      child: Text(
                        widget.goal.name,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: widget.isSelected
                              ? Colors.white
                              : Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper method to map icon name to IconData
  IconData _getIconData(String name) {
    switch (name) {
      case 'scale':
        return Icons.monitor_weight_outlined;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'directions_run':
        return Icons.directions_run;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'spa':
        return Icons.spa;
      case 'favorite':
        return Icons.favorite_border;
      default:
        return Icons.category;
    }
  }
}
