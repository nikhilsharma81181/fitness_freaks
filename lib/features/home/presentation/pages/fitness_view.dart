import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'create_workout_page.dart';

class FitnessView extends StatefulWidget {
  const FitnessView({super.key});

  @override
  State<FitnessView> createState() => _FitnessViewState();
}

class _FitnessViewState extends State<FitnessView>
    with SingleTickerProviderStateMixin {
  bool _isRefreshing = false;
  late AnimationController _refreshAnimationController;

  // Streamlined data focused on AI insights
  final Map<String, dynamic> _aiInsights = {
    'fitnessScore': 87,
    'trend': 'improving',
    'weeklyGoal': 0.73,
    'recommendation':
        'Add 2 more cardio sessions this week to reach optimal fitness',
    'nextWorkout': 'AI suggests: Upper Body Strength',
    'recoveryStatus': 'Fully Recovered',
    'predictedCalories': 2847,
  };

  final List<Map<String, dynamic>> _weeklyProgress = [
    {'day': 'Mon', 'completed': true, 'intensity': 0.8},
    {'day': 'Tue', 'completed': true, 'intensity': 0.6},
    {'day': 'Wed', 'completed': false, 'intensity': 0.0},
    {'day': 'Thu', 'completed': true, 'intensity': 0.9},
    {'day': 'Fri', 'completed': false, 'intensity': 0.0},
    {'day': 'Sat', 'completed': true, 'intensity': 0.7},
    {'day': 'Sun', 'completed': false, 'intensity': 0.0},
  ];

  final List<Map<String, dynamic>> _workoutPlans = [
    {
      'name': 'Full Body Strength',
      'description': 'Complete strength training',
      'exercises': 6,
      'duration': '45 min',
      'difficulty': 'Intermediate',
      'isAI': false,
      'color': const Color(0xFF007AFF),
      'icon': CupertinoIcons.bars,
    },
    {
      'name': 'HIIT Cardio Blast',
      'description': 'High intensity intervals',
      'exercises': 5,
      'duration': '30 min',
      'difficulty': 'Intermediate',
      'isAI': false,
      'color': const Color(0xFFFF3B30),
      'icon': CupertinoIcons.heart_fill,
    },
    {
      'name': 'Upper Body Focus',
      'description': 'Arms, chest, back strength',
      'exercises': 7,
      'duration': '50 min',
      'difficulty': 'Advanced',
      'isAI': false,
      'color': const Color(0xFF007AFF),
      'icon': CupertinoIcons.bars,
    },
    {
      'name': 'Core & Flexibility',
      'description': 'Core strength and stretching',
      'exercises': 8,
      'duration': '35 min',
      'difficulty': 'Beginner',
      'isAI': false,
      'color': const Color(0xFF30D158),
      'icon': CupertinoIcons.person_alt,
    },
    {
      'name': 'Leg Day Challenge',
      'description': 'Lower body power training',
      'exercises': 6,
      'duration': '55 min',
      'difficulty': 'Advanced',
      'isAI': false,
      'color': const Color(0xFF007AFF),
      'icon': CupertinoIcons.bars,
    },
  ];

  final List<Map<String, dynamic>> _aiRecommendations = [
    {
      'title': 'Optimal Workout Time',
      'subtitle': 'Based on your sleep & HRV data',
      'value': '7:30 AM',
      'confidence': 94,
      'icon': CupertinoIcons.clock_fill,
      'color': const Color(0xFF00D4AA),
    },
    {
      'title': 'Recovery Status',
      'subtitle': 'Heart rate variability analysis',
      'value': 'Ready',
      'confidence': 88,
      'icon': CupertinoIcons.heart_fill,
      'color': const Color(0xFF00D4AA),
    },
    {
      'title': 'Focus Area',
      'subtitle': 'AI detected muscle imbalance',
      'value': 'Core Strength',
      'confidence': 91,
      'icon': CupertinoIcons.scope,
      'color': const Color(0xFFFF6B35),
    },
  ];

  final List<Map<String, dynamic>> _metrics = [
    {
      'label': 'Weekly Active',
      'value': '4.2',
      'unit': 'hours',
      'change': '+12%',
      'isPositive': true,
      'icon': CupertinoIcons.flame_fill,
      'color': const Color(0xFFFF6B35),
    },
    {
      'label': 'Avg Heart Rate',
      'value': '142',
      'unit': 'bpm',
      'change': '-3%',
      'isPositive': true,
      'icon': CupertinoIcons.heart_fill,
      'color': const Color(0xFFE74C3C),
    },
    {
      'label': 'Calories Burned',
      'value': '2,847',
      'unit': 'kcal',
      'change': '+8%',
      'isPositive': true,
      'icon': CupertinoIcons.bolt_fill,
      'color': const Color(0xFFF39C12),
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _refreshAnimationController.dispose();
    super.dispose();
  }

  void _onRefresh() {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    _refreshAnimationController.repeat();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isRefreshing = false;
      });
      _refreshAnimationController.stop();
      _refreshAnimationController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Header with AI branding
          _buildHeader(),

          // Main scrollable content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Compact combined AI Score and Weekly Activity
                    _buildCompactDashboard(),

                    const SizedBox(height: 20),

                    // Prominent Workout Plans Section (Main Focus)
                    _buildWorkoutPlans(),

                    // AI Action Button
                    _buildAIActionButton(),

                    // Extra bottom padding for tab bar
                    const SizedBox(height: 140),
                  ],
                ),
              ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'AI Fitness',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withOpacity(0.3),
                          AppColors.primaryColor.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'BETA',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Powered by advanced machine learning',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: _onRefresh,
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
              child: Center(
                child: _isRefreshing
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: RotationTransition(
                          turns: _refreshAnimationController,
                          child: const Icon(
                            CupertinoIcons.arrow_2_circlepath,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      )
                    : const Icon(
                        CupertinoIcons.arrow_2_circlepath,
                        color: Colors.white,
                        size: 14,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDashboard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
              // Simplified AI Score and Insights
              Row(
                children: [
                  // AI Fitness Score (Clean)
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.sparkles,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AI Score',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${_aiInsights['fitnessScore']}',
                              style: GoogleFonts.inter(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: AppColors.vibrantMint,
                                height: 0.9,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '/100',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Vertical Divider
                  Container(
                    width: 1,
                    height: 60,
                    color: Colors.white.withOpacity(0.15),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),

                  // AI Insights (Clean)
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recovery Status',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fully Recovered',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.vibrantMint,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ready for intense workout',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutPlans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Action Cards Row
        Row(
          children: [
            // New Workout Card
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const CreateWorkoutPage(),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
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
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              CupertinoIcons.add,
                              color: AppColors.primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'New\nWorkout',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Discover Workouts Card
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Navigate to discover workouts
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
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
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8E44AD).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              CupertinoIcons.search,
                              color: Color(0xFF8E44AD),
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Discover\nWorkouts',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Filter Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterTab('All', true),
              const SizedBox(width: 12),
              _buildFilterTab('Strength', false),
              const SizedBox(width: 12),
              _buildFilterTab('Cardio', false),
              const SizedBox(width: 12),
              _buildFilterTab('Flexibility', false),
              const SizedBox(width: 12),
              _buildFilterTab('HIIT', false),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Your Workouts Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Workouts',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              'View All',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Workout List (Apple Fitness Style)
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _workoutPlans.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final plan = _workoutPlans[index];
            return _buildWorkoutCard(plan);
          },
        ),
      ],
    );
  }

  Widget _buildAIActionButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // AI workout generation
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.vibrantMint,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.glassBorder, width: 1.5),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.sparkles,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Generate AI Workout',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color:
            isSelected ? AppColors.primaryColor : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected
              ? AppColors.vibrantTeal
              : Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.black : Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(Map<String, dynamic> plan) {
    final lastUsedDays = [
      '2 days ago',
      'Yesterday',
      '1 week ago',
      '3 days ago'
    ];
    final index = _workoutPlans.indexOf(plan);
    final lastUsed =
        index < lastUsedDays.length ? lastUsedDays[index] : '5 days ago';

    return Container(
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
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: plan['color'],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                plan['icon'],
                color: Colors.white,
                size: 28,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Workout Info
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
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (plan['isAI'])
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'AI',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryColor,
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
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      plan['duration'],
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      CupertinoIcons.calendar,
                      size: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '3x week',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Last Used
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Last Used',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                lastUsed,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
