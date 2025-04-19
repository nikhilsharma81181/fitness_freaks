import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/widgets/background_gradient.dart';
import 'package:fitness_freaks_flutter/features/auth/domain/entities/user_onboarding_data.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/pages/homepage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/onboarding_progress_view.dart';
import '../widgets/personal_info_view.dart';
import '../widgets/fitness_goals_view.dart';
import '../widgets/experience_level_view.dart';
import '../widgets/workout_preferences_view.dart';
import '../widgets/dietary_info_view.dart';
import '../widgets/profile_summary_view.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  // Current step and onboarding data
  OnboardingStep _currentStep = OnboardingStep.personalInfo;
  final _onboardingData = UserOnboardingData();

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _buttonsAnimation;

  // Keep references to both step views to preserve their state
  late final Map<OnboardingStep, Widget> _stepViews = {
    OnboardingStep.personalInfo: PersonalInfoView(
      key: const ValueKey('personal_info'),
      onboardingData: _onboardingData,
      onDataChanged: () => setState(() {}),
    ),
    OnboardingStep.fitnessGoals: FitnessGoalsView(
      key: const ValueKey('fitness_goals'),
      onboardingData: _onboardingData,
      onDataChanged: () => setState(() {}),
    ),
    OnboardingStep.experienceLevel: ExperienceLevelView(
      key: const ValueKey('experience_level'),
      onboardingData: _onboardingData,
      onDataChanged: () => setState(() {}),
    ),
    OnboardingStep.workoutPreferences: WorkoutPreferencesView(
      key: const ValueKey('workout_preferences'),
      onboardingData: _onboardingData,
      onDataChanged: () => setState(() {}),
    ),
    OnboardingStep.dietaryInfo: DietaryInfoView(
      key: const ValueKey('dietary_info'),
      onboardingData: _onboardingData,
      onDataChanged: () => setState(() {}),
    ),
    OnboardingStep.summary: ProfileSummaryView(
      key: const ValueKey('profile_summary'),
      onboardingData: _onboardingData,
      onDataChanged: () => setState(() {}),
      onEditStep: _navigateToStep,
    ),
  };

  // Button scale animations
  final _nextButtonScale = ValueNotifier<double>(1.0);
  final _backButtonScale = ValueNotifier<double>(1.0);

  List<Widget> _steps = [];

  // New variable to track slide direction
  bool _isForwardTransition = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeSteps();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Staggered animations
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    _titleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
    );

    _buttonsAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    // Start animations
    _animationController.forward();
  }

  void _initializeSteps() {
    _steps = [
      PersonalInfoView(
        onboardingData: _onboardingData,
        onDataChanged: () => setState(() {}),
      ),
      FitnessGoalsView(
        onboardingData: _onboardingData,
        onDataChanged: () => setState(() {}),
      ),
      ExperienceLevelView(
        onboardingData: _onboardingData,
        onDataChanged: () => setState(() {}),
      ),
      WorkoutPreferencesView(
        onboardingData: _onboardingData,
        onDataChanged: () => setState(() {}),
      ),
      DietaryInfoView(
        onboardingData: _onboardingData,
        onDataChanged: () => setState(() {}),
      ),
      ProfileSummaryView(
        onboardingData: _onboardingData,
        onDataChanged: () => setState(() {}),
        onEditStep: _navigateToStep,
      ),
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nextButtonScale.dispose();
    _backButtonScale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Background gradient that changes based on step
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: BackgroundGradient(
              key: ValueKey('bg_${_currentStep.toString()}'),
              forTab: _backgroundGradientForStep(_currentStep),
            ),
          ),

          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Progress indicator
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: OnboardingProgressView(currentStep: _currentStep),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
                    child: FadeTransition(
                      opacity: _titleAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(_titleAnimation),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _titleForStep(_currentStep),
                            style: GoogleFonts.inter(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Step content (scrollable)
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 100,
                        maxHeight: MediaQuery.of(context).size.height - 200,
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: _buildStepContentWithAnimation(),
                        ),
                      ),
                    ),
                  ),

                  // Next/Previous buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
                    child: FadeTransition(
                      opacity: _buttonsAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(_buttonsAnimation),
                        child: Row(
                          children: [
                            // Back button (shown after first step)
                            if (_currentStep != OnboardingStep.values.first)
                              _buildBackButton(),
                            const Spacer(),
                            // Next/Finish button
                            _buildNextButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // New method to build step content with horizontal slide animation
  Widget _buildStepContentWithAnimation() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOutQuart,
      switchOutCurve: Curves.easeInQuart,
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Calculate slide direction based on transition type
        final slideDirection = _isForwardTransition ? 1.0 : -1.0;

        // Incoming slide from right or left
        final incomingPosition = Tween<Offset>(
          begin: Offset(slideDirection, 0.0),
          end: Offset.zero,
        ).animate(animation);

        // Outgoing slide to left or right
        final outgoingPosition = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(-slideDirection, 0.0),
        ).animate(animation);

        // Current child has the key matching the current step
        final isIncoming =
            child.key == ValueKey('step_${_currentStep.toString()}');

        return SlideTransition(
          position: isIncoming ? incomingPosition : outgoingPosition,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: IndexedStack(
        key: ValueKey('step_${_currentStep.toString()}'),
        index: 0,
        sizing: StackFit.loose,
        children: [_buildCurrentStepView()],
      ),
    );
  }

  // Build the view for the current step - now using prebuilt views with preserved state
  Widget _buildCurrentStepView() {
    final currentView = _stepViews[_currentStep];
    if (currentView != null) {
      return currentView;
    }

    // Fallback for unimplemented steps
    return Center(
      key: ValueKey('step_${_currentStep.toString()}_fallback'),
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Text(
          "This step will be implemented next",
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Build the back button
  Widget _buildBackButton() {
    return ValueListenableBuilder<double>(
      valueListenable: _backButtonScale,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: TextButton(
            onPressed: () {
              _animateButtonTap(_backButtonScale);
              _goToPreviousStep();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Colors.white.withOpacity(0.15),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(CupertinoIcons.chevron_left,
                    color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Back",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build the next/finish button
  Widget _buildNextButton() {
    final isLastStep = _currentStep == OnboardingStep.values.last;
    final canProceed = _canMoveToNextStep();

    return ValueListenableBuilder<double>(
      valueListenable: _nextButtonScale,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: canProceed
                ? () {
                    _animateButtonTap(_nextButtonScale);
                    _handleNextButtonPressed();
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                gradient: canProceed
                    ? LinearGradient(
                        colors: [
                          AppColors.profileGradient1,
                          AppColors.profileGradient2,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                color: canProceed ? null : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLastStep ? "Finish" : "Next",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: canProceed
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    CupertinoIcons.chevron_right,
                    size: 20,
                    color: canProceed
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Animate button tap with scale effect
  void _animateButtonTap(ValueNotifier<double> scaleNotifier) {
    // Haptic feedback
    HapticFeedback.lightImpact();

    // Scale down
    scaleNotifier.value = 0.95;

    // Scale back up after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        scaleNotifier.value = 1.0;
      }
    });
  }

  // Handle next button press
  void _handleNextButtonPressed() {
    HapticFeedback.mediumImpact();

    if (_currentStep == OnboardingStep.values.last) {
      _completeOnboarding();
    } else {
      _goToNextStep();
    }
  }

  // Go to the next step
  void _goToNextStep() {
    final allSteps = OnboardingStep.values;
    final currentIndex = allSteps.indexOf(_currentStep);

    if (currentIndex < allSteps.length - 1) {
      // Reset and run animations again for the new step
      _animationController.reset();

      // Set transition direction to forward
      setState(() {
        _isForwardTransition = true;
        _currentStep = allSteps[currentIndex + 1];
      });

      _animationController.forward();
    }
  }

  // Go to the previous step
  void _goToPreviousStep() {
    HapticFeedback.lightImpact();

    final allSteps = OnboardingStep.values;
    final currentIndex = allSteps.indexOf(_currentStep);

    if (currentIndex > 0) {
      // Reset and run animations again for the new step
      _animationController.reset();

      // Set transition direction to backward
      setState(() {
        _isForwardTransition = false;
        _currentStep = allSteps[currentIndex - 1];
      });

      _animationController.forward();
    }
  }

  // Complete the onboarding process
  void _completeOnboarding() {
    // TODO: Save onboarding data to persistent storage

    // Navigate to the main app
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  // Check if we can move to the next step
  bool _canMoveToNextStep() {
    switch (_currentStep) {
      case OnboardingStep.personalInfo:
        return _onboardingData.age != null &&
            _onboardingData.height != null &&
            _onboardingData.weight != null;
      case OnboardingStep.fitnessGoals:
        return _onboardingData.fitnessGoals.isNotEmpty;
      case OnboardingStep.experienceLevel:
        return true; // Always valid as we have a default
      case OnboardingStep.workoutPreferences:
        return true; // Always valid as we have defaults
      case OnboardingStep.dietaryInfo:
        return true; // Optional step
      case OnboardingStep.summary:
        return true; // Review screen, always valid
    }
  }

  // Get the title for the current step
  String _titleForStep(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.personalInfo:
        return "Tell us about yourself";
      case OnboardingStep.fitnessGoals:
        return "What are your fitness goals?";
      case OnboardingStep.experienceLevel:
        return "What's your experience level?";
      case OnboardingStep.workoutPreferences:
        return "Workout preferences";
      case OnboardingStep.dietaryInfo:
        return "Dietary information";
      case OnboardingStep.summary:
        return "Review your profile";
    }
  }

  // Get the appropriate background gradient for the current step
  TabType _backgroundGradientForStep(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.personalInfo:
        return TabType.personalInfo;
      case OnboardingStep.fitnessGoals:
        return TabType.fitnessGoals;
      case OnboardingStep.experienceLevel:
        return TabType.experienceLevel;
      case OnboardingStep.workoutPreferences:
        return TabType.workoutPreferences;
      case OnboardingStep.dietaryInfo:
        return TabType.dietaryInfo;
      case OnboardingStep.summary:
        return TabType.summary;
    }
  }

  // Navigate to a specific step (for edit functionality)
  void _navigateToStep(OnboardingStep step) {
    final allSteps = OnboardingStep.values;
    final currentIndex = allSteps.indexOf(_currentStep);
    final targetIndex = allSteps.indexOf(step);

    setState(() {
      // Determine if we're going forward or backward based on indices
      _isForwardTransition = targetIndex > currentIndex;
      _currentStep = step;
    });

    // Reset and run animations
    _animationController.reset();
    _animationController.forward();
  }
}
