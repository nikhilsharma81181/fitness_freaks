import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import '../widgets/background_gradient.dart';

class AiWorkoutGenerationPage extends StatefulWidget {
  const AiWorkoutGenerationPage({super.key});

  @override
  State<AiWorkoutGenerationPage> createState() =>
      _AiWorkoutGenerationPageState();
}

class _AiWorkoutGenerationPageState extends State<AiWorkoutGenerationPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _sparkleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _sparkleAnimation;

  bool _isGenerating = false;
  String _selectedGoal = '';
  String _selectedDuration = '';
  String _selectedDifficulty = '';
  String _selectedFocus = '';

  final List<Map<String, dynamic>> _goals = [
    {
      'title': 'Build Muscle',
      'subtitle': 'Hypertrophy focused',
      'icon': CupertinoIcons.bolt_fill,
      'color': const Color(0xFF007AFF),
    },
    {
      'title': 'Lose Weight',
      'subtitle': 'Fat burning cardio',
      'icon': CupertinoIcons.flame_fill,
      'color': const Color(0xFFFF3B30),
    },
    {
      'title': 'Get Stronger',
      'subtitle': 'Strength training',
      'icon': CupertinoIcons.hammer_fill,
      'color': const Color(0xFF30D158),
    },
    {
      'title': 'Improve Endurance',
      'subtitle': 'Cardiovascular fitness',
      'icon': CupertinoIcons.heart_fill,
      'color': const Color(0xFFFF9500),
    },
  ];

  final List<String> _durations = [
    '15 min',
    '30 min',
    '45 min',
    '60 min',
    '90 min'
  ];
  final List<String> _difficulties = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert'
  ];
  final List<Map<String, dynamic>> _focusAreas = [
    {'name': 'Full Body', 'icon': CupertinoIcons.person_fill},
    {'name': 'Upper Body', 'icon': CupertinoIcons.arrow_up_circle_fill},
    {'name': 'Lower Body', 'icon': CupertinoIcons.arrow_down_circle_fill},
    {'name': 'Core', 'icon': CupertinoIcons.circle_grid_3x3_fill},
    {'name': 'Cardio', 'icon': CupertinoIcons.heart_fill},
    {'name': 'Flexibility', 'icon': CupertinoIcons.leaf_arrow_circlepath},
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _sparkleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
    _sparkleController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  bool get _canGenerate {
    return _selectedGoal.isNotEmpty &&
        _selectedDuration.isNotEmpty &&
        _selectedDifficulty.isNotEmpty &&
        _selectedFocus.isNotEmpty;
  }

  void _generateWorkout() async {
    if (!_canGenerate) return;

    setState(() {
      _isGenerating = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate AI generation
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isGenerating = false;
    });

    // Show success dialog and navigate to generated workout
    _showGeneratedWorkout();
  }

  void _showGeneratedWorkout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildGeneratedWorkoutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Background gradient
          const BackgroundGradient(forTab: TabType.aiWorkoutGeneration),

          // Main content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),

                          // AI Brain Animation
                          _buildAIBrainSection(),

                          const SizedBox(height: 24),

                          // Fitness Goals
                          _buildSectionTitle('Your Fitness Goal'),
                          const SizedBox(height: 12),
                          _buildGoalsGrid(),

                          const SizedBox(height: 24),

                          // Duration Selection
                          _buildSectionTitle('Workout Duration'),
                          const SizedBox(height: 12),
                          _buildDurationChips(),

                          const SizedBox(height: 24),

                          // Difficulty Level
                          _buildSectionTitle('Difficulty Level'),
                          const SizedBox(height: 12),
                          _buildDifficultyChips(),

                          const SizedBox(height: 24),

                          // Focus Area
                          _buildSectionTitle('Focus Area'),
                          const SizedBox(height: 12),
                          _buildFocusGrid(),

                          const SizedBox(height: 32),

                          // Generate Button
                          _buildGenerateButton(),

                          // Extra bottom padding
                          const SizedBox(height: 100),
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
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          // Back Button
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
                  size: 18,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'AI Workout Generator',
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedBuilder(
                      animation: _sparkleAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _sparkleAnimation.value * 2 * 3.14159,
                          child: Icon(
                            CupertinoIcons.sparkles,
                            color: AppColors.vibrantMint,
                            size: 20,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Personalized workouts powered by AI',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIBrainSection() {
    return Center(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.sparkles,
                      color: AppColors.vibrantMint,
                      size: 36,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'AI',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.vibrantMint,
                        letterSpacing: 2,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }

  Widget _buildGoalsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: _goals.length,
      itemBuilder: (context, index) {
        final goal = _goals[index];
        final isSelected = _selectedGoal == goal['title'];

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedGoal = goal['title'];
            });
            HapticFeedback.lightImpact();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(isSelected ? 0.15 : 0.08),
                  Colors.white.withOpacity(isSelected ? 0.08 : 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? goal['color'].withOpacity(0.5)
                    : Colors.white.withOpacity(0.15),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: goal['color'].withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      goal['icon'],
                      color: goal['color'],
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    goal['title'],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    goal['subtitle'],
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDurationChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _durations.map((duration) {
        final isSelected = _selectedDuration == duration;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDuration = duration;
            });
            HapticFeedback.lightImpact();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        AppColors.vibrantMint,
                        AppColors.vibrantTeal,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.vibrantMint
                    : Colors.white.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Text(
              duration,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:
                    isSelected ? Colors.black : Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDifficultyChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _difficulties.map((difficulty) {
        final isSelected = _selectedDifficulty == difficulty;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDifficulty = difficulty;
            });
            HapticFeedback.lightImpact();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        const Color(0xFF007AFF),
                        const Color(0xFF5856D6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF007AFF)
                    : Colors.white.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Text(
              difficulty,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFocusGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.2,
      ),
      itemCount: _focusAreas.length,
      itemBuilder: (context, index) {
        final focus = _focusAreas[index];
        final isSelected = _selectedFocus == focus['name'];

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedFocus = focus['name'];
            });
            HapticFeedback.lightImpact();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(isSelected ? 0.15 : 0.08),
                  Colors.white.withOpacity(isSelected ? 0.08 : 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFFF9500).withOpacity(0.5)
                    : Colors.white.withOpacity(0.15),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    focus['icon'],
                    color: isSelected
                        ? const Color(0xFFFF9500)
                        : Colors.white.withOpacity(0.7),
                    size: 20,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    focus['name'],
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenerateButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: _canGenerate
            ? LinearGradient(
                colors: [
                  AppColors.vibrantMint,
                  AppColors.vibrantTeal,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: _canGenerate ? null : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _canGenerate
              ? AppColors.vibrantMint.withOpacity(0.5)
              : Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: ElevatedButton(
        onPressed: _canGenerate && !_isGenerating ? _generateWorkout : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isGenerating
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _canGenerate
                            ? Colors.black
                            : Colors.white.withOpacity(0.5),
                      ),
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Generating AI Workout...',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _canGenerate
                          ? Colors.black
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.sparkles,
                    color: _canGenerate
                        ? Colors.black
                        : Colors.white.withOpacity(0.5),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Generate AI Workout',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _canGenerate
                          ? Colors.black
                          : Colors.white.withOpacity(0.5),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGeneratedWorkoutDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.vibrantMint.withOpacity(0.3),
                    AppColors.vibrantTeal.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.vibrantMint.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: Icon(
                CupertinoIcons.checkmark_alt,
                color: AppColors.vibrantMint,
                size: 40,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Workout Generated!',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Your personalized AI workout for ${_selectedGoal.toLowerCase()} is ready. Duration: $_selectedDuration, Difficulty: $_selectedDifficulty, Focus: $_selectedFocus.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Back to Fitness',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.vibrantMint,
                          AppColors.vibrantTeal,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        // TODO: Navigate to generated workout details
                      },
                      child: Text(
                        'Start Workout',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
