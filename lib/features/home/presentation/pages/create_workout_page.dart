import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/widgets/background_gradient.dart';
import 'package:fitness_freaks_flutter/features/home/domain/entities/workout_creation_data.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/widgets/workout_creation_progress.dart';

class CreateWorkoutPage extends StatefulWidget {
  const CreateWorkoutPage({super.key});

  @override
  State<CreateWorkoutPage> createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage>
    with SingleTickerProviderStateMixin {
  // Current step and workout data
  WorkoutCreationStep _currentStep = WorkoutCreationStep.muscleGroup;
  final _workoutData = WorkoutCreationData();

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _buttonsAnimation;

  // Button scale animations
  final _nextButtonScale = ValueNotifier<double>(1.0);
  final _backButtonScale = ValueNotifier<double>(1.0);

  // New variable to track slide direction
  bool _isForwardTransition = true;

  // Search functionality for exercises
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> _filteredExercises = [];

  // Muscle groups data
  final List<Map<String, dynamic>> muscleGroups = [
    {
      'name': 'Chest',
      'icon': CupertinoIcons.heart_fill,
      'color': const Color(0xFFFF3B30),
    },
    {
      'name': 'Back',
      'icon': CupertinoIcons.arrow_up_down,
      'color': const Color(0xFF007AFF),
    },
    {
      'name': 'Shoulders',
      'icon': CupertinoIcons.minus_circle,
      'color': const Color(0xFFFF9500),
    },
    {
      'name': 'Arms',
      'icon': CupertinoIcons.hand_raised_fill,
      'color': const Color(0xFF34C759),
    },
    {
      'name': 'Legs',
      'icon': CupertinoIcons.minus,
      'color': const Color(0xFF5856D6),
    },
    {
      'name': 'Core',
      'icon': CupertinoIcons.circle_fill,
      'color': const Color(0xFFAF52DE),
    },
    {
      'name': 'Glutes',
      'icon': CupertinoIcons.circle,
      'color': const Color(0xFFFF2D92),
    },
    {
      'name': 'Full Body',
      'icon': CupertinoIcons.person_fill,
      'color': const Color(0xFF30D158),
    },
  ];

  // Duration options
  final List<int> durations = [15, 30, 45, 60, 75, 90];

  // Sample exercises data
  final Map<String, List<String>> exercisesByMuscle = {
    'Chest': [
      'Push-ups',
      'Bench Press',
      'Incline Dumbbell Press',
      'Chest Flyes',
      'Dips',
      'Cable Crossover'
    ],
    'Back': [
      'Pull-ups',
      'Lat Pulldown',
      'Barbell Rows',
      'Deadlifts',
      'T-Bar Rows',
      'Cable Rows'
    ],
    'Shoulders': [
      'Shoulder Press',
      'Lateral Raises',
      'Front Raises',
      'Rear Delt Flyes',
      'Arnold Press',
      'Upright Rows'
    ],
    'Arms': [
      'Bicep Curls',
      'Tricep Dips',
      'Hammer Curls',
      'Tricep Extensions',
      'Preacher Curls',
      'Close-Grip Push-ups'
    ],
    'Legs': [
      'Squats',
      'Lunges',
      'Leg Press',
      'Calf Raises',
      'Leg Curls',
      'Bulgarian Split Squats'
    ],
    'Core': [
      'Planks',
      'Crunches',
      'Russian Twists',
      'Mountain Climbers',
      'Leg Raises',
      'Dead Bug'
    ],
    'Glutes': [
      'Hip Thrusts',
      'Glute Bridges',
      'Clamshells',
      'Fire Hydrants',
      'Curtsy Lunges',
      'Single-Leg Deadlifts'
    ],
    'Full Body': [
      'Burpees',
      'Jumping Jacks',
      'High Knees',
      'Mountain Climbers',
      'Squat Jumps',
      'Plank to Push-up'
    ],
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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

  @override
  void dispose() {
    _animationController.dispose();
    _nextButtonScale.dispose();
    _backButtonScale.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Background gradient for workout creation
          const BackgroundGradient(forTab: TabType.workoutCreation),

          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Header with back button
                  _buildHeader(),

                  // Progress indicator
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: WorkoutCreationProgress(currentStep: _currentStep),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _titleForStep(_currentStep),
                                style: GoogleFonts.inter(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _subtitleForStep(_currentStep),
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
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
                            if (_currentStep !=
                                WorkoutCreationStep.values.first)
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Create Workout',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40), // Balance the back button
        ],
      ),
    );
  }

  // Build step content with horizontal slide animation
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

  // Build the view for the current step
  Widget _buildCurrentStepView() {
    switch (_currentStep) {
      case WorkoutCreationStep.muscleGroup:
        return _buildMuscleGroupSelection();
      case WorkoutCreationStep.duration:
        return _buildDurationSelection();
      case WorkoutCreationStep.exerciseSelection:
        return _buildExerciseSelection();
      case WorkoutCreationStep.summary:
        return _buildSummaryView();
    }
  }

  // Build muscle group selection (allows multiple) with duration
  Widget _buildMuscleGroupSelection() {
    return Column(
      key: const ValueKey('muscle_group_selection'),
      children: [
        const SizedBox(height: 8),

        // Muscle Groups Grid - Optimized for 8 items in 4x2 layout
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemCount: muscleGroups.length,
          itemBuilder: (context, index) {
            final muscle = muscleGroups[index];
            final isSelected =
                _workoutData.selectedMuscleGroups.contains(muscle['name']);

            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  if (isSelected) {
                    _workoutData.selectedMuscleGroups.remove(muscle['name']);
                  } else {
                    _workoutData.selectedMuscleGroups.add(muscle['name']);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppColors.vibrantMint,
                            AppColors.vibrantMint.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.12),
                            Colors.white.withOpacity(0.06),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.vibrantMint
                        : Colors.white.withOpacity(0.15),
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.vibrantMint.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : muscle['color'].withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        muscle['icon'],
                        color: isSelected ? Colors.black : muscle['color'],
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      muscle['name'],
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.black : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // Duration Selection Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.12),
                Colors.white.withOpacity(0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    CupertinoIcons.clock,
                    color: Colors.white.withOpacity(0.8),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Workout Duration',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: durations.map((duration) {
                  final isSelected = _workoutData.selectedDuration == duration;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _workoutData.selectedDuration = duration;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.vibrantMint
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.vibrantMint
                              : Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        '${duration} min',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Selected Summary (Compact)
        if (_workoutData.selectedMuscleGroups.isNotEmpty ||
            _workoutData.selectedDuration != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.vibrantMint.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.vibrantMint.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  color: AppColors.vibrantMint,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _buildSelectionSummary(),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _buildSelectionSummary() {
    final parts = <String>[];

    if (_workoutData.selectedMuscleGroups.isNotEmpty) {
      if (_workoutData.selectedMuscleGroups.length == 1) {
        parts.add(_workoutData.selectedMuscleGroups.first);
      } else {
        parts.add('${_workoutData.selectedMuscleGroups.length} muscle groups');
      }
    }

    if (_workoutData.selectedDuration != null) {
      parts.add('${_workoutData.selectedDuration} min');
    }

    return parts.isEmpty ? 'Make your selections' : parts.join(' • ');
  }

  // Build duration selection
  Widget _buildDurationSelection() {
    return Column(
      key: const ValueKey('duration_selection'),
      children: [
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: durations.map((duration) {
            final isSelected = _workoutData.selectedDuration == duration;
            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _workoutData.selectedDuration = duration;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.vibrantMint
                      : AppColors.glassBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.vibrantMint
                        : AppColors.glassBorder,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '${duration} min',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Build exercise selection with search
  Widget _buildExerciseSelection() {
    // Get all exercises for selected muscle groups
    final List<String> availableExercises = [];
    for (final muscle in _workoutData.selectedMuscleGroups) {
      if (exercisesByMuscle.containsKey(muscle)) {
        availableExercises.addAll(exercisesByMuscle[muscle]!);
      }
    }

    // Remove duplicates and sort
    final uniqueExercises = availableExercises.toSet().toList()..sort();

    // Filter exercises based on search query
    final filteredExercises = _searchQuery.isEmpty
        ? uniqueExercises
        : uniqueExercises
            .where((exercise) =>
                exercise.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Column(
      key: const ValueKey('exercise_selection'),
      children: [
        const SizedBox(height: 8),

        // Search Bar
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.12),
                Colors.white.withOpacity(0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.0,
            ),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Search exercises...',
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      child: Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: Colors.white.withOpacity(0.7),
                        size: 20,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Selected exercises summary (compact)
        if (_workoutData.selectedExercises.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.vibrantMint.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.vibrantMint.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  color: AppColors.vibrantMint,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_workoutData.selectedExercises.length} exercises selected',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _workoutData.selectedExercises.clear();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.clear,
                      color: Colors.white.withOpacity(0.7),
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Exercise categories (if no search)
        if (_searchQuery.isEmpty) ...[
          _buildExerciseCategories(uniqueExercises),
        ] else ...[
          // Search results
          _buildSearchResults(filteredExercises),
        ],
      ],
    );
  }

  // Build exercise categories grouped by muscle group
  Widget _buildExerciseCategories(List<String> allExercises) {
    return Column(
      children: _workoutData.selectedMuscleGroups.map((muscle) {
        final muscleExercises = exercisesByMuscle[muscle] ?? [];
        if (muscleExercises.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category header
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getMuscleColor(muscle).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getMuscleIcon(muscle),
                      color: _getMuscleColor(muscle),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    muscle,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${muscleExercises.length}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Exercise grid for this muscle group
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.8,
              ),
              itemCount: muscleExercises.length,
              itemBuilder: (context, index) {
                final exercise = muscleExercises[index];
                final isSelected =
                    _workoutData.selectedExercises.contains(exercise);

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      if (isSelected) {
                        _workoutData.selectedExercises.remove(exercise);
                      } else {
                        _workoutData.selectedExercises.add(exercise);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                AppColors.vibrantMint,
                                AppColors.vibrantMint.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.12),
                                Colors.white.withOpacity(0.06),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.vibrantMint
                            : Colors.white.withOpacity(0.15),
                        width: isSelected ? 2.0 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.vibrantMint.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 0,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? CupertinoIcons.checkmark_circle_fill
                              : CupertinoIcons.circle,
                          color: isSelected
                              ? Colors.black
                              : Colors.white.withOpacity(0.7),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            exercise,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        );
      }).toList(),
    );
  }

  // Build search results
  Widget _buildSearchResults(List<String> filteredExercises) {
    if (filteredExercises.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              CupertinoIcons.search,
              color: Colors.white.withOpacity(0.5),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No exercises found',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.8,
      ),
      itemCount: filteredExercises.length,
      itemBuilder: (context, index) {
        final exercise = filteredExercises[index];
        final isSelected = _workoutData.selectedExercises.contains(exercise);

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              if (isSelected) {
                _workoutData.selectedExercises.remove(exercise);
              } else {
                _workoutData.selectedExercises.add(exercise);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        AppColors.vibrantMint,
                        AppColors.vibrantMint.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.12),
                        Colors.white.withOpacity(0.06),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.vibrantMint
                    : Colors.white.withOpacity(0.15),
                width: isSelected ? 2.0 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.vibrantMint.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? CupertinoIcons.checkmark_circle_fill
                      : CupertinoIcons.circle,
                  color:
                      isSelected ? Colors.black : Colors.white.withOpacity(0.7),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    exercise,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper methods for muscle group colors and icons
  Color _getMuscleColor(String muscle) {
    final muscleData = muscleGroups.firstWhere(
      (m) => m['name'] == muscle,
      orElse: () => {'color': Colors.blue},
    );
    return muscleData['color'] as Color;
  }

  IconData _getMuscleIcon(String muscle) {
    final muscleData = muscleGroups.firstWhere(
      (m) => m['name'] == muscle,
      orElse: () => {'icon': CupertinoIcons.heart},
    );
    return muscleData['icon'] as IconData;
  }

  // Build summary view
  Widget _buildSummaryView() {
    final summary = _workoutData.summaryData;

    return Column(
      key: const ValueKey('summary_view'),
      children: [
        const SizedBox(height: 16),
        // Workout summary card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    CupertinoIcons.star_fill,
                    color: AppColors.vibrantMint,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Your Custom Workout',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Duration
              _buildSummaryRow(
                'Duration',
                '${summary['duration']} minutes',
                CupertinoIcons.clock,
              ),

              const SizedBox(height: 16),

              // Total exercises
              _buildSummaryRow(
                'Total Exercises',
                '${summary['totalExercises']} exercises',
                CupertinoIcons.list_bullet,
              ),

              const SizedBox(height: 16),

              // Muscle groups
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.flame,
                        color: Colors.white.withOpacity(0.7),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Target Muscle Groups',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        (summary['muscleGroups'] as List<String>).map((muscle) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.vibrantMint.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.vibrantMint.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          muscle,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.vibrantMint,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.7),
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
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
    final isLastStep = _currentStep == WorkoutCreationStep.values.last;
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
                color: canProceed
                    ? AppColors.vibrantMint
                    : Colors.grey.withOpacity(0.1),
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
                    isLastStep ? "Create Workout" : "Next",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: canProceed
                          ? Colors.black
                          : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    isLastStep
                        ? CupertinoIcons.add
                        : CupertinoIcons.chevron_right,
                    size: 20,
                    color: canProceed
                        ? Colors.black
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

    if (_currentStep == WorkoutCreationStep.values.last) {
      _completeWorkoutCreation();
    } else {
      _goToNextStep();
    }
  }

  // Go to the next step
  void _goToNextStep() {
    // Reset and run animations again for the new step
    _animationController.reset();

    // Set transition direction to forward
    setState(() {
      _isForwardTransition = true;

      // Skip duration step since it's now combined with muscle group
      switch (_currentStep) {
        case WorkoutCreationStep.muscleGroup:
          _currentStep = WorkoutCreationStep.exerciseSelection;
          break;
        case WorkoutCreationStep.duration:
          _currentStep = WorkoutCreationStep.exerciseSelection;
          break;
        case WorkoutCreationStep.exerciseSelection:
          _currentStep = WorkoutCreationStep.summary;
          break;
        case WorkoutCreationStep.summary:
          // This case is handled in _handleNextButtonPressed
          break;
      }
    });

    _animationController.forward();
  }

  // Go to the previous step
  void _goToPreviousStep() {
    HapticFeedback.lightImpact();

    // Reset and run animations again for the new step
    _animationController.reset();

    // Set transition direction to backward
    setState(() {
      _isForwardTransition = false;

      // Skip duration step since it's now combined with muscle group
      switch (_currentStep) {
        case WorkoutCreationStep.muscleGroup:
          // Can't go back from first step
          break;
        case WorkoutCreationStep.duration:
          _currentStep = WorkoutCreationStep.muscleGroup;
          break;
        case WorkoutCreationStep.exerciseSelection:
          _currentStep = WorkoutCreationStep.muscleGroup;
          break;
        case WorkoutCreationStep.summary:
          _currentStep = WorkoutCreationStep.exerciseSelection;
          break;
      }
    });

    _animationController.forward();
  }

  // Complete the workout creation process
  void _completeWorkoutCreation() {
    // Show success dialog
    _showWorkoutCreatedDialog();
  }

  // Check if we can move to the next step
  bool _canMoveToNextStep() {
    switch (_currentStep) {
      case WorkoutCreationStep.muscleGroup:
        return _workoutData.canProceedFromMuscleGroup &&
            _workoutData.canProceedFromDuration;
      case WorkoutCreationStep.duration:
        return _workoutData.canProceedFromDuration;
      case WorkoutCreationStep.exerciseSelection:
        return _workoutData.canProceedFromExercises;
      case WorkoutCreationStep.summary:
        return _workoutData.isComplete;
    }
  }

  // Get the title for the current step
  String _titleForStep(WorkoutCreationStep step) {
    switch (step) {
      case WorkoutCreationStep.muscleGroup:
        return "Select Muscle Groups";
      case WorkoutCreationStep.duration:
        return "Choose Duration";
      case WorkoutCreationStep.exerciseSelection:
        return "Pick Exercises";
      case WorkoutCreationStep.summary:
        return "Review Workout";
    }
  }

  // Get the subtitle for the current step
  String _subtitleForStep(WorkoutCreationStep step) {
    switch (step) {
      case WorkoutCreationStep.muscleGroup:
        return "Select muscle groups and workout duration";
      case WorkoutCreationStep.duration:
        return "How long do you want to work out?";
      case WorkoutCreationStep.exerciseSelection:
        return "Choose exercises for your workout";
      case WorkoutCreationStep.summary:
        return "Everything looks good? Let's create it!";
    }
  }

  void _showWorkoutCreatedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.glassBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Workout Created!',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          content: Text(
            'Your custom workout with ${_workoutData.selectedExercises.length} exercises has been created successfully!',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to fitness view
              },
              child: Text(
                'Done',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.vibrantMint,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
