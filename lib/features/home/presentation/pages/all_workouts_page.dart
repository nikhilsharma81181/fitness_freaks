import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import '../widgets/background_gradient.dart';

class AllWorkoutsPage extends StatefulWidget {
  const AllWorkoutsPage({super.key});

  @override
  State<AllWorkoutsPage> createState() => _AllWorkoutsPageState();
}

class _AllWorkoutsPageState extends State<AllWorkoutsPage> {
  String _selectedFilter = 'All';

  final List<String> _filterTabs = [
    'All',
    'Chest',
    'Back',
    'Biceps',
    'Triceps',
    'Shoulders',
    'Legs',
    'Core'
  ];

  final List<Map<String, dynamic>> _allWorkoutPlans = [
    {
      'name': 'Back and Biceps',
      'description': 'Upper body pulling muscles',
      'exercises': [
        'Reverse Grip Lat Pulldown (Cable)',
        'Single Arm Cable Row',
        'Seated Cable Row - Bar Grip',
        'Seated Cable Row - Wide Grip',
        'Bicep Curls',
        'Hammer Curls'
      ],
      'duration': '45 min',
      'frequency': '3x week',
      'difficulty': 'Intermediate',
      'category': 'Back',
      'isAI': false,
      'color': const Color(0xFF007AFF),
      'icon': CupertinoIcons.bars,
      'lastUsed': '2 days ago',
    },
    {
      'name': 'Triceps',
      'description': 'Arm extension focused workout',
      'exercises': [
        'Skullcrusher (Dumbbell)',
        'Triceps Extension (Cable)',
        'Triceps Pushdown',
        'Triceps Rope Pushdown',
        'Close-Grip Push-ups',
        'Dips'
      ],
      'duration': '30 min',
      'frequency': '3x week',
      'difficulty': 'Intermediate',
      'category': 'Triceps',
      'isAI': false,
      'color': const Color(0xFFFF3B30),
      'icon': CupertinoIcons.heart_fill,
      'lastUsed': 'Yesterday',
    },
    {
      'name': 'Biceps',
      'description': 'Arm flexion and strength',
      'exercises': [
        'Bicep Curl (Cable)',
        'Bicep Curl (Dumbbell)',
        'Concentration Curl',
        'Cross Body Hammer Curl',
        'Drag Curl',
        'Preacher Curls'
      ],
      'duration': '25 min',
      'frequency': '3x week',
      'difficulty': 'Beginner',
      'category': 'Biceps',
      'isAI': false,
      'color': const Color(0xFF30D158),
      'icon': CupertinoIcons.person_alt,
      'lastUsed': '1 week ago',
    },
    {
      'name': 'Chest Power',
      'description': 'Upper body pushing strength',
      'exercises': [
        'Bench Press',
        'Incline Dumbbell Press',
        'Chest Flyes',
        'Push-ups',
        'Cable Crossover',
        'Dips'
      ],
      'duration': '50 min',
      'frequency': '2x week',
      'difficulty': 'Advanced',
      'category': 'Chest',
      'isAI': false,
      'color': const Color(0xFFFF9500),
      'icon': CupertinoIcons.flame_fill,
      'lastUsed': '3 days ago',
    },
    {
      'name': 'Leg Day Challenge',
      'description': 'Lower body power training',
      'exercises': [
        'Squats',
        'Lunges',
        'Leg Press',
        'Calf Raises',
        'Bulgarian Split Squats',
        'Leg Curls'
      ],
      'duration': '55 min',
      'frequency': '2x week',
      'difficulty': 'Advanced',
      'category': 'Legs',
      'isAI': false,
      'color': const Color(0xFF5856D6),
      'icon': CupertinoIcons.bolt_fill,
      'lastUsed': '5 days ago',
    },
    {
      'name': 'Shoulder Sculpt',
      'description': 'Complete shoulder development',
      'exercises': [
        'Overhead Press',
        'Lateral Raises',
        'Front Raises',
        'Rear Delt Flyes',
        'Arnold Press',
        'Upright Rows'
      ],
      'duration': '35 min',
      'frequency': '3x week',
      'difficulty': 'Intermediate',
      'category': 'Shoulders',
      'isAI': false,
      'color': const Color(0xFFFF2D92),
      'icon': CupertinoIcons.flame,
      'lastUsed': '1 week ago',
    },
    {
      'name': 'Core Strength',
      'description': 'Abdominal and core stability',
      'exercises': [
        'Plank Variations',
        'Russian Twists',
        'Dead Bug',
        'Bird Dog',
        'Bicycle Crunches',
        'Leg Raises'
      ],
      'duration': '25 min',
      'frequency': '4x week',
      'difficulty': 'Intermediate',
      'category': 'Core',
      'isAI': false,
      'color': const Color(0xFFFF9500),
      'icon': CupertinoIcons.circle_grid_3x3,
      'lastUsed': '1 week ago',
    },
  ];

  List<Map<String, dynamic>> get _filteredWorkouts {
    if (_selectedFilter == 'All') {
      return _allWorkoutPlans;
    }
    return _allWorkoutPlans
        .where((workout) => workout['category'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Background gradient
          const BackgroundGradient(forTab: TabType.fitness),

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
                          const SizedBox(height: 20),

                          // Filter Tabs
                          _buildFilterTabs(),

                          const SizedBox(height: 24),

                          // Workout Count
                          Text(
                            '${_filteredWorkouts.length} Workouts',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // All Workouts List
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _filteredWorkouts.length,
                            itemBuilder: (context, index) {
                              final plan = _filteredWorkouts[index];
                              return _buildWorkoutCard(plan);
                            },
                          ),

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
                Text(
                  'All Workouts',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose your perfect workout',
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

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filterTabs.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
                HapticFeedback.lightImpact();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.vibrantTeal
                        : Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  filter,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.black
                        : Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWorkoutCard(Map<String, dynamic> plan) {
    final exercises = plan['exercises'] as List<String>;
    final displayExercises = exercises.take(3).toList();
    final hasMoreExercises = exercises.length > 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and title
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: plan['color'],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Icon(
                          plan['icon'],
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  plan['name'],
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              if (plan['isAI'])
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.vibrantMint.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.vibrantMint
                                          .withOpacity(0.4),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'AI',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.vibrantMint,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.time,
                                size: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                plan['duration'],
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                CupertinoIcons.calendar,
                                size: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                plan['frequency'],
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Last Used Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Last Used',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          plan['lastUsed'],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Exercise List
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...displayExercises
                        .map((exercise) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      exercise,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    if (hasMoreExercises) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${exercises.length - 3} more exercises...',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 20),

                // Start Routine Button
                Container(
                  width: double.infinity,
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
                  child: ElevatedButton(
                    onPressed: () {
                      // Start workout routine
                      HapticFeedback.mediumImpact();
                      // TODO: Navigate to workout session
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Start Routine',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
