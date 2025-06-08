import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fitness_freaks_flutter/features/home/domain/entities/workout_creation_data.dart';

/// Widget that displays the workout creation progress as a series of indicators
class WorkoutCreationProgress extends StatefulWidget {
  /// The current step in the workout creation process
  final WorkoutCreationStep currentStep;

  const WorkoutCreationProgress({
    Key? key,
    required this.currentStep,
  }) : super(key: key);

  @override
  State<WorkoutCreationProgress> createState() =>
      _WorkoutCreationProgressState();
}

class _WorkoutCreationProgressState extends State<WorkoutCreationProgress>
    with SingleTickerProviderStateMixin {
  // Active steps (skipping duration since it's combined with muscle group)
  final List<WorkoutCreationStep> activeSteps = [
    WorkoutCreationStep.muscleGroup,
    WorkoutCreationStep.exerciseSelection,
    WorkoutCreationStep.summary,
  ];

  // Animation controller for indicator animation
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _progressAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    // Animate when the widget builds
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WorkoutCreationProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset and animate again when step changes
    if (oldWidget.currentStep != widget.currentStep) {
      // Add haptic feedback when step changes
      HapticFeedback.mediumImpact();

      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return Row(
            children: List.generate(
              activeSteps.length,
              (index) => _buildStepIndicator(activeSteps[index], index),
            ),
          );
        },
      ),
    );
  }

  // Build a single step indicator
  Widget _buildStepIndicator(WorkoutCreationStep step, int index) {
    // Determine if this step is current, completed, or upcoming
    final isCurrent = step == widget.currentStep;
    final isCompleted =
        activeSteps.indexOf(step) < activeSteps.indexOf(widget.currentStep);

    // Calculate current step position for sequential animation
    final currentStepIndex = activeSteps.indexOf(widget.currentStep);

    // Only animate up to the current step + 1
    final shouldAnimate = index <= currentStepIndex;

    // Delay factor based on distance from first step
    final delayFactor = (index * 0.12).clamp(0.0, 0.8);

    // Create a delayed animation for each indicator
    final Animation<double> delayedAnimation = shouldAnimate
        ? CurvedAnimation(
            parent: _progressAnimation,
            curve: Interval(
              delayFactor,
              (delayFactor + 0.12).clamp(0.0, 1.0),
              curve: Curves.easeOut,
            ),
          )
        : const AlwaysStoppedAnimation(0.0);

    // Get the appropriate color based on step status
    final color = _getStepColor(step, isCurrent, isCompleted);

    // Animation for width expansion
    final widthAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(delayedAnimation);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: widthAnimation.value,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
                border: null,
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: AppColors.vibrantMint.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 0.5,
                        )
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Get the color for a step indicator based on its status
  Color _getStepColor(
      WorkoutCreationStep step, bool isCurrent, bool isCompleted) {
    if (isCompleted) {
      // Completed steps - bright accent color
      return AppColors.vibrantMint;
    } else if (isCurrent) {
      // Current step - vibrant accent color
      return AppColors.vibrantMint;
    } else {
      // Future steps - dimmed color
      return Colors.white.withOpacity(0.2);
    }
  }
}
